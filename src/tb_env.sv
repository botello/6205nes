

`ifndef TB_ENV_SV
`define TB_ENV_SV

`include "tb_driver.sv"
`include "tb_monitor.sv"

class tb_env extends component_base;

   protected virtual interface cpu_if vi;

   tb_driver driver;
   tb_monitor monitor;

   function new(string name = "tb_env");
      this.name = name;
      driver = new("driver");
      monitor = new("monitor");
   endfunction

   virtual function void assign_vi(virtual interface cpu_if vi);
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

