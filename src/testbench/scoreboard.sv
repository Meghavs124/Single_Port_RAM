class ram_scoreboard;

   ram_transaction ref2sb_trans,mon2sb_trans;

   mailbox #(ram_transaction) mbx_rs;

   mailbox #(ram_transaction) mbx_ms;

   bit [7:0] ref_mem [bit [31:0]]; 
   bit [7:0] mon_mem [bit [31:0]]; 
  //Variables to indicate no:of matches and mismatches
   int MATCH,MISMATCH;


  function new(mailbox #(ram_transaction) mbx_rs, mailbox #(ram_transaction) mbx_ms);
    this.mbx_rs=mbx_rs;
    this.mbx_ms=mbx_ms;
  endfunction

  task start();
    for(int i=0;i<`no_of_trans;i++)
      begin
        ref2sb_trans=new();
        mon2sb_trans=new();
       // fork 
          begin
          //getting the reference model transaction from mailbox 
           mbx_rs.get(ref2sb_trans);
           ref_mem[ref2sb_trans.address]=ref2sb_trans.data_out;
          $display("SCOREBOARD REFdata_out=%0d, ADDRESS=%0d",ref_mem[ref2sb_trans.address],ref2sb_trans.address);
          end
          begin
          //getting the monitor transaction from mailbox 
           mbx_ms.get(mon2sb_trans);
           mon_mem[mon2sb_trans.address]=mon2sb_trans.data_out;
         $display("SCOREBOARD MONdata_out=%0d,  ADDRESS=%0d",mon_mem[mon2sb_trans.address],mon2sb_trans.address);
          end
          compare_report();
     //   join
      end
  endtask

//Task which compares the memories and generates the report 
task compare_report();
     if(ref_mem[ref2sb_trans.address] == mon_mem[mon2sb_trans.address])
          begin
           $display("SCOREBOARD REFdata_out=%0d, MONdata_out=%0d",ref_mem[ref2sb_trans.address],mon_mem[mon2sb_trans.address]);
            MATCH++;
          $display("DATA MATCH SUCCESSFUL MATCH=%d",MATCH);
          end
        else
          begin
         $display("SCOREBOARD REFdata_out=%0d, MONdata_out=%0d",ref_mem[ref2sb_trans.address],mon_mem[mon2sb_trans.address]);
            MISMATCH++;
          $display("DATA MATCH FAILED MISMATCH=%d",MISMATCH);
          end
endtask
endclass

