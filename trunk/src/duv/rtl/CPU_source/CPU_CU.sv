// ============================================================
// Title       : CPU CU
// Project     : NES
// File        : CPU_CU.sv
// Description : Control Unit
// Revisions   : 
// ============================================================
// Author      : Nora Cristina Lopez Magaña and Carlos Vazquez
// Course      : 
// ============================================================

module CPU_CU(
  cpu_if.cu     cpu_if0,
  alu_if.mstr   alu_if0,
  input CU_phi2
  );
  
  cu_if cu_if0(
    .clk(CU_phi2),
    .b_rst(cpu_if0.b_rst),
    .b_nmi(cpu_if0.b_nmi),
    .b_irq(cpu_if0.b_irq)
  );

  CU_IntCpt CU_IntCpt_I0(
    .cu_if0(cu_if0),
    .CU_bNMI(cpu_if0.b_nmi), 
    .CU_bIRQ(cpu_if0.b_irq)
  );
  
  CU_CtlGen CU_CtlGen_I0(
    .cpu_if0,
    .alu_if0,
    .cu_if0(cu_if0),
    .CU_phi2, 
    .CU_bRST(cpu_if0.b_rst)
  );
  
  CU_FSM CU_FSM_I0(
    .cu_if0(cu_if0),
    .CU_phi2, 
    .CU_bRST(cpu_if0.b_rst)
  );        

endmodule: CPU_CU
