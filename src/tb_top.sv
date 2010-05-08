

`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "tb_cpu_if.sv"
`include "mem_top.sv"
`include "cpu_ref_top.sv"
`include "cpu_duv_top.sv"

module tb_top();

   import tb_pkg::*;
   import mem_pkg::*;

   `include "tb.svh"

   // Design Under Verification.
   tb_cpu_if   cpu_duv_intf();
   mem_top     mem_duv_top(cpu_duv_intf.mem);
   cpu_duv_top cpu_duv_top(cpu_duv_intf.cpu);
   // Reference Model.
   tb_cpu_if   cpu_ref_intf();
   mem_top     mem_ref_top(cpu_ref_intf.mem);
   cpu_ref_top cpu_ref_top(cpu_ref_intf.cpu);

   tb_env env;
   initial begin
      env = new();
      //
      // TODO: right now, we are only using the reference model.
      //
      env.assign_vi(cpu_ref_intf.tb);
      //env.assign_vi(cpu_duv_intf.tb);
      env.start_test();
   end

   initial begin : clk_gen_proc
      cpu_ref_intf.clk = 'h0;
      cpu_duv_intf.clk = 'h0;
      forever begin
         #5;
         cpu_ref_intf.clk = ~cpu_ref_intf.clk;
         cpu_duv_intf.clk = ~cpu_duv_intf.clk;
      end
   end

endmodule

`endif

