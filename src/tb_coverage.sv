

`ifndef TB_COVERAGE_V
`define TB_COVERAGE_V

`include "cpu_ref_top.sv"
`include "cpu_duv_top.sv"

module tb_coverage (
   tb_cpu_if cpu_duv_intf,
   tb_cpu_if cpu_ref_intf
);

   import mem_pkg::*;

      typedef enum logic [1:0] {
      SEL_MUX_A  = 'h0,
	  SEL_MUX_X  = 'h1,
      SEL_MUX_Y  = 'h2,
	  SEL_MUX_SP  = 'h3
	  } mux_sel;
      
   
   
   typedef enum logic [7:0] {
      LDA_IMM    = 'hA9,
      LDA_ZPAGE  = 'hA5,
      LDA_ZPAGEX = 'hB5,
      LDA_ABS    = 'hAD,
      LDA_ABSX   = 'hBD,
      LDA_ABSY   = 'hB9,
      LDA_INDX   = 'hA1,
      LDA_INDY   = 'hB1,
	  LDX_INM  	 = 'hA2,
      LDX_ZPAGE  = 'hA6,
      LDX_ABS	 = 'hAE,
      LDX_ABSY	 = 'hBE,
      LDX_ZPAGEY = 'hB6,
	  LDY_INM	 = 'hA0,
      LDY_ZPAGE	 = 'hA4,
      LDY_ZPAGEX = 'hB4,
      LDY_ABS	 = 'hAC,
      LDY_ABSX	 = 'hBC,
      STA_ZPAGE  = 'h85,
      STA_ZPAGEX = 'h95,
      STA_INDX   = 'h81,
      STA_INDY   = 'h91,
      STA_ABS    = 'h8D,
      STA_ABSX   = 'h9D,
      STA_ABSY   = 'h99,
	  STX_ZPAGE	 = 'h86,
      STX_ABS	 = 'h8E,
      STX_ZPAGEY = 'h96,
	  STY_ZPAGE  = 'h84,
      STY_ZPAGEX = 'h94,
      STY_ABS    = 'h8C,
	  ORA_INM	 = 'h09,
	  ORA_ZPAGE  = 'h05,
	  ORA_ZPAGEX = 'h15,
	  ORA_ABS    = 'h0D,
	  ORA_ABSX   = 'h1D,
	  ORA_ABSY   = 'h19,
      ORA_INDX   = 'h01,
	  ORA_INDY   = 'h11,
	  EOR_INM	 = 'h49,
      EOR_ZPAGE  = 'h45,
      EOR_ZPAGEX = 'h55,
      EOR_ABS    = 'h4D,
      EOR_ABSX   = 'h5D,
      EOR_ABSY   = 'h59,
      E0R_INDX   = 'h41,
      EOR_INDY   = 'h51,
      AND_IMM    = 'h29,
      AND_ZPAGE  = 'h25,
      AND_ZPAGEX = 'h35,
      AND_ABS    = 'h2D,
      AND_ABSX   = 'h3D,
      AND_ABSY   = 'h39,
      AND_INDX   = 'h21,
      AND_INDY   = 'h31,    
      INCX_Implied = 'hE8
   } opcode_t;

   covergroup cg_store @(posedge cpu_ref_intf.clk);
      cp_store: coverpoint cpu_ref_intf.wen {
         bins n_wen    = {1'b1};
         bins others   = default;
      }
      cp_sta_addr_mode: coverpoint opcode_t'(cpu_ref_intf.opcode) {
         bins sta_addr_mode[] ={STA_ZPAGE, STA_ZPAGEX, STA_INDX, STA_INDY, STA_ABS, STA_ABSX, STA_ABSY};
         bins others          = default;
      }

      cp_stx_addr_mode: coverpoint opcode_t'(cpu_ref_intf.opcode) {
         bins stx_addr_mode[] ={STX_ZPAGE, STX_ABS, STX_ZPAGEY};
         bins others          = default;
      }
      cp_sty_addr_mode: coverpoint opcode_t'(cpu_ref_intf.opcode) {
         bins sty_addr_mode[] ={STY_ZPAGE, STY_ABS, STY_ZPAGEX};
         bins others          = default;
      }

      cross_store: cross cp_store, cp_sta_addr_mode, cp_stx_addr_mode, cp_sty_addr_mode;
   endgroup

   //###########################################
   // Israel Code.
   //###########################################
   covergroup cg_pressed_button @(posedge cpu_ref_intf.clk);
      cp_mem_read_en: coverpoint cpu_ref_intf.ren {
         bins n_ren    = {1'b1};
         bins others   = default;
      }
	  
	  cp_joy_pad1: coverpoint cpu_ref_intf.cpu_addr_out {
         bins joy_pad1_addr    = {16'h4016};
         bins others   = default;
      }
	  
	  cross_joy_pad1: cross cp_mem_read_en, cp_joy_pad1;
	endgroup  
   //###########################################
   
   covergroup cg_load @(posedge cpu_ref_intf.clk);
      cp_load: coverpoint cpu_ref_intf.ren {
         bins n_ren    = {1'b1};
         bins others   = default;
      }
      cp_lda_addr_mode: coverpoint opcode_t'(cpu_ref_intf.opcode) {
         bins lda_addr_mode[] = {LDA_ZPAGE, LDA_ZPAGEX, LDA_INDX, LDA_INDY, LDA_ABS, LDA_ABSX, LDA_ABSY, LDA_IMM};
         bins others          = default;
      }
      //
      // TODO: add coverpoints for other load operations.
      //
      cross_load: cross cp_load, cp_lda_addr_mode;
   endgroup

   
	  /* begin Ricardo's block*/
	covergroup cg_Mux @(posedge cpu_ref_intf.clk);
	  cp_Mux: coverpoint mux_sel'(cpu_ref_intf.muxRegSel) {
         bins mux_addr_mode[] = {SEL_MUX_A, SEL_MUX_X, SEL_MUX_Y, SEL_MUX_SP};
         bins others          = default;
      }
	  //
      // TODO: add coverpoints for other load operations.
      //
     // cross_load: cross cp_Mux;
 endgroup
	  /* end Ricardo's block*/
	  
	  /* begin Alex's block*/
	covergroup cg_Save_Inst @(posedge cpu_ref_intf.clk);
	  cp_Save_Inst: coverpoint opcode_t'(cpu_ref_intf.inst_reg) {
         bins lda_addr_mode[] = {LDA_ZPAGE, LDA_ZPAGEX, LDA_INDX, LDA_INDY, LDA_ABS, LDA_ABSX, LDA_ABSY, LDA_IMM,LDX_INM,LDX_ZPAGE,LDX_ABS,LDX_ABSY,
		                         LDX_ZPAGEY,LDY_INM,LDY_ZPAGE,LDY_ZPAGEX,LDY_ABS,LDY_ABSX,AND_ZPAGE, AND_ZPAGEX, AND_INDX, AND_INDY, AND_ABS,
								 AND_ABSX, AND_ABSY, AND_IMM,STA_ZPAGE, STA_ZPAGEX, STA_INDX, STA_INDY, STA_ABS, STA_ABSX, STA_ABSY,STX_ZPAGE,
								 STX_ABS,STX_ZPAGEY,STY_ZPAGE,STY_ZPAGEX,STY_ABS,ORA_INM,ORA_ZPAGE,ORA_ZPAGEX,ORA_ABS,ORA_ABSX,ORA_ABSY,ORA_INDX,
								 ORA_INDY,EOR_INM,EOR_ZPAGE,EOR_ZPAGEX,EOR_ABS,EOR_ABSX,EOR_ABSY,E0R_INDX,EOR_INDY};
         bins others          = default;
      }
 endgroup
	  /* end Alex's block*/


	
   /* begin Gilberto's block*/
   covergroup cg_logic_aritmetic @(posedge cpu_ref_intf.clk);
    cp_and_addr_mode: coverpoint opcode_t'(cpu_ref_intf.opcode) {
         bins and_addr_mode[] = {AND_ZPAGE, AND_ZPAGEX, AND_INDX, AND_INDY, AND_ABS, AND_ABSX, AND_ABSY, AND_IMM};
         bins others          = default;
      }
      
      //
      // TODO: add coverpoints for other AND logic aritmetic operation.
      //
   endgroup
   /* end Gilberto's block*/
