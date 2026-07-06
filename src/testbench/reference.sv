class ram_reference_model;

   ram_transaction ref_trans;

   mailbox #(ram_transaction) mbx_rs;
   mailbox #(ram_transaction) mbx_dr;
   virtual ram_if.REF_SB vif;

   bit [7:0] MEM [31:0];


  function new(mailbox #(ram_transaction) mbx_dr,mailbox #(ram_transaction) mbx_rs,virtual ram_if.REF_SB vif);
    this.mbx_dr=mbx_dr;
    this.mbx_rs=mbx_rs;
    this.vif=vif;
  endfunction

  //Task which mimics the functionality of the RAM
  task start();
    for(int i=0;i<`no_of_trans;i++)
     begin
      ref_trans=new();
     //getting the driver transaction from mailbox 
      mbx_dr.get(ref_trans);
      repeat(1) @(vif.ref_cb)
       begin 
        if(ref_trans.write_enb)
         MEM[ref_trans.address]=ref_trans.data_in;
       $display("REFERENCE MODEL DATA IN MEMORY MEM[ADDRESS]=%0d",MEM[ref_trans.address]);
        if(ref_trans.read_enb)
         ref_trans.data_out=MEM[ref_trans.address];
       $display("REFERENCE MODEL DATA OUT FROM MEMORY data_out=%0d",ref_trans.data_out);
       end
     //Putting the reference model transaction to mailbox 
      mbx_rs.put(ref_trans);
     end 
  endtask
endclass
 
