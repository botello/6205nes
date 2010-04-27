// ============================================================
// Title       : FSM of the CU
// Project     : NES
// File        : CPU_CU_FSM.sv
// Description : Finite State Machine, stablishes the current
//  and calculates the next state based on the instruction and
//  other flags.
// Revisions   : 
// ============================================================
// Author      : Nora Cristina Lopez Magaña and Carlos Vazquez
// Course      : 
// ============================================================

module CU_FSM(
  cu_if.fsm cu_if0,           // Interface with the rest of the CU
  input CU_phi2, CU_bRST      // CU General Signals
  );

`include "../CPU_source/Parameters.v"
`include "../CPU_source/macros.v"

  // Current & Next State Signals for the FSM
  logic [5:0] cur_state;
  logic [5:0] next_state;

  // Additional Flags to calculate the next state
  logic CU_bIRQ_Flg, CU_bNMI_Flg, CU_ALU_CFlg, CU_OpB_sign,
        CU_IFlg, CU_NFlg, CU_VFlg, CU_CFlg, CU_ZFlg,
        CU_bDMA_Flg;
  logic [7:0] CU_DMA_By;
  logic [2:0] CU_InstrX;
  logic [2:0] CU_InstrY;
  logic [1:0] CU_InstrZ;
  logic [2:0] CU_PstInstrX;
  
  always_comb
  begin
    cu_if0.cur_state = cur_state;
    cu_if0.nxt_state = next_state;
    
    CU_bIRQ_Flg = cu_if0.birq_flg;
    CU_bNMI_Flg = cu_if0.bnmi_flg;
    CU_ALU_CFlg = cu_if0.alu_cflg;
    CU_OpB_sign = cu_if0.opb_sign;
    CU_IFlg = cu_if0.i_flg;
    CU_NFlg = cu_if0.n_flg;
    CU_VFlg = cu_if0.v_flg;
    CU_CFlg = cu_if0.c_flg;
    CU_ZFlg = cu_if0.z_flg;
    
    CU_InstrX = cu_if0.instrX; 
    CU_InstrY = cu_if0.instrY;
    CU_InstrZ = cu_if0.instrZ;
    CU_PstInstrX = cu_if0.pst_instrX;
    
    CU_bDMA_Flg = cu_if0.dma_bflg;
    CU_DMA_By = cu_if0.dma_by;
  end

always @(posedge CU_phi2 or negedge CU_bRST)
  begin
    if (!CU_bRST)
      cur_state <= IS0;
    else
      cur_state <= next_state;  
  end
  
