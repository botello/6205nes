// ============================================================
// Title       : CPU 
// Project     : NES
// File        : CPU.sv
// Description : Control Unit
// Revisions   : 
// ============================================================
// Author      : Nora Cristina Lopez Magaña and Carlos Vazquez
// Course      : 
// ============================================================

module NES_CPU(
  nes_if.cpu    nes_if0
  );
  
  cpu_if cpu_if0(
    .clk(nes_if0.phi2),
    .b_rst(nes_if0.b_rst),
    .b_nmi(nes_if0.b_nmi),
    .b_irq(nes_if0.b_irq)
  );

  alu_if alu_if0(
    .clk(nes_if0.phi2),
    .b_rst(nes_if0.b_rst)
  );

  CPU_DP CPU_DP_I0(
    .cu_if(cpu_if0),
    .ext_if(nes_if0),
    .alu_if(alu_if0)
  );

  CPU_CU CPU_CU_I0(
    .cpu_if0(cpu_if0),
    .alu_if0(alu_if0),
    .CU_phi2(nes_if0.phi2)
  );

endmodule: NES_CPU
