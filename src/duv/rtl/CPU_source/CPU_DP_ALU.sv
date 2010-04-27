// ============================================================
// Title       : NES ALU
// Project     : NES
// File        : NES_ALU.v
// Description : Arithmetic-Logic Unit used in the NES datapath
// Revisions   : 
// ============================================================
// Author      : Carlos Vazquez
// Course      : 
// ============================================================

module NES_ALU #(parameter NumB=8)(
  alu_if.slv  alu_if,
	input [NumB-1:0] OpA,			           // Operator A
	input [NumB-1:0] OpB			           // Operator B  
  );
  //parameter NumB=8;
  /********************************************
  *         Operation Codes Parameters        *
  ********************************************/  
  // ALU operation
  parameter OR  = 2'b00;    // OpA OR OpB operation
  parameter AND = 2'b01;    // OpA AND OpB operation
  parameter XOR = 2'b10;    // OpA XOR OpB operation
  parameter ADC = 2'b11;    // OpA ADD OpB operation
  
  // ALU OpB operation
  parameter SHR = 2'b00;    // Shit Right OpB
  parameter SHL = 2'b01;    // Shit Left OpB
  parameter INC = 2'b10;    // Increment in 1 OpB
  parameter DEC = 2'b11;    // Decrement in 1 OpB
  
  
  /********************************************
  *           Internal Connections            *
  ********************************************/
  reg [NumB-1:0] OpB_reg;
  reg            CShFlg_reg;
  reg            CAdFlg_reg;
  
  /********************************************
  *             ALU OpB Operation             *
  ********************************************/
  always @*
  begin
    if(alu_if.ALU_OpB_FunctEn)
      case (alu_if.ALU_OpB_Funct)
        SHR:     {OpB_reg, CShFlg_reg} = {alu_if.Cin, OpB[NumB-1:0]};
        SHL:     {CShFlg_reg, OpB_reg} = {OpB[NumB-1:0], alu_if.Cin};
        INC:     {CShFlg_reg, OpB_reg} = OpB + 1'b1;
        DEC:     {CShFlg_reg, OpB_reg} = OpB - 1'b1;
        default: {CShFlg_reg, OpB_reg} = {1'b0, OpB};
      endcase
    else
      {CShFlg_reg, OpB_reg} = {1'b0, OpB};
  end
  
  
  /********************************************
  *               ALU Operation               *
  ********************************************/
  always @*
  begin
    case (alu_if.ALU_Funct)
      OR:       {CAdFlg_reg, alu_if.ALU_Rslt} = {1'b0, OpA | OpB_reg};
      AND:      {CAdFlg_reg, alu_if.ALU_Rslt} = {1'b0, OpA & OpB_reg};
      XOR:      {CAdFlg_reg, alu_if.ALU_Rslt} = {1'b0, OpA ^ OpB_reg};
      ADC:      {CAdFlg_reg, alu_if.ALU_Rslt} = OpA + OpB_reg + alu_if.Cin;
      default:  {CAdFlg_reg, alu_if.ALU_Rslt} = {1'b0, OpA | OpB_reg};
    endcase
  end
  
  
  /********************************************
  *                   Flags                   *
  ********************************************/
  // Negative Flag
  assign alu_if.NFlg = alu_if.ALU_Rslt[NumB-1];
  
  // Zero Flag
  assign alu_if.ZFlg = (alu_if.ALU_Rslt) ? 1'b0 : 1'b1;
  
  // Overflow Flag
  assign alu_if.VFlg = (alu_if.ALU_Funct == AND) ? alu_if.ALU_Rslt[NumB-2] : 1'bZ;
  assign alu_if.VFlg = (alu_if.ALU_Funct == ADC) ? ( (OpA[NumB-1] ~^ OpB_reg[NumB-1]) & (OpA[NumB-1] ^ alu_if.ALU_Rslt[NumB-1]) ) : 1'bZ;
  assign alu_if.VFlg = ( (alu_if.ALU_Funct == OR) | (alu_if.ALU_Funct == XOR) ) ? 1'b0 : 1'bZ;
  
  // Carry Flag
  assign alu_if.CFlg = (alu_if.ALU_Funct == ADC) ? CAdFlg_reg : CShFlg_reg;

endmodule:NES_ALU
