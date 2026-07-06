class ram_generator;

  ram_transaction  blueprint;

  mailbox #(ram_transaction)mbx_gd;

  function new(mailbox #(ram_transaction)mbx_gd);
    this.mbx_gd=mbx_gd;
    blueprint=new();
  endfunction

  task start();
    for(int i=0;i<`no_of_trans;i++)
      begin
        blueprint.randomize();    
        mbx_gd.put(blueprint.copy());  
        $display("GENERATOR Randomized transaction data_in=%0d,write_enb=%0d,read_enb=%0d,address=%0d", blueprint.data_in,blueprint.write_enb,blueprint.read_enb,blueprint.address);
      end
  endtask
endclass
