

`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "tb_cpu_if.sv"
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
   tb_cpu_if tb_cpu_intf(cpu_duv_intf, cpu_ref_intf);

   tb_env env;
   initial begin
      env = new();
      env.assign_vi(tb_cpu_intf);
      env.start_test();
   end

   initial begin : rst_gen_proc
      tb_cpu_intf.b_rst   = 'h0;
      #51;
      tb_cpu_intf.b_rst   = 'h1;
   end

   initial begin : clk_gen_proc
      tb_cpu_intf.clk = 1'b0;
      forever #5 tb_cpu_intf.clk = ~tb_cpu_intf.clk;
   end

endmodule

`endif