always @*
begin
  case (cur_state)
    IS0:
      next_state = IS1;
    IS1:
      next_state = IS2;
    IS2:
      next_state = IS3;
    IS3:
      next_state = IS4;
    IS4:
      next_state = IS5;
    IS5:
      next_state = IS6;
    IS6:
    begin
      if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
        next_state = IS0;
      else
        next_state = 6'hZ;
      if ((CU_bIRQ_Flg | CU_IFlg) & (CU_bNMI_Flg))
        next_state = ST0;
      else
        next_state = 6'hZ;
    end
    
    ST0:
      begin
        if (`ZP_X_Inc_Dec | `ZP_XY | `Ind_Y)
          next_state = ST1_01;
        else if (`Abs_XY |`Abs_X_Inc_Dec_Sh_Rot|`Immediate)
          next_state = ST1_02;
        else if (`Implied_Transf_Clr_Set_Dex_Inx_Acc)
          next_state = ST1_03;
        else if (`Abs_AL_BIT_LDs_Cmp | `Abs_Inc_Dec_Sh_Rot | `Abs_JMP | `Ind_JMP | `Relative)
          next_state = ST1_04;
        else if (`Ind_X_AL | `ZP_Inc_Dec_Sh_Rot | `ZP_AL_BIT_LDs_Cmp)
          next_state = ST1_05;
        else if (`Abs_JSR)
          next_state = ST1_06;
        else if (`Implied_Pulls | `Implied_RTI | `Implied_RTS | `Implied_Pushs)
          next_state = ST1_07;
        else
          next_state = IS1;
      end
      
    ST1_01:
      begin
        if (`ZP_X_Inc_Dec | `ZP_XY)
          next_state = ST2_01;
        else if (`Ind_Y)
          next_state = ST2_02;
        else
          next_state = IS1;
      end 
        
    ST1_02:
      begin
        if (`Abs_XY|`Abs_X_Inc_Dec_Sh_Rot)
          next_state = ST2_03;
        else if (`Immediate)
        begin
          if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
            next_state = IS0;
          else
            next_state = ST0;
        end
        else
          next_state = IS1;
      end
      
    ST1_03:
    begin
      if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
        next_state = IS0;
      else
        next_state = ST0;
    end

      
    ST1_04:
      begin
        if (`Abs_AL_BIT_LDs_Cmp | `Abs_Inc_Dec_Sh_Rot | `Abs_JMP | `Ind_JMP)
          next_state = ST2_04;
        else if (`Relative)
          next_state = ST2_05;
        else
          next_state = IS1;
      end
      
    ST1_05:
    begin
      if (`Ind_X_AL)
        next_state = ST2_01;
      else if (`ZP_Inc_Dec_Sh_Rot)
        next_state = ST2_06;
      else if (`ZP_AL_BIT_LDs_Cmp)
        next_state = ST2_07;
      else
        next_state = IS1;
    end
    
    ST1_06:
	  next_state = ST2_08;
    
    ST1_07:
    begin
      if (`Implied_Pulls | `Implied_RTI | `Implied_RTS)
        next_state = ST2_09;
      else if (`Implied_Pushs)
        next_state = ST2_10;
      else
          next_state = IS1;
    end
    
    ST2_01:
    begin
      if (`ZP_X_Inc_Dec)
        next_state = ST2_06;
      else if (`ZP_XY)
        next_state = ST2_07;
      else if (`Ind_X_AL)
        next_state = ST3_05;
      else
        next_state = IS1;
    end
    
    ST2_02:
      next_state = ST2_03;
    
    ST2_03:
    begin
      if ((`Abs_XY | `Ind_Y) & (CU_ALU_CFlg))
        next_state = ST3_01;
      else if (`Abs_X_Inc_Dec_Sh_Rot)
        next_state = ST3_02;
      else if ((`Abs_XY | `Ind_Y))
        next_state = ST2_07;      
      else 
        next_state = IS1;
    end
    
    ST2_04:
    begin
      if (`Abs_AL_BIT_LDs_Cmp |`Ind_X_AL)
        next_state = ST2_07;
      else if (`Abs_Inc_Dec_Sh_Rot)
        next_state = ST2_06;
      else if (`Ind_JMP)
        next_state = ST3_03;
      else if (`Abs_JMP | `Ind_JMP)
      begin
        if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
          next_state = IS0;
        else
          next_state = ST0;
      end
      else
        next_state = IS1;
    end
  
    ST2_05:    // NOTE: Page Crossing State
    begin
      if ((`BPL & ~CU_NFlg) | (`BMI & CU_NFlg) | (`BVC & ~CU_VFlg) | (`BVS & CU_VFlg) | (`BCC & ~CU_CFlg) | (`BCS & CU_CFlg) | (`BNE & ~CU_ZFlg) | (`BEQ & CU_ZFlg))
      begin  
        if (((~CU_OpB_sign & CU_ALU_CFlg)|(CU_OpB_sign & ~CU_ALU_CFlg)))
          next_state = ST3_04;
        else 
        begin
          if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
            next_state = IS0;
          else
            next_state = ST0;
        end
      end
      else
      begin
        if (`ZP_X_Inc_Dec | `ZP_XY | `Ind_Y)
          next_state = ST1_01;
        else if (`Abs_XY |`Abs_X_Inc_Dec_Sh_Rot|`Immediate)
          next_state = ST1_02;
        else if (`Implied_Transf_Clr_Set_Dex_Inx_Acc)
          next_state = ST1_03;
        else if (`Abs_AL_BIT_LDs_Cmp | `Abs_Inc_Dec_Sh_Rot | `Abs_JMP | `Ind_JMP | `Relative)
          next_state = ST1_04;
        else if (`Ind_X_AL | `ZP_Inc_Dec_Sh_Rot | `ZP_AL_BIT_LDs_Cmp)
          next_state = ST1_05;
        else if (`Abs_JSR)
          next_state = ST1_06;
        else if (`Implied_Pulls | `Implied_RTI | `Implied_RTS | `Implied_Pushs)
          next_state = ST1_07;
        else
          next_state = IS1;
      end
    end
    
    ST2_06:
    begin
      if (`ZP_Inc_Dec_Sh_Rot|`Abs_Inc_Dec_Sh_Rot|`Abs_X_Inc_Dec_Sh_Rot|`ZP_X_Inc_Dec)
	    next_state = ST3_06;
	  else
        next_state = IS1;
    end
  
    ST2_07:
    begin
      if(`ZP_AL_BIT_LDs_Cmp|`Abs_AL_BIT_LDs_Cmp|`ZP_XY |`Abs_XY |`Ind_X_AL | `Ind_Y)
      begin
        if (!CU_bDMA_Flg)
          next_state = DMA0;
        else if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
          next_state = IS0;
        else
          next_state = ST0;
      end
      else
        next_state = IS1;
    end
    
    ST2_08:
      next_state = ST3_07;
    
    ST2_09:
    begin
      if (`Implied_Pulls)
        next_state = ST3_08;
      else if (`Implied_RTI | `Implied_RTS)
        next_state = ST3_09;
      else
        next_state = IS1;
    end
      
    ST2_10:
    begin
      if (`Implied_Pushs)
      begin
        if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
          next_state = IS0;
        else
          next_state = ST0;
      end
      else if (`Abs_JSR)
        next_state = ST5_01;
      else
        next_state = IS1;
    end
    
    ST3_01:
    begin
      if (`Abs_XY | `Ind_Y)
        next_state = ST2_07;
      else
        next_state = IS1;
    end
    
    ST3_02:
      next_state = ST2_06;
    
    ST3_03:
      next_state = ST4_04;
    
    ST3_04:
    begin
      if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
        next_state = IS0;
      else
        next_state = ST0;
    end

    
    ST3_05:
      next_state = ST2_04;
    
    ST3_06:
    begin
      if (`ZP_Inc_Dec_Sh_Rot|`Abs_Inc_Dec_Sh_Rot|`Abs_X_Inc_Dec_Sh_Rot|`ZP_X_Inc_Dec)
        next_state = ST4_01;
      else
        next_state = IS1;
    end
    
    ST3_07:
      next_state = ST2_10;
    
    ST3_08:
    begin
      if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
        next_state = IS0;
      else
        next_state = ST0;
    end

     
    ST3_09:
    begin
      if (`Implied_RTI)
        next_state = ST4_02;
      else if (`Implied_RTS)
        next_state = ST4_03;
      else
        next_state = IS1;
    end
    
    ST4_01:
    begin
      if(`ZP_Inc_Dec_Sh_Rot|`Abs_Inc_Dec_Sh_Rot|`Abs_X_Inc_Dec_Sh_Rot|`ZP_X_Inc_Dec)
      begin
        if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
          next_state = IS0;
        else
          next_state = ST0;
      end
      else
        next_state = IS1;
    end
    
    ST4_02:
      next_state = ST5_01;
    
    ST4_03:
      next_state = ST5_02;
    
    ST4_04:
    begin
      if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
        next_state = IS0;
      else
        next_state = ST0;
    end
      
    ST5_01:
    begin
      if (`Implied_RTI |`Abs_JSR)
      begin
        if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
          next_state = IS0;
        else
          next_state = ST0;
      end
      else
        next_state = IS1;
    end
    
    ST5_02:
    begin
      if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
        next_state = IS0;
      else
        next_state = ST0;
    end

    DMA0:
      next_state = DMA1;
      
    DMA1:
    begin
      if (CU_DMA_By == 8'h00)
      begin
        if ((!CU_bIRQ_Flg & !CU_IFlg) | (!CU_bNMI_Flg))
          next_state = IS0;
        else
          next_state = ST0;
      end
      else
        next_state = DMA0;
    end
    default: 
		next_state = IS0;
  endcase
end

endmodule:CU_FSM