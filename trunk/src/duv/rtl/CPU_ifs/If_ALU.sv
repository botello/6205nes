// ============================================================
// Title       : ALU interface
// Project     : 
// File        : if_alu.sv
// Description : ALU interface
// Revisions   : 0.0 - Initial Design
// ============================================================
// Author      : Carlos Vazquez
// Course      : Verification (EDCI-G5)
// ============================================================

interface alu_if #(
    // Internal Parameters
    parameter Dt_sz = 8,          // Data size
    parameter Ad_sz = 2*Dt_sz,    // Address size
    parameter Op_sz = 2
  )(
  /* System Interface */
    input clk,    // CPU Clock
    input b_rst   // System Reset
  );
  
	logic [Op_sz-1:0] ALU_Funct;	 	     // Operation Code
 	logic [Op_sz-1:0] ALU_OpB_Funct;    // Operation Code for OpB
 	logic             ALU_OpB_FunctEn;  // Operation Enable for OpB
 	logic [Dt_sz-1:0] OpA;			           // Operator A
	logic [Dt_sz-1:0] OpB;			           // Operator B  
	logic             Cin;              // Carry in for ADD    
	logic [Dt_sz-1:0] ALU_Rslt;		      // Result
	wire              CFlg;            // Carry out Flag  
	wire              NFlg;            // Negative Flag
	wire              VFlg;            // Overflow Flag
	wire              ZFlg;            // Zero Flag

  modport slv (
    // Inputs
    input ALU_Funct, ALU_OpB_Funct, ALU_OpB_FunctEn, Cin, OpA, OpB,
    // Outputs
 	  output 	ALU_Rslt, CFlg, NFlg, VFlg, ZFlg
  );
   	
  modport mstr (
    // Outputs
    output ALU_Funct, ALU_OpB_Funct, ALU_OpB_FunctEn, Cin,
    // Inputs
 	  input ALU_Rslt, CFlg, NFlg, VFlg, ZFlg
  );

endinterface: alu_if
