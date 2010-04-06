
`ifndef TB_ENV
`define TB_ENV

`include "tb_driver.sv"
`include "tb_monitor.sv"

class tb_env;

   protected virtual interface cpu_intf vi;

   tb_driver driver;
   tb_monitor monitor;

   function new(string name = "tb_env");
      driver = new("driver");
      monitor = new("monitor");
   endfunction

   virtual function void assign_vi(virtual interface cpu_intf vi);
      this.vi = vi;
      driver.assign_vi(vi);
      monitor.assign_vi(vi);
   endfunction

   virtual task run();
      fork
         driver.run();
         monitor.run();
      join_none
   endtask

endclass

`endif

