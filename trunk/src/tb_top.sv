

`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "cpu_if.sv"
`include "cpu_ref_if.sv"
`include "cpu_ref_top.sv"
`include "mem_ref_top.sv"
`include "cpu_duv_if.sv"
`include "cpu_duv_top.sv"
`include "mem_duv_top.sv"

module tb_top();

   `include "tb.svh"

   // Design Under Verification.
   cpu_duv_if  cpu_duv_intf();
   cpu_duv_top cpu_duv_top(cpu_duv_intf.cpu);
   mem_duv_top mem_duv_top(cpu_duv_intf.mem);
   // Reference Model.
   cpu_ref_if  cpu_ref_intf();
   cpu_ref_top cpu_ref_top(cpu_ref_intf.cpu);
   mem_ref_top mem_ref_top(cpu_ref_intf.mem);
   // General interface.
   cpu_if cpu_intf(cpu_duv_intf, cpu_ref_intf);

   tb_env env;
   initial begin
      env = new();
      env.assign_vi(cpu_intf);
      env.start_test();
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

