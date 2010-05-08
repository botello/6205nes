

`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "tb_cpu_if.sv"
`include "mem_top.sv"
`include "cpu_ref_top.sv"
`include "cpu_duv_top.sv"
`include "tb_coverage.sv"

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

   tb_coverage tb_coverage (
      .cpu_ref_intf(cpu_ref_intf),
      .cpu_duv_intf(cpu_duv_intf)
   );

   tb_env tb_env_duv, tb_env_ref;
   initial begin
      tb_env_duv = new("duv");
      tb_env_duv.assign_vi(cpu_duv_intf.tb);

      tb_env_ref = new("ref");
      tb_env_ref.assign_vi(cpu_ref_intf.tb);

      fork
         tb_env_duv.start_test();
         tb_env_ref.start_test();
      join
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

   always_comb begin : vi_signal_assign
      cpu_ref_intf.q_a_o_i = cpu_ref_top.refmodel.q_a_o_i;
      cpu_ref_intf.q_x_o_i = cpu_ref_top.refmodel.q_x_o_i;
      cpu_ref_intf.q_y_o_i = cpu_ref_top.refmodel.q_y_o_i;
      cpu_ref_intf.opcode = cpu_ref_top.refmodel.U_4.zw_REG_OP;
      cpu_ref_intf.fsm_current_state = cpu_ref_top.refmodel.U_4.current_state;
      cpu_ref_intf.mem_rom_r = mem_ref_top.mem_rom_r;
      cpu_ref_intf.mem_ram_r = mem_ref_top.mem_ram_r;
      cpu_ref_intf.mem_sram_r = mem_ref_top.mem_sram_r;
      cpu_ref_intf.mem_ioreg_r = mem_ref_top.mem_ioreg_r;

      //
      // TODO: Assign actual register and signals from DUV to interface.
      //
      cpu_duv_intf.q_a_o_i = cpu_duv_top.nes_cpu.CPU_DP_I0.DP_ACC;
      cpu_duv_intf.q_x_o_i = cpu_duv_top.nes_cpu.CPU_DP_I0.DP_XR;
      cpu_duv_intf.q_y_o_i = cpu_duv_top.nes_cpu.CPU_DP_I0.DP_YR;
      //cpu_duv_intf.opcode = cpu_duv_top.nes_cpu.U_4.zw_REG_OP;
      //cpu_duv_intf.fsm_current_state = cpu_duv_top.nes_cpu.U_4.current_state;
      cpu_duv_intf.mem_rom_r = mem_duv_top.mem_rom_r;
      cpu_duv_intf.mem_ram_r = mem_duv_top.mem_ram_r;
      cpu_duv_intf.mem_sram_r = mem_duv_top.mem_sram_r;
      cpu_duv_intf.mem_ioreg_r = mem_duv_top.mem_ioreg_r;
   end

endmodule

`endif

