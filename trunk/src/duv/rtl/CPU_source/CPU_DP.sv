// ============================================================
// Title       : CPU Data Path
// Project     : NES
// File        : CPU_DP.sv
// Description : Data Path for the central MPU in NES
// Revisions   : 
// ============================================================
// Author      : Carlos Vazquez
// Course      : 
// ============================================================

module CPU_DP #(parameter NumDb=8)(
  cpu_if.dp   cu_if,
  nes_if.cpu  ext_if,
  alu_if.slv  alu_if
  );
  //parameter NumDb=8;

  /********************************************
  *              Bus Parameters               *
  ********************************************/
  `include "../CPU_source/Parameters.v"
  
  /********************************************
  * Two Phase Clock Signals:                  *
  ********************************************/
  reg phi2;       // 2nd Phase Clock Signal
  reg phi1;       // 1st Phase Clock Signal
  /*reg prephi2;  // Signals used to generate two phase non overlaping clock signals
  reg prephi1;
  reg pre2phi2;
  reg pre2phi1;
  reg bCLK_in;*/
  
  /********************************************
  * Address Signals:                          *
  *   -Program Counter                        *
  *   -Stack Pointer                          *
  *   -Address Buses and Buffers              *
  ********************************************/
  // PC
  wire [NumDb-1:0] DP_PCLB;   // Program Counter Low Register Bus
  wire [NumDb-1:0] DP_PCHB;   // Program Counter High Register Bus
  reg [NumDb-1:0] DP_PCL;    // Program Counter Low Register
  reg [NumDb-1:0] DP_PCH;    // Program Counter High Register
  
  // SP register
  reg [NumDb-1:0] DP_SP;// = 8'hFF;     // Stack Pointer Register
  
  // ADD buses, registers
  wire [NumDb-1:0] DP_ADL;    // Address Low Bus
  wire [NumDb-1:0] DP_ADH;    // Address High Bus
  reg [NumDb-1:0] DP_ABL;    // Address Low Register (Buffer)
  reg [NumDb-1:0] DP_ABH;    // Address High Register (Buffer)

  
  /********************************************
  * Data Signals:                             *
  *   -Data in and out                        *
  *   -Instructions                           *
  *   -Internal registers (A, X, Y)           *
  *   -ALU in registers (OpA, OpB)            *
  ********************************************/
  // Data in/out registers
  reg [NumDb-1:0] DP_DOR;        // Data Out Register
  reg [NumDb-1:0] DP_DIR;        // Data In Register
  
  // Instruction registers
  reg [NumDb-1:0] DP_InstrR = 8'hEA;     // Instruction Register
  reg [NumDb-1:0] DP_PstInstrR;  // Past Instruction Register
  
  // Internal registers
  reg [NumDb-1:0] DP_XR;         // Internal X Register
  reg [NumDb-1:0] DP_YR;         // Internal Y Register
  reg [NumDb-1:0] DP_ACC;        // Accumulator Register
  
  // ALU in registers
  reg [NumDb-1:0] DP_OpA;        // Operand A ALU in Register
  reg [NumDb-1:0] DP_OpB;        // Operand B ALU in Register


  /********************************************
  * Data Buses Signals:                       *
  *   -Buses                                  *
  ********************************************/
  // Buses  
  wire [NumDb-1:0] DP_DB;     // Data Bus
  wire [NumDb-1:0] DP_SB;     // Secondary Bus
  wire [NumDb-1:0] DP_OpAB;   // ALU A Operand Bus
  wire [NumDb-1:0] DP_OpBB;   // ALU B Operand Bus
    

  /********************************************
  * Status Register Signals:                  *
  *   -Flags                                  *
  *   -Register                               *
  ********************************************/  
  reg DP_NFlg;         // Negative Flag
  reg DP_ZFlg;         // Zero Flag
  reg DP_CFlg;         // Carry Flag
  reg DP_VFlg;         // Overflow Flag
  reg DP_IFlg;         // Interrupt Disable Flag
  reg DP_BFlg;         // Brake Command Flag
  reg DP_DFlg;         // Decimal Mode Flag (no decimal mode is implemented nor needed)

  wire [NumDb-1:0] DP_PR;
  assign DP_PR = {DP_NFlg,DP_VFlg,1'b1,DP_BFlg,DP_DFlg,DP_IFlg,DP_ZFlg,DP_CFlg};

  /********************************************
  *              ALU out signal               *
  ********************************************/
  wire [NumDb-1:0] DP_ALUout;

  /********************************************
  *               DMA Signals                 *
  ********************************************/
  reg   DP_bDMA_Flg;
  reg [NumDb-1:0] DP_DMA_Pg;
  reg [NumDb-1:0] DP_DMA_By;

  /********************************************
  *          Interface Connections            *
  ********************************************/   
  always_comb
    begin
      cu_if.DP_InstrR = DP_InstrR;
      cu_if.DP_PstInstrR = DP_PstInstrR;
      cu_if.DP_bDMA_Flg = DP_bDMA_Flg;
      cu_if.DP_DMA_By = DP_DMA_By;
      cu_if.DP_ZFlg = DP_ZFlg;
      cu_if.DP_CFlg = DP_CFlg;
      cu_if.DP_VFlg = DP_VFlg;
      cu_if.DP_IFlg = DP_IFlg;
    end

  /********************************************
  *                  DMA Logic                *
  ********************************************/   
  always @ (posedge phi2)   //DMA flag
  begin
    //if(~DP_Rd_bWr & DP_ADL==8'h14 & DP_ADH==8'h40)
    if (!ext_if.r_bw & ext_if.addr==16'h4014)
    begin
      DP_bDMA_Flg <= bOn;
      DP_DMA_Pg <= ext_if.data;
      DP_DMA_By <= {NumDb{1'b0}};
    end
    else if (cu_if.CU_DMA_By_EN)
      DP_DMA_By <= cu_if.DP_DMA_By + 8'd1;
    else
      DP_bDMA_Flg <= bOff;
  end
  /********************************************
  *          Two Phase Clock Generator        *
  ********************************************/  
  always @*
  begin
    phi1 = ~ext_if.clk;
    phi2 = ext_if.clk;
    /*bCLK_in = ~CLK_in;
    pre2phi1 = ~(bCLK_in | phi2);
    pre2phi2 = ~(CLK_in | phi1);
    prephi2 = ~pre2phi2;
    prephi1 = ~pre2phi1;
    phi1 = ~prephi1;
    phi2 = ~prephi2;*/
  end
  
  assign ext_if.phi2 = phi2;
  assign cu_if.DP_phi1 = phi1;
  assign cu_if.DP_phi2 = phi2;
  
  /********************************************
  *                                           *
  ********************************************/  
  always @(posedge phi1)
  begin
    DP_DOR <= DP_DB;
    if (cu_if.CU_ABL_EN)
      DP_ABL <= DP_ADL;
    if (cu_if.CU_ABH_EN)
      DP_ABH <= DP_ADH;
      
    ext_if.r_bw <= cu_if.CU_R_bW;
  end
  
  assign ext_if.data = (~ext_if.r_bw) ? DP_DOR : {NumDb{1'bZ}};
  assign ext_if.addr = {DP_ABH,DP_ABL};
  
  always @(posedge phi2)
  begin
/*    if (~Rd_bWr_out & AddrPins_out==16'h4014)
      DP_DMA_Pg <= DataPins_inout;
    if(!DP_bDMA_Flg)
      DP_DMA_By <= {NumDb{1'b0}};
    else if (DP_DMA_By_EN)
      DP_DMA_By <= DP_DMA_By + 1;*/
      
      
    if (cu_if.CU_InstrR_EN)
      DP_InstrR <= ext_if.data;
    if (cu_if.CU_PstInstrR_Clr)
      DP_PstInstrR <= {NumDb{1'b0}};
    else if (cu_if.CU_PstInstrR_EN)
      DP_PstInstrR <= DP_InstrR;
      
    //PC logic
    if (cu_if.CU_PCL_EN)
      DP_PCL <= DP_PCLB;
    if (cu_if.CU_PCH_EN)
      DP_PCH <= DP_PCHB;
    
    if (cu_if.CU_SP_EN)
      DP_SP <= DP_SB;
      
    if (cu_if.CU_DIR_EN)
      DP_DIR <= ext_if.data;
    if (cu_if.CU_XR_EN)
      DP_XR <= DP_SB;
    if (cu_if.CU_YR_EN)
      DP_YR <= DP_SB;
    if (cu_if.CU_ACC_EN)
      DP_ACC <= DP_SB;
    if (cu_if.CU_OpA_EN)
      DP_OpA <= DP_OpAB;
    if (cu_if.CU_OpB_EN)
      DP_OpB <= DP_OpBB;
    
    if (cu_if.CU_PR_EN)
      {DP_NFlg,DP_VFlg,DP_BFlg,DP_DFlg,DP_IFlg,DP_ZFlg,DP_CFlg} <= {DP_DB[7:6],DP_DB[4:0]};
    else
    begin
      if (cu_if.CU_NFlg_EN)
        DP_NFlg <= cu_if.CU_NFlgB;
      if (cu_if.CU_VFlg_EN)
        DP_VFlg <= cu_if.CU_VFlgB;
      if (cu_if.CU_BFlg_EN)
        DP_BFlg <= cu_if.CU_BFlgB;
      if (cu_if.CU_DFlg_EN)
        DP_DFlg <= cu_if.CU_DFlgB;
      if (cu_if.CU_IFlg_EN)
        DP_IFlg <= cu_if.CU_IFlgB;
      if (cu_if.CU_ZFlg_EN)
        DP_ZFlg <= cu_if.CU_ZFlgB;
      if (cu_if.CU_CFlg_EN)
        DP_CFlg <= cu_if.CU_CFlgB;
    end  
  end
  
  assign DP_ADL = (cu_if.CU_ADL_Sel==PCL_to_ADL   ) ? DP_PCL    : {NumDb{1'bZ}};
  assign DP_ADL = (cu_if.CU_ADL_Sel==SP_to_ADL    ) ? DP_SP     : {NumDb{1'bZ}};
  assign DP_ADL = (cu_if.CU_ADL_Sel==DIR_to_ADL   ) ? DP_DIR    : {NumDb{1'bZ}};
  assign DP_ADL = (cu_if.CU_ADL_Sel==ALUout_to_ADL) ? DP_ALUout : {NumDb{1'bZ}};
  assign DP_ADL = (cu_if.CU_ADL_Sel==DMABy_to_ADL ) ? DP_DMA_By : {NumDb{1'bZ}};
  assign DP_ADL = (cu_if.CU_ADL_Sel==PPU04_to_ADL ) ? 8'h04     : {NumDb{1'bZ}};
  
  assign DP_ADH = (cu_if.CU_ADH_Sel==PCH_to_ADH   ) ? DP_PCH                   : {NumDb{1'bZ}};
  assign DP_ADH = (cu_if.CU_ADH_Sel==SB_to_ADH    ) ? DP_SB                    : {NumDb{1'bZ}};
  assign DP_ADH = (cu_if.CU_ADH_Sel==DIR_to_ADH   ) ? DP_DIR                   : {NumDb{1'bZ}};
  assign DP_ADH = (cu_if.CU_ADH_Sel==Pg0_to_ADH   ) ? {NumDb{1'b0}}            : {NumDb{1'bZ}};
  assign DP_ADH = (cu_if.CU_ADH_Sel==Pg1_to_ADH   ) ? {{(NumDb-1){1'b0}},1'b1} : {NumDb{1'bZ}};
  assign DP_ADH = (cu_if.CU_ADH_Sel==DMAPg_to_ADH ) ? DP_DMA_Pg                : {NumDb{1'bZ}};
  assign DP_ADH = (cu_if.CU_ADH_Sel==PPU20_to_ADH ) ? 8'h20                    : {NumDb{1'bZ}};
  
  assign DP_DB = (cu_if.CU_DB_Sel==SB_to_DB ) ? DP_SB  : {NumDb{1'bZ}};
  assign DP_DB = (cu_if.CU_DB_Sel==PR_to_DB ) ? DP_PR  : {NumDb{1'bZ}};
  assign DP_DB = (cu_if.CU_DB_Sel==DIR_to_DB) ? DP_DIR : {NumDb{1'bZ}};
  assign DP_DB = (cu_if.CU_DB_Sel==PCL_to_DB) ? DP_PCL : {NumDb{1'bZ}};
  assign DP_DB = (cu_if.CU_DB_Sel==PCH_to_DB) ? DP_PCH : {NumDb{1'bZ}};
  assign DP_DB = (cu_if.CU_DB_Sel==ACC_to_DB) ? DP_ACC : {NumDb{1'bZ}};
    
  assign DP_SB = (cu_if.CU_SB_Sel==ADL_to_SB   ) ? DP_ADL    : {NumDb{1'bZ}};
  assign DP_SB = (cu_if.CU_SB_Sel==ADH_to_SB   ) ? DP_ADH    : {NumDb{1'bZ}};
  assign DP_SB = (cu_if.CU_SB_Sel==XR_to_SB    ) ? DP_XR     : {NumDb{1'bZ}};
  assign DP_SB = (cu_if.CU_SB_Sel==YR_to_SB    ) ? DP_YR     : {NumDb{1'bZ}};
  assign DP_SB = (cu_if.CU_SB_Sel==ACC_to_SB   ) ? DP_ACC    : {NumDb{1'bZ}};
  assign DP_SB = (cu_if.CU_SB_Sel==SP_to_SB    ) ? DP_SP     : {NumDb{1'bZ}};
  assign DP_SB = (cu_if.CU_SB_Sel==ALUout_to_SB) ? DP_ALUout : {NumDb{1'bZ}};
    
  assign DP_OpAB = (cu_if.CU_OpAB_Sel==Zero_to_OpAB) ? {NumDb{1'b0}} : {NumDb{1'bZ}};
  assign DP_OpAB = (cu_if.CU_OpAB_Sel==SB_to_OpAB  ) ? DP_SB         : {NumDb{1'bZ}};
    
  assign DP_OpBB = (cu_if.CU_OpBB_Sel==ADH_to_OpBB) ? DP_ADH : {NumDb{1'bZ}};
  assign DP_OpBB = (cu_if.CU_OpBB_Sel==ADL_to_OpBB) ? DP_ADL : {NumDb{1'bZ}};
  assign DP_OpBB = (cu_if.CU_OpBB_Sel==DB_to_OpBB ) ? DP_DB  : {NumDb{1'bZ}};
  assign DP_OpBB = (cu_if.CU_OpBB_Sel==bDB_to_OpBB) ? ~DP_DB : {NumDb{1'bZ}};
    
  assign {DP_PCHB,DP_PCLB} = (cu_if.CU_PCB_Sel==PCp1_to_PCB    ) ? {DP_PCH,DP_PCL} + 1'b1     : {2*NumDb{1'bZ}};
  assign {DP_PCHB,DP_PCLB} = (cu_if.CU_PCB_Sel==ADDp1_to_PCB   ) ? {DP_ADH,DP_ADL} + 1'b1     : {2*NumDb{1'bZ}};
  assign {DP_PCHB,DP_PCLB} = (cu_if.CU_PCB_Sel==VctIRQ_to_PCB  ) ? {{2*NumDb-3{1'b1}},3'b110} : {2*NumDb{1'bZ}};
  assign {DP_PCHB,DP_PCLB} = (cu_if.CU_PCB_Sel==VctNMI_to_PCB  ) ? {{2*NumDb-3{1'b1}},3'b010} : {2*NumDb{1'bZ}};
  assign {DP_PCHB,DP_PCLB} = (cu_if.CU_PCB_Sel==VctSTART_to_PCB) ? {{2*NumDb-3{1'b1}},3'b100} : {2*NumDb{1'bZ}};
  assign {DP_PCHB,DP_PCLB} = (cu_if.CU_PCB_Sel==ADD_to_PCB     ) ? {DP_ADH,DP_ADL}            : {2*NumDb{1'bZ}};

 	
 	assign cu_if.DP_OpB_sign = DP_OpB[NumDb-1];
 	assign DP_ALUout = alu_if.ALU_Rslt;
 	  
  NES_ALU NES_ALU_I0(
    .alu_if,
    .OpA(DP_OpA),
    .OpB(DP_OpB)
  );
  
endmodule:CPU_DP