/****************GUS*BEGIN*****************/
  covergroup cg_TXS @(posedge cpu_ref_intf.clk);
      cp_TXS: coverpoint cpu_ref_intf.opcode {
         bins n_opcode    = {8'h9A};
         bins others   = default;
      }  
   endgroup
/****************GUS*END*******************/

////**********Covertura INCX David **************************
   covergroup cg_Incx @(posedge cpu_ref_intf.clk);
	  cp_Incx: coverpoint opcode_t'(cpu_ref_intf.opcode)
	    {bins incx_addr_mode[]={INCX_Implied};
	     bins others = default;
	     }
   endgroup
////////********************************   

   cg_logic_aritmetic cg_logic_aritmetic_int = new(); //Gil B.
   cg_Mux  cg_Mux_inst = new(); //ricardo
   cg_Save_Inst cg_Save_Inst_inst =new(); //Alex
      cg_TXS  cg_TXS_inst = new(); //Gus
   cg_load  cg_load_inst = new();
   cg_store cg_store_inst = new();
   cg_pressed_button cg_pressed_button_inst = new(); // Israel.
   cg_Incx cg_Incx_inst = new();//David

 /*Cover point for interruption RST*/
   covergroup cg_rst_int @ (posedge cpu_ref_intf.b_rst);
     cp_rst_int: coverpoint cpu_ref_intf.b_rst{
        bins p_b_rst = {1'b1};
        bins others = default;
     }
   endgroup
 /***********       Covert for Interruptions      *******************/
  cg_rst_int cg_rst_int_inst = new();
    
endmodule

`endif

