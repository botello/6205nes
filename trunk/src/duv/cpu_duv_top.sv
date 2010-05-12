

`ifndef CPU_DUV_TOP_SV
`define CPU_DUV_TOP_SV

`include "CPU_source/Parameters.v"
`include "CPU_source/macros.v"

`include "CPU_ifs/If_ALU.sv"
`include "CPU_ifs/If_CPU.sv"
`include "CPU_ifs/If_CU.sv"
`include "CPU_ifs/If_NES.sv"

`include "CPU_source/CPU.sv"
`include "CPU_source/CPU_CU.sv"
`include "CPU_source/CPU_CU_CtlGen.sv"
`include "CPU_source/CPU_CU_FSM.sv"
`include "CPU_source/CPU_CU_IntCpt.sv"
`include "CPU_source/CPU_DP.sv"
`include "CPU_source/CPU_DP_ALU.sv"

module cpu_duv_top(tb_cpu_if.cpu intf);

   nes_if nes_intf(
      .NES_clk   ( intf.clk   ),
      .NES_b_rst ( intf.b_rst )
   );

   NES_CPU nes_cpu(
      .nes_if0 ( nes_intf.cpu )
   );

   always_comb begin : signal_assign_proc
      nes_intf.clk   = intf.clk;
      nes_intf.b_rst = intf.b_rst;
      nes_intf.b_nmi = intf.b_nmi;
      nes_intf.b_irq = intf.b_irq;
      intf.syn_clk   = nes_intf.phi2;
      intf.ren       =  nes_intf.r_bw;
      intf.wen       = ~nes_intf.r_bw;
      intf.cpu_addr_out = nes_intf.addr;
      nes_intf.data_in  = (intf.ren) ? intf.cpu_data_in  : 'hZ;
      intf.cpu_data_out = (intf.wen) ? nes_intf.data_out : 'hZ;
   end

endmodule

`endif

