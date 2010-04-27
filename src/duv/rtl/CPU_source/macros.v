  /********************************************
  *         Addressing Modes Decoder          *
  ********************************************/

// INC and DEC, shifts and rotates in (ZP,X) Addressing Modes
`define ZP_X_Inc_Dec  (((CU_InstrX[2:1]==2'b11)|(CU_InstrX[2]==1'b0))&(CU_InstrY==3'b101)&(CU_InstrZ==2'b10))

// Logic Arithmetic, loads and stores in (ZP,X) and (ZP,Y) Addressing Modes
`define ZP_XY  ((CU_InstrY==3'b101)&(((CU_InstrX[2:1]==2'b10)&(CU_InstrZ[0]==1'b0))|(CU_InstrZ==2'b01)))

`define ZP_Y  ((CU_InstrX[2:1]==2'b10)&(CU_InstrZ==2'b10))

// Logic Arithmetic in (Ind,Y)
`define Ind_Y ((CU_InstrY==3'b100)&(CU_InstrZ==2'b01))

// Logic Arithmetic, loads and store (A) in (Abs,X) and (Abs,Y) Addressing Modes
`define Abs_XY (((CU_InstrY[2:1]==2'b11)&(CU_InstrZ==2'b01))|((CU_InstrX==3'b101)&(CU_InstrY==3'b111)&(CU_InstrZ[0]==1'b0)))

// INC, DEC, Shifts and Rotates in (Abs,X) Addressing Mode
`define Abs_X_Inc_Dec_Sh_Rot (((CU_InstrX[2]==1'b0)|(CU_InstrX[2:1]==2'b11))&(CU_InstrY==3'b111)&(CU_InstrZ==2'b10))

