
`ifndef TB_TOP_SV
`define TB_TOP_SV

module tb_top();

   import tb_pkg::*;
   `include "tb_env.sv"

   cpu_intf cpu_intf();
   mem_top mem_top(cpu_intf.mem);
   cpu_top cpu_top(cpu_intf.cpu);

   tb_env env;
   initial begin
      env = new();
      env.assign_vi(cpu_intf);
      env.run();
   end

   initial begin
      cpu_intf.nmi = 1'b0;
      cpu_intf.irq = 1'b0;
      cpu_intf.rst = 1'b1;
      #50;
      cpu_intf.rst = 1'b0;
   end

   initial begin
      cpu_intf.clk = 1'b0;
      forever #5 cpu_intf.clk = ~cpu_intf.clk;
   end

endmodule

`endif

