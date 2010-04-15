

`ifndef TB_ENV_SV
`define TB_ENV_SV

`include "tb_driver.sv"
`include "tb_monitor.sv"

class tb_env extends component_base;

   protected virtual interface cpu_if vi;

   tb_driver driver;
   tb_monitor monitor;
   tb_generator generator;

   function new(string name = "tb_env", component_base parent = null);
      this.name = name;
      this.parent = parent;
      driver = new("driver", this);
      monitor = new("monitor", this);
      generator = new("generator", this);
   endfunction

   virtual function void assign_vi(virtual interface cpu_if vi);
      this.vi = vi;
      driver.assign_vi(vi);
      monitor.assign_vi(vi);
   endfunction

   // Entry point where test is launched.
   virtual task start_test();
      configure();
      run();
      report();
   endtask

   function void configure();
      driver.configure();
      monitor.configure();
      generator.configure();
   endfunction

   virtual task run();
      fork
         driver.run();
         monitor.run();
         generator.run();
      join
   endtask

   virtual function void report();
      driver.report();
      monitor.report();
      generator.report();
   endfunction

endclass

`endif

