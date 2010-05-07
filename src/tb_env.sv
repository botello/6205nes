

`ifndef TB_ENV_SV
`define TB_ENV_SV

`include "tb_driver.sv"
`include "tb_monitor.sv"

class tb_env extends component_base;

   protected virtual tb_cpu_if vi;
   tb_driver driver;
   tb_monitor monitor;
   tb_generator generator;
   tb_scoreboard scoreboard;

   mailbox #(request_item) generator_to_driver_mbox;
   mailbox #(response_item) driver_to_scoreboard_mbox;

   function new(string name = "tb_env", component_base parent = null);
      this.name = name;
      this.parent = parent;
      driver = new("driver", this);
      monitor = new("monitor", this);
      generator = new("generator", this);
      scoreboard = new("scoreboard", this);
      generator_to_driver_mbox = new();
      driver_to_scoreboard_mbox = new();
   endfunction

   virtual function void assign_vi(virtual interface tb_cpu_if vi);
      this.vi = vi;
      driver.assign_vi(vi);
      monitor.assign_vi(vi);
   endfunction

   // Entry point where test is launched.
   virtual task start_test();
      connect();
      configure();
      run();
      report();
      //$finish();
   endtask

   virtual function void connect();
      generator.outbox = generator_to_driver_mbox;
      driver.inbox = generator_to_driver_mbox;
      driver.outbox = driver_to_scoreboard_mbox;
      scoreboard.inbox = driver_to_scoreboard_mbox;
   endfunction

   virtual function void configure();
      driver.configure();
      monitor.configure();
      generator.configure();
      scoreboard.configure();
   endfunction

   virtual task run();
      fork
         monitor.run();
      join_none
      fork
         driver.run();
         generator.run();
         scoreboard.run();
      join
   endtask

   virtual function void report();
      driver.report();
      monitor.report();
      generator.report();
      scoreboard.report();
   endfunction

endclass

`endif

