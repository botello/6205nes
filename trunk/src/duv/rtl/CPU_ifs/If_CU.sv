// ============================================================
// Title       : CU internal interface
// Project     : 
// File        : if_cu.sv
// Description : Internal CU interface
// Revisions   : 0.0 - Initial Design
// ============================================================
// Author      : Carlos Vazquez
// Course      : Verification (EDCI-G5)
// ============================================================

interface cu_if (
  /* CPU Interface */
    input clk,    // CPU Clock
    input b_rst,   // CPU Reset
    input b_nmi,
    input b_irq
  );
  
  // 
  logic [5:0] cur_state; 
  logic [5:0] nxt_state;
  logic birq_flg, bnmi_flg;
 	logic bnmi_sd, birq_sd;
 	logic [2:0] instrX;
 	logic [2:0] instrY;
 	logic [1:0] instrZ;
  logic [2:0] pst_instrX;
  logic [2:0] pst_instrY;
  logic [1:0] pst_instrZ;
  logic alu_cflg, opb_sign, dma_bflg,
        i_flg, n_flg, v_flg, c_flg, z_flg;
  logic [7:0] dma_by;

  modport fsm (
    // FSM Outputs
    output cur_state, nxt_state,
    // FSM Inputs
    input birq_flg, bnmi_flg,
          alu_cflg, opb_sign,
          i_flg, n_flg, v_flg, c_flg, z_flg,
          instrX,instrY, instrZ, 
          pst_instrX, pst_instrY, pst_instrZ,
          dma_bflg, dma_by
  );

  modport intcpt (
    // Interrupt Capture Outputs
    output birq_flg, bnmi_flg,
    // Interrupt Capture Inputs
    input bnmi_sd, birq_sd
  );

  modport ctlgen (
    // Control Signal Generator Inputs
    input cur_state, nxt_state,
          birq_flg, bnmi_flg,
    // Control Signal Generator Outputs
 	  output bnmi_sd, birq_sd,
 	         instrX,instrY, instrZ, 
           pst_instrX, pst_instrY, pst_instrZ,
           dma_bflg, dma_by,
           alu_cflg, opb_sign,
           i_flg, n_flg, v_flg, c_flg, z_flg
  );

endinterface: cu_if
