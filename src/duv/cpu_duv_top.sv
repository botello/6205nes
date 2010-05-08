

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

/*
   nes_if nes_intf(
      .NES_clk   ( intf.clk   ),
      .NES_b_rst ( intf.b_rst )
   );

   NES_CPU nes_cpu(
      .nes_if ( nes_intf.cpu )
   );
*/
endmodule

`endif

