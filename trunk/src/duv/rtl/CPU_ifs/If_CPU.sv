// ============================================================
// Title       : CPU internal interface
// Project     : 
// File        : if_cpu.sv
// Description : Internal CPU interface
// Revisions   : 0.0 - Initial Design
// ============================================================
// Author      : Carlos Vazquez
// Course      : Verification (EDCI-G5)
// ============================================================

interface cpu_if #(
    // Internal Parameters
    parameter Dt_sz = 8,     // Data size
    parameter Ad_sz = 2*Dt_sz,    // Tag size
    parameter Op_sz = 2      // 
  )(
  /* CPU Interface */
    input clk,    // CPU Clock
    input b_rst,   // CPU Reset
    input b_nmi,
    input b_irq
  );
  
  // Internal Connections From DP
    logic [Dt_sz-1:0] DP_InstrR;
    logic [Dt_sz-1:0] DP_PstInstrR;
    logic [Dt_sz-1:0] DP_DMA_By;
    logic           DP_bDMA_Flg,
                    DP_OpB_sign,
    //Processor Status Flags (P register)
          DP_ZFlg,
          DP_NFlg,
          DP_CFlg,
          DP_VFlg,
          DP_IFlg,
    //Clock Phases
          DP_phi1,
          DP_phi2;
  
  // Internal Connections From CU
    logic CU_R_bW,
    // DP Regs Enables
          CU_PCH_EN,
          CU_PCL_EN,
          CU_SP_EN,
          CU_ABL_EN,
          CU_ABH_EN,
          CU_DIR_EN,
          CU_DMA_By_EN,
          CU_InstrR_EN,
          CU_PstInstrR_EN,
          CU_PstInstrR_Clr,    //NOTE: Added to remove last instruction executed before the interrupt in the Past Instruction Register
          CU_XR_EN,
          CU_YR_EN,
          CU_ACC_EN,
          CU_OpA_EN,
          CU_OpB_EN;
    // Mux Selectors
    logic [2:0] CU_PCB_Sel;
    logic [2:0] CU_ADL_Sel;
    logic [2:0] CU_ADH_Sel;
    logic [2:0] CU_DB_Sel;
    logic [2:0] CU_SB_Sel;
    logic       CU_OpAB_Sel;
    logic [1:0] CU_OpBB_Sel;
    // Status Flag buses
    logic CU_NFlgB,
          CU_VFlgB,
          CU_BFlgB,
          CU_DFlgB,
          CU_IFlgB,
          CU_ZFlgB,
          CU_CFlgB,
    // Status Flag Enables
          CU_PR_EN,
          CU_NFlg_EN,
          CU_VFlg_EN,
          CU_BFlg_EN,
          CU_DFlg_EN,
          CU_IFlg_EN,
          CU_ZFlg_EN,
          CU_CFlg_EN;

  modport dp (
    // DP Inputs
    input clk, b_rst, b_nmi, b_irq,
          CU_R_bW,
          // DP Regs Enables
          CU_PCH_EN, CU_PCL_EN, CU_SP_EN, CU_ABL_EN, CU_ABH_EN, CU_DIR_EN, CU_DMA_By_EN, CU_InstrR_EN,
          CU_PstInstrR_EN, CU_PstInstrR_Clr,
          CU_XR_EN, CU_YR_EN, CU_ACC_EN, CU_OpA_EN, CU_OpB_EN,
          // Mux Selectors
          CU_PCB_Sel, CU_ADL_Sel, CU_ADH_Sel, CU_DB_Sel, CU_SB_Sel, CU_OpAB_Sel, CU_OpBB_Sel,
          // Status Flag buses
          CU_NFlgB, CU_VFlgB, CU_BFlgB, CU_DFlgB, CU_IFlgB, CU_ZFlgB, CU_CFlgB,
          // Status Flag Enables
          CU_PR_EN, CU_NFlg_EN, CU_VFlg_EN, CU_BFlg_EN, CU_DFlg_EN, CU_IFlg_EN, CU_ZFlg_EN, CU_CFlg_EN,
    // DP Outputs
 	  output DP_InstrR, DP_PstInstrR, DP_DMA_By, DP_bDMA_Flg, DP_OpB_sign,
          //Processor Status Flags (P register)
          DP_ZFlg, DP_NFlg, DP_CFlg, DP_VFlg, DP_IFlg,
          //Clock Phases
          DP_phi1, DP_phi2
  );
   	
  modport cu (
    // CU Inputs
    input clk, b_rst, b_nmi, b_irq,
          DP_InstrR, DP_PstInstrR, DP_DMA_By, DP_bDMA_Flg, DP_OpB_sign,
          //Processor Status Flags (P register)
          DP_ZFlg, DP_NFlg, DP_CFlg, DP_VFlg, DP_IFlg,
          //Clock Phases
          DP_phi1, DP_phi2,
    // CU Outputs
 	  output CU_R_bW,
          // DP Regs Enables
          CU_PCH_EN, CU_PCL_EN, CU_SP_EN, CU_ABL_EN, CU_ABH_EN, CU_DIR_EN, CU_DMA_By_EN, CU_InstrR_EN,
          CU_PstInstrR_EN, CU_PstInstrR_Clr,
          CU_XR_EN, CU_YR_EN, CU_ACC_EN, CU_OpA_EN, CU_OpB_EN,
          // Mux Selectors
          CU_PCB_Sel, CU_ADL_Sel, CU_ADH_Sel, CU_DB_Sel, CU_SB_Sel, CU_OpAB_Sel, CU_OpBB_Sel,
          // Status Flag buses
          CU_NFlgB, CU_VFlgB, CU_BFlgB, CU_DFlgB, CU_IFlgB, CU_ZFlgB, CU_CFlgB,
          // Status Flag Enables
          CU_PR_EN, CU_NFlg_EN, CU_VFlg_EN, CU_BFlg_EN, CU_DFlg_EN, CU_IFlg_EN, CU_ZFlg_EN, CU_CFlg_EN
  );

endinterface: cpu_if