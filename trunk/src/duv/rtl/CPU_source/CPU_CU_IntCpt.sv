// ============================================================
// Title       : CU Interrupt Capture
// Project     : NES
// File        : CPU_CU_IntCpt.sv
// Description : This module captures the NMI and IRQ interrupt
//  requests, even though RST is considered an interrupt it is
//  handled directly by the FSM.
// Revisions   : 
// ============================================================
// Author      : Nora Cristina Lopez Magaña and Carlos Vazquez
// Course      : 
// ============================================================

module CU_IntCpt(
  cu_if.intcpt cu_if0,       // Interface with the rest of the CU
  input CU_bNMI, CU_bIRQ    // NMI and IRQ Interrupt Requests
  );

`include "../CPU_source/Parameters.v"

  // Flags generated after an interrupt request
  logic CU_bNMI_Flg;
  logic CU_bIRQ_Flg;
  
  // Control Signals to clear flags after interrupt sequence
  logic CU_bNMI_SD;
  logic CU_bIRQ_SD;

  always_comb
    begin
      cu_if0.bnmi_flg = CU_bNMI_Flg;
      cu_if0.birq_flg = CU_bIRQ_Flg;

      CU_bNMI_SD = cu_if0.bnmi_sd;
      CU_bIRQ_SD = cu_if0.birq_sd;      
    end

  
always @ (negedge CU_bNMI or negedge CU_bNMI_SD)
  begin
    if (~CU_bNMI_SD)//CU_bNMI_SD)
      CU_bNMI_Flg <= bOff;//bOn;
    else
      CU_bNMI_Flg <= bOn;//bOff;
  end
  
always @ (negedge CU_bIRQ or negedge CU_bIRQ_SD)
  begin
    if (~CU_bIRQ_SD)
      CU_bIRQ_Flg <= bOff;
    else
      CU_bIRQ_Flg <= bOn;
  end

endmodule:CU_IntCpt