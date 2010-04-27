 /********************************************
  *         Operation Codes Parameters        *
  ********************************************/  
  // ALU operation (ALU_funct)
  parameter OR  = 2'b00;    // OpA OR OpB operation
  parameter AND = 2'b01;    // OpA AND OpB operation
  parameter XOR = 2'b10;    // OpA XOR OpB operation
  parameter ADC = 2'b11;    // OpA ADD OpB operation
  
  // ALU OpB operation (OpB_funct)
  parameter SHR = 2'b00;    // Shit Right OpB
  parameter SHL = 2'b01;    // Shit Left OpB
  parameter INC = 2'b10;    // Increment in 1 OpB
  parameter DEC = 2'b11;    // Decrement in 1 OpB
  
  
  /********************************************
  *              Bus Parameters               *
  ********************************************/
  //For Address Low Bus (ADL_sel)
  parameter PCL_to_ADL    = 3'b000;
  parameter SP_to_ADL     = 3'b001;
  parameter DIR_to_ADL    = 3'b010;
  parameter ALUout_to_ADL = 3'b011;
  parameter DMABy_to_ADL  = 3'b100;
  parameter PPU04_to_ADL  = 3'b101;
  
  //For Address High Bus (ADH_sel)
  parameter PCH_to_ADH    = 3'b000;
  parameter SB_to_ADH     = 3'b001;
  parameter DIR_to_ADH    = 3'b010;
  parameter Pg0_to_ADH    = 3'b011;
  parameter Pg1_to_ADH    = 3'b100;
  parameter DMAPg_to_ADH  = 3'b101;
  parameter PPU20_to_ADH  = 3'b110;

  //For Data Bus (DB_sel)
  parameter PR_to_DB      = 3'b000;
  parameter DIR_to_DB     = 3'b001;
  parameter PCL_to_DB     = 3'b010;
  parameter PCH_to_DB     = 3'b011;
  parameter ACC_to_DB     = 3'b100;
  parameter SB_to_DB      = 3'b101;

  //For Secondary Bus (SB_sel)
  parameter ADL_to_SB      = 3'b000;
  parameter ADH_to_SB     = 3'b001;
  parameter XR_to_SB      = 3'b010;
  parameter YR_to_SB      = 3'b011;
  parameter ACC_to_SB     = 3'b100;
  parameter SP_to_SB      = 3'b101;
  parameter ALUout_to_SB  = 3'b110;

  //For ALU Operator A Bus (OpAB_sel)
  parameter Zero_to_OpAB  = 1'b0;
  parameter SB_to_OpAB    = 1'b1;
    
  //For ALU Operator B Bus (OpBB_sel)
  parameter ADH_to_OpBB   = 2'b00;
  parameter ADL_to_OpBB   = 2'b01;
  parameter DB_to_OpBB    = 2'b10;
  parameter bDB_to_OpBB   = 2'b11;

  //For PC Bus (not in diagram, internal to PC logic block)
  parameter PCp1_to_PCB     = 3'b000;
  parameter ADDp1_to_PCB    = 3'b001;
  parameter VctIRQ_to_PCB   = 3'b010;
  parameter VctNMI_to_PCB   = 3'b011;
  parameter VctSTART_to_PCB = 3'b100;
  parameter ADD_to_PCB      = 3'b101;  // Added to Mux in order to have access to the ADL without incrementation
  
  
  /********************************************
  *          Control Unit Parameters          *
  ********************************************/

  //For Control Signals
 parameter En    = 1'b1,
           Dis   = 1'b0,
           Read  = 1'b1,
           Write = 1'b0,
           On    = 1'b1,
           Off   = 1'b0,
           bOn   = 1'b0,
           bOff  = 1'b1;
            

 //For the States of the FMS
 parameter [5:0] IS0 = 6'b000000,
                 IS1 = 6'b000001,
                 IS2 = 6'b000010,
                 IS3 = 6'b000011,
                 IS4 = 6'b000100,
                 IS5 = 6'b000101,
                 IS6 = 6'b000110,
                 ST0 = 6'b000111,
              ST1_01 = 6'b001000,
              ST1_02 = 6'b001001,
              ST1_03 = 6'b001010,
              ST1_04 = 6'b001011,
              ST1_05 = 6'b001100,
              ST1_06 = 6'b001101,
              ST1_07 = 6'b001110,
              ST2_01 = 6'b001111,
              ST2_02 = 6'b010000,
              ST2_03 = 6'b010001,
              ST2_04 = 6'b010010,
              ST2_05 = 6'b010011,
              ST2_06 = 6'b010100,
              ST2_07 = 6'b010101,
              ST2_08 = 6'b010110,
              ST2_09 = 6'b010111,
              ST2_10 = 6'b011000,
              ST3_01 = 6'b011001,
              ST3_02 = 6'b011010,
              ST3_03 = 6'b011011,
              ST3_04 = 6'b011100,
              ST3_05 = 6'b011101,
              ST3_06 = 6'b011110,
              ST3_07 = 6'b011111,
              ST3_08 = 6'b100000,
              ST3_09 = 6'b100001,
              ST4_01 = 6'b100010,
              ST4_02 = 6'b100011,
              ST4_03 = 6'b100100,
              ST4_04 = 6'b100101,
              ST5_01 = 6'b100110,
              ST5_02 = 6'b100111,
                DMA0 = 6'b101000,
                DMA1 = 6'b101001;