// Logic Arithmetic, Loads and Compares with #Immediate Data
//ORIGINAL: Not excluding not existent STA,#Imm
//`define Immediate (((CU_InstrY==3'b010)&(CU_InstrZ==2'b01))|((CU_InstrY==3'b000)&(((CU_InstrX==3'b101)&(CU_InstrZ[0]==1'b0))|((CU_InstrX[2:1]==2'b11)&(CU_InstrZ==2'b00)))))
//CHANGE: Excluding not existent STA,#Imm
`define Immediate (((CU_InstrY==3'b010)&(CU_InstrZ==2'b01)&(CU_InstrX!=3'b100))|((CU_InstrY==3'b000)&(((CU_InstrX==3'b101)&(CU_InstrZ[0]==1'b0))|((CU_InstrX[2:1]==2'b11)&(CU_InstrZ==2'b00)))))

// Implied Transfers, Clears, Sets, Decrements and Increments, of X and Y, and Shifts and Rotates of A
`define Implied_Transf_Clr_Set_Dex_Inx_Acc ((((((CU_InstrX[2]==1'b0)|(CU_InstrX[2:1]==2'b11))&(CU_InstrY==3'b010))|((CU_InstrX[2:1]==2'b10)&(CU_InstrY[1:0]==2'b10)))&(CU_InstrZ==2'b10))|(((CU_InstrY==3'b110)|((CU_InstrX[2]==1'b1)&(CU_InstrY==3'b010)))&(CU_InstrZ==2'b00)))

// Logic Arithmetic, BIT, Loads and Compares in (Abs) Addressing Mode
//ORIGINAL: Excluding Stores in X and Y
//`define Abs_AL_BIT_LDs_Cmp ((CU_InstrY==3'b011)&((CU_InstrZ==2'b01)|((CU_InstrX==3'b101)&(CU_InstrZ[0]==0))|((CU_InstrZ==2'b00)&((CU_InstrX[2:1]==2'b11)|(CU_InstrX==3'b001)))))
//CHANGE: Including Stores in X and Y
`define Abs_AL_BIT_LDs_Cmp ((CU_InstrY==3'b011)&((CU_InstrZ==2'b01)|((CU_InstrX[2:1]==2'b10)&(CU_InstrZ[0]==1'b0))|((CU_InstrZ==2'b00)&((CU_InstrX[2:1]==2'b11)|(CU_InstrX==3'b001)))))

// Increment, Decrement, Shifts and Rotates in (Abs) Addressing Mode
//ORIGINAL: don't use X,Y,Z
//`define Abs_Inc_Dec_Sh_Rot (((CU_InstrR[7]==0)&(CU_InstrR[4:2]==3'b011)&(CU_InstrR[1:0]==2'b10))|((CU_InstrR[7:6]==2'b11)&(CU_InstrR[4:2]==3'b011)&(CU_InstrR[1:0]==2'b10)))
`define Abs_Inc_Dec_Sh_Rot (((CU_InstrX[2]==1'b0)|(CU_InstrX[2:1]==2'b11))&(CU_InstrY==3'b011)&(CU_InstrZ==2'b10))

// Jump in (Abs) Addressing Mode
`define Abs_JMP ((CU_InstrX==3'b010)&(CU_InstrY==3'b011)&(CU_InstrZ==2'b00))

// Jump in @(Ind) Addressing Mode
`define Ind_JMP ((CU_InstrX==3'b011)&(CU_InstrY==3'b011)&(CU_InstrZ==2'b00))

// Branches in Relative Addressing Mode
`define Relative ((CU_InstrY==3'b100)&(CU_InstrZ==2'b00))

// Logic Arithmetic in (Ind),X Addressing Mode
`define Ind_X_AL ((CU_InstrY==3'b000)&(CU_InstrZ==2'b01))

// Increment, Decrement, Shifts and Rotates in (ZP) Addressign Mode
//ORIGINAL: ERROR: CU_InstrZ[1] instead of CU_InstrX[2]
//`define ZP_Inc_Dec_Sh_Rot (((CU_InstrZ[1]==0)|(CU_InstrX[2:1]==2'b11))&(CU_InstrY==3'b001)&(CU_InstrZ==2'b10))
`define ZP_Inc_Dec_Sh_Rot (((CU_InstrX[2]==1'b0)|(CU_InstrX[2:1]==2'b11))&(CU_InstrY==3'b001)&(CU_InstrZ==2'b10))

// Logic Arithmetic, BIT, Loads, Stores and Compares in (ZP) Addressing Mode
`define ZP_AL_BIT_LDs_Cmp ((CU_InstrY==3'b001)&((CU_InstrZ==2'b01)|((CU_InstrX[2:1]==2'b10)&(CU_InstrZ[0]==1'b0))|(((CU_InstrX[2:1]==2'b11)|(CU_InstrX==3'b001))&(CU_InstrZ==2'b00))))

// Jump to Subroutine in (Abs) Addressing Mode
`define Abs_JSR ((CU_InstrX==3'b001)&(CU_InstrY==3'b000)&(CU_InstrZ==2'b00))

// Implied Pulls
`define Implied_Pulls ((CU_InstrX[2]==1'b0)&(CU_InstrX[0]==1'b1)&(CU_InstrY==3'b010)&(CU_InstrZ==2'b00))

// Implied Return from Interrupt
`define Implied_RTI ((CU_InstrX==3'b010)&(CU_InstrY==3'b000)&(CU_InstrZ==2'b00))

// Implied Return from Subroutine
`define Implied_RTS ((CU_InstrX==3'b011)&(CU_InstrY==3'b000)&(CU_InstrZ==2'b00))

// Implied Pushs
`define Implied_Pushs ((CU_InstrX[2]==1'b0)&(CU_InstrX[0]==1'b0)&(CU_InstrY==3'b010)&(CU_InstrZ==2'b00))

// Break
`define Implied_BRK ((CU_InstrX==3'b000)&(CU_InstrY==3'b000)&(CU_InstrZ==2'b00))


  /********************************************
  *         Addressing Modes Decoder          *
  ********************************************/

// Logic Arithmetic and Loads in (Abs,X) Addressing Mode
`define Abs_X ((CU_InstrY[0]==1'b1) & (CU_InstrZ[1]==1'b0))         // CHANGE: | for &
// Logic Arithmetic and Loads in (Abs,Y) Addressing Mode
`define Abs_Y ((CU_InstrY[0]==1'b0) | (CU_InstrZ[1]==1'b1))

// Shift & Rotates with Accumulator
`define SH_ROT_ACC ((CU_InstrX[2]==1'b0) & (CU_InstrY==3'b010) & (CU_InstrZ==2'b10))
// Transfer A to BUS TAX / TAY
`define Transfer_A (((CU_InstrX==3'b101)&(CU_InstrY==3'b010))&(CU_InstrZ[0]==1'b0)) // CHANGE: Z==00 U Z==10
// Transfer X to BUS TXA / DEX / INX / TXS
//ORIGINAL: ERROR: 18 instructions included
//`define Transfer_X (((CU_InstrY==3'b010)|(CU_InstrY==3'b110))&((CU_InstrX==3'b100)|(CU_InstrX==3'b110)|(CU_InstrX==3'b111))&((CU_InstrZ==2'b10)|(CU_InstrZ==2'b00)))
`define Transfer_X ((CU_InstrR==8'hE8)|(((((CU_InstrX==3'b100)|(CU_InstrX==3'b110))&(CU_InstrY==3'b010))|((CU_InstrX==3'b100)&(CU_InstrY==3'b110)))&(CU_InstrZ==2'b10)))
// Transfer Y to BUS TYA / DEY / INY
//`define Transfer_Y (((CU_InstrY[1:0]==2'b10)&(CU_InstrZ==00))&((CU_InstrX==3'b100)|(CU_InstrX==3'b110))&((CU_InstrY[2]==1'b1)|(CU_InstrY[2]==1'b0)))
`define Transfer_Y ((CU_InstrZ==2'b00)&(((CU_InstrX==3'b100)&((CU_InstrY==3'b110)|(CU_InstrY==3'b010)))|((CU_InstrX==3'b110)&(CU_InstrY==3'b010))))
// Transfer Stack to X register
`define Transfer_Stack ((CU_InstrX==3'b101)&(CU_InstrY==3'b110)&(CU_InstrZ==2'b10))

// STORES
`define STORES (CU_InstrX==3'b100)
// STA ALL ADDRESING MODES APPLYING
`define STA (CU_InstrZ==2'b01)
//STX ALL ADDRESING MODES APPLYING
`define STX (CU_InstrZ==2'b10)
//STY ALL ADDRESING MODES APPLYING
`define STY (CU_InstrZ==2'b00)

//Implied PHA
`define PHA (CU_InstrX[1]==1'b1)
//Implied PHP
`define PHP (CU_InstrX[1]==1'b0)

// ASL ALL ADDRESING MODES APPLYING
`define ASL (CU_InstrX==3'b000)
// ROL ALL ADDRESING MODES APPLYING
`define ROL (CU_InstrX==3'b001)
// LSR ALL ADDRESING MODES APPLYING
`define LSR (CU_InstrX==3'b010)
// ROR ALL ADDRESING MODES APPLYING
`define ROR (CU_InstrX==3'b011)
// DEC ALL ADDRESING MODES APPLYING
`define DEC (CU_InstrX==3'b110)
// INC ALL ADDRESING MODES APPLYING
`define INC (CU_InstrX==3'b111)

// BPL
`define BPL (CU_PstInstrX==3'b000)
// BMI
`define BMI (CU_PstInstrX==3'b001)
// BVC
`define BVC (CU_PstInstrX==3'b010)
// BVS
`define BVS (CU_PstInstrX==3'b011)
// BCC
`define BCC (CU_PstInstrX==3'b100)
// BCS
`define BCS (CU_PstInstrX==3'b101)
// BNE
`define BNE (CU_PstInstrX==3'b110)
// BEQ
`define BEQ (CU_PstInstrX==3'b111)

//CPX AM: Abs, ZP, Imm
`define CPX ((CU_InstrX==3'b111) & ((CU_InstrY==3'b011)|(CU_InstrY==3'b001)|(CU_InstrY==3'b000)) & (CU_InstrZ==2'b00))
//CPY AM: Abs, ZP, Imm
`define CPY ((CU_InstrX==3'b110) & ((CU_InstrY==3'b011)|(CU_InstrY==3'b001)|(CU_InstrY==3'b000)) & (CU_InstrZ==2'b00))

//SH, ROT
`define SH_ROT ((CU_InstrX[2]==1'b0)&(CU_InstrZ==2'b10))


  /********************************************
  *         Addressing Modes Decoder          *
  ********************************************/

//Aritmetic-Logic (Except STA) Instruction ALL ADDRESING MODES APPLYING  --PAST INSTRUCTION
//AL EXCEPT STORES AND CMP ALL ADDRESSING MODES APPLYING (Except LDX, LDY)
// Logic Arithmetic excluding STA and CMP     //NOTE: why is compare excluded?
`define AL_EXCEPT_ST_CMP_ALL_AM_PstI ((CU_PstInstrZ==2'b01) & (CU_PstInstrX!=3'b100) & (CU_PstInstrX!=3'b110))
// ORA
`define ORA_PstI ((CU_PstInstrX==3'b000) & (CU_PstInstrZ==2'b01))
// AND
`define AND_PstI ((CU_PstInstrX==3'b001) & (CU_PstInstrZ==2'b01))
// EOR
`define EOR_PstI ((CU_PstInstrX==3'b010) & (CU_PstInstrZ==2'b01))
// ADC
`define ADC_PstI ((CU_PstInstrX==3'b011) & (CU_PstInstrZ==2'b01))
// LDA
`define LDA_PstI ((CU_PstInstrX==3'b101) & (CU_PstInstrZ==2'b01))
// CMP
`define CMP_PstI ((CU_PstInstrX==3'b110) & (CU_PstInstrZ==2'b01))
// SBC
//ERROR: X=100 is STA
//`define SBC_PstI ((CU_PstInstrX==3'b100) & (CU_PstInstrZ==2'b01))
`define SBC_PstI ((CU_PstInstrX==3'b111) & (CU_PstInstrZ==2'b01))

// LDY 
`define LDY_PstI ((CU_PstInstrX==3'b101) & (CU_PstInstrZ==2'b00) & (CU_PstInstrY!=3'b010) & (CU_PstInstrY!=3'b100) & (CU_PstInstrY!=3'b110))
// LDX
`define LDX_PstI ((CU_PstInstrX==3'b101) & (CU_PstInstrZ==2'b10) & (CU_PstInstrY!=3'b010) & (CU_PstInstrY!=3'b100) & (CU_PstInstrY!=3'b110))

// CPY ALL ADDRESSING MODES
`define CPY_PstI ((CU_PstInstrZ==2'b00) & (CU_PstInstrX==3'b110) & ((CU_PstInstrY==3'b000) | (CU_PstInstrY==3'b001) | (CU_PstInstrY==3'b011)))
// CPX ALL ADDRESSING MODES
`define CPX_PstI ((CU_PstInstrZ==2'b00) & (CU_PstInstrX==3'b111) & ((CU_PstInstrY==3'b000) | (CU_PstInstrY==3'b001) | (CU_PstInstrY==3'b011)))

// ASL_ACC
`define ASL_ACC_PstI ((CU_PstInstrX==3'b000) & (CU_PstInstrY==3'b010) & (CU_PstInstrZ==2'b10))
// ROL_ACC
`define ROL_ACC_PstI ((CU_PstInstrX==3'b001) & (CU_PstInstrY==3'b010) & (CU_PstInstrZ==2'b10))
// LSR_ACC
`define LSR_ACC_PstI ((CU_PstInstrX==3'b010) & (CU_PstInstrY==3'b010) & (CU_PstInstrZ==2'b10))
// ROR_ACC
`define ROR_ACC_PstI ((CU_PstInstrX==3'b011) & (CU_PstInstrY==3'b010) & (CU_PstInstrZ==2'b10))
// SH, ROT ACC 
`define SH_ROT_ACC_PstI (((CU_PstInstrX==3'b011) |(CU_PstInstrX==3'b000)|(CU_PstInstrX==3'b001)|(CU_PstInstrX==3'b010)) & (CU_PstInstrY==3'b010) & (CU_PstInstrZ==2'b10))

// Transfer A to BUS TAY / TAX
`define Transfer_A_PstI ((CU_PstInstrX==3'b101)&(CU_PstInstrY==3'b010)&(CU_PstInstrZ[0]==1'b0))
// Transfer X to BUS TXA / DEX / INX / TXS
//`define Transfer_X_PstI ((CU_PstInstrR==8'hE8)|(((((CU_PstInstrX==3'b100)|(CU_PstInstrX==3'b110))&(CU_PstInstrY==3'b010))|((CU_PstInstrX==3'b100)&(CU_PstInstrY==3'b110)))&(CU_PstInstrZ==2'b10)))
`define Transfer_X_PstI ((CU_PstInstrX==3'b100)&(CU_PstInstrY[1:0]==2'b10)&(CU_PstInstrZ==2'b10))
// Transfer Y to BUS TYA / DEY / INY
//CHANGE: way to long
//`define Transfer_Y_PstI (((CU_PstInstrX==3'b100)&(CU_PstInstrY==3'b110)&(CU_PstInstrZ==2'b00))|((CU_PstInstrX==3'b100)&(CU_PstInstrY==3'b010)&(CU_PstInstrZ==2'b00))|((CU_PstInstrX==3'b110)&(CU_PstInstrY==3'b010)&(CU_PstInstrZ==2'b00)))
//`define Transfer_Y_PstI ((CU_PstInstrZ==2'b00)&(((CU_PstInstrX==3'b100)&((CU_PstInstrY==3'b110)|(CU_PstInstrY==3'b010)))|((CU_PstInstrX==3'b110)&(CU_PstInstrY==3'b010))))
`define Transfer_Y_PstI ((CU_PstInstrX==3'b100)&(CU_PstInstrY==3'b110)&(CU_PstInstrZ==2'b00)) //Changed X==110 to X==100 and Y==100 to Y==110
//Transfer Stack to X register
`define Transfer_Stack_PstI ((CU_PstInstrX==3'b101)&(CU_PstInstrY==3'b110)&(CU_PstInstrZ==2'b10))

// PLA, PLP Past Instruction
`define Implied_Pulls_PstI ((CU_PstInstrX[2]==1'b0)&(CU_PstInstrX[0]==1'b1)&(CU_PstInstrY==3'b010)&(CU_PstInstrZ==2'b00))
//PLA PstI
`define PLA_PstI ((CU_PstInstrX==3'b011)&(CU_PstInstrY==3'b010)&(CU_PstInstrZ==2'b00))
//PLP PstI
`define PLP_PstI ((CU_PstInstrX==3'b001)&(CU_PstInstrY==3'b010)&(CU_PstInstrZ==2'b00))

//DEX_Y
`define DEX_Y_PstI ((((CU_PstInstrX==3'b100) & (CU_PstInstrZ==2'b00)) | ((CU_PstInstrX==3'b110) & (CU_PstInstrZ==2'b10))) & (CU_PstInstrY==3'b010)) //ERROR: Z==01 totally wrong
//INX_Y
`define INX_Y_PstI ((CU_PstInstrX[2:1]==2'b11) & (CU_PstInstrY==3'b010) & (CU_PstInstrZ==2'b00))

//Abs_JSR
`define Abs_JSR_PstI ((CU_PstInstrX==3'b001)&(CU_PstInstrY==3'b000)&(CU_PstInstrZ==2'b00))
//Abs_JMP
`define Abs_JMP_PstI ((CU_PstInstrX==3'b010)&(CU_PstInstrY==3'b011)&(CU_PstInstrZ==2'b00))
//Ind_JMP
`define Ind_JMP_PstI ((CU_PstInstrX==3'b011)&(CU_PstInstrY==3'b011)&(CU_PstInstrZ==2'b00))

//Push PstI
`define Implied_Pushs_PstI ((CU_PstInstrX[2]==1'b0)&(CU_PstInstrX[0]==1'b0)&(CU_PstInstrY==3'b010)&(CU_PstInstrZ==2'b00))

//RTI PstI
`define Implied_RTI_PstI ((CU_PstInstrX==3'b010)&(CU_PstInstrY==3'b000)&(CU_PstInstrZ==2'b00))

//CLI  
`define CLI_PstI ((CU_PstInstrY==3'b110) & (CU_PstInstrZ==2'b00) &(CU_PstInstrX==3'b010))
//SEI
`define SEI_PstI ((CU_PstInstrY==3'b110) & (CU_PstInstrZ==2'b00) &(CU_PstInstrX==3'b011))
//CLC
`define CLC_PstI ((CU_PstInstrY==3'b110) & (CU_PstInstrZ==2'b00) &(CU_PstInstrX==3'b000))
//SEC
`define SEC_PstI ((CU_PstInstrY==3'b110) & (CU_PstInstrZ==2'b00) &(CU_PstInstrX==3'b001))
//CLV
`define CLV_PstI ((CU_PstInstrY==3'b110) & (CU_PstInstrZ==2'b00) &(CU_PstInstrX==3'b101))
//SED
`define SED_PstI ((CU_PstInstrY==3'b110) & (CU_PstInstrZ==2'b00) &(CU_PstInstrX==3'b111))
//CLD
`define CLD_PstI ((CU_PstInstrY==3'b110) & (CU_PstInstrZ==2'b00) &(CU_PstInstrX==3'b110))

//Instruction Saving in XR ->INX, DEX, TAX, TSX
//ERROR: Completly wrong, 18 instructions included
//`define INX_DEX_TAX_TSX_PstI (((CU_PstInstrX==3'b101)|(CU_PstInstrX==3'b110)|(CU_PstInstrX==3'b111))&((CU_PstInstrY==3'b010)|(CU_PstInstrY==3'b110))&((CU_PstInstrZ==2'b10)|(CU_PstInstrZ==2'b00)))
`define INX_DEX_TAX_TSX_PstI ((((((CU_PstInstrX==3'b110)|(CU_PstInstrX==3'b101))&(CU_PstInstrY==3'b010))|((CU_PstInstrX==3'b101)&(CU_PstInstrY==3'b110)))&(CU_PstInstrZ==2'b10))|(CU_PstInstrR==8'hE8))
//Instruction Saving in YR ->INY, DEY, TAY
`define INY_DEY_TAY_PstI (((CU_PstInstrX==3'b101)|(CU_PstInstrX==3'b100)|(CU_PstInstrX==3'b110))&(CU_PstInstrY==3'b010)&(CU_PstInstrZ==2'b00))
//Instruction Saving in Acc -> TXA, TYA 
//ERROR: 4 instructions included
//`define TXA_TYA_PstI ((CU_PstInstrX==3'b100)&((CU_PstInstrY==3'b010)|(CU_PstInstrY==3'b110))&((CU_PstInstrZ==2'b10)|(CU_PstInstrZ==2'b00)))
`define TXA_TYA_PstI ((CU_PstInstrX==3'b100)&(((CU_PstInstrY==3'b010)&(CU_PstInstrZ==2'b10))|((CU_PstInstrY==3'b110)&(CU_PstInstrZ==2'b00))))

//Instruction Saving in SP -> TXS
`define TXS_PstI ((CU_PstInstrX==3'b100)&(CU_PstInstrY==3'b110)&(CU_PstInstrZ==2'b10))

//BIT
`define BIT_PstI ((CU_PstInstrX==3'b001) & ((CU_PstInstrY==3'b001)|(CU_PstInstrY==3'b011))&(CU_PstInstrZ==2'b00))

//Branches
`define Branches_PstI ((CU_PstInstrY==3'b100)&(CU_PstInstrZ==2'b00))