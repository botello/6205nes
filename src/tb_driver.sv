

`ifndef TB_DRIVER
`define TB_DRIVER

class tb_driver;

   protected virtual cpu_intf vi;

   function new(string name = "tb_driver");
   endfunction

   virtual function void assign_vi(virtual interface cpu_intf vi);
      this.vi = vi;
   endfunction

   virtual task run();
   endtask

endclass

`endif

