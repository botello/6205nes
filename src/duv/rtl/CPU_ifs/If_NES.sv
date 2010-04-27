// ============================================================
// Title       : CPU interface with NES
// Project     : 
// File        : if_nes.sv
// Description : External CPU interface
// Revisions   : 0.0 - Initial Design
// ============================================================
// Author      : Carlos Vazquez
// Course      : Verification (EDCI-G5)
// ============================================================

interface nes_if #(
    // Internal Parameters
    parameter Dt_sz = 8,     // Data size
    parameter Ad_sz = 16     // Address size
  )(
  /* System Interface */
    input NES_clk,    // System Clock
    input NES_b_rst   // System Reset
  );
  
   
  // 6502 Signals     
    logic clk,      // CPU Clock
          phi2;     // Clock phase (in phase with clk)
    
                    //                                                    LOW     HIGH
 	  logic b_rst,    // Reset interrupt          (interrupt vector in:     $FFFC   $FFFD)
 	        b_nmi,    // Non Maskeable Interrupt  (interrupt vector in:     $FFFA   $FFFB)
 	        b_irq;    // Interrupt Request        (interrupt vector in:     $FFFE   $FFFF)

    logic r_bw;     // Data direction bit ('1' for Read  - cpu input 
                    //          	          '0' for Write - cpu output)

    logic [Ad_sz-1:0] addr;   // Address of memory
 	  wire  [Dt_sz-1:0] data;   // Data bus


  modport cpu (
    // CPU Inputs
    input clk,
          b_rst, 
          b_nmi, 
          b_irq,
    // CPU Outputs
 	  output phi2,
 	         addr,
 	         r_bw,
 	  // CPU InOuts
 	  inout data
  );
   	
  modport nes (
    // NES Generated
    output clk, 
           b_rst, 
           b_nmi, 
           b_irq,
    // NES Read
 	  input phi2,
 	        addr,
 	        r_bw,
 	  // NES Bidirectional
 	  inout data
  );

endinterface: nes_if