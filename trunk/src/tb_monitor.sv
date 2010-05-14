

`ifndef TB_MONITOR_SV
`define TB_MONITOR_SV

`include "mem_pkg.sv"

class tb_monitor extends component_base;

   protected virtual tb_cpu_if vi;
   bit enable_rmem    = 1;
   bit enable_wmem    = 1;
   bit enable_b_rst   = 1;
   bit enable_reg_acc = 1;
   bit enable_reg_x   = 1;
   bit enable_reg_y   = 1;
   bit enable_mux_reg = 1; //ricardo
   bit enable_mux_reg_Out = 1; //ricardo
    bit enable_inst_en = 1;//Alex
   bit enable_phi2 = 1; //Alex
   bit enable_inst_reg = 1;//Alex   
   bit enable_reg_sp   = 1;//gus
   bit enable_TXS	  = 1;//gus
   bit enable_cpu_addr_out = 1; //Rst_Interrupt

   function new(string name = "tb_monitor", component_base patent);
      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void assign_vi(virtual interface tb_cpu_if vi);
      this.vi = vi;
   endfunction

   virtual function void configure();
      super.configure();
   endfunction

   virtual task run();
      super.run();
      fork
        monitor_rmem();
        monitor_wmem();
        monitor_b_rst();
        monitor_reg_acc();
        monitor_reg_x();
        monitor_reg_y();
		    monitor_press_control(); // Israel Code.
		    monitor_mux_reg(); //ricardo monitor
		    monitor_mux_reg_out(); // ricardo monitor
		    monitor_inst_en ();//Alex monitor
		    monitor_phi2 ();//Alex monitor
		    monitor_inst_reg ();//Alex monitor
		    monitor_reg_SP(); //GUS
		    monitor_TXS();//GUS
		    monitor_reg_x2();//DAVID
		    monitor_logic_aritmetic();//Gil B. monitor
		    monitor_cpu_addr_out(); //RST interruption
      join
   endtask

   virtual function void report();
      super.report();
   endfunction

   virtual protected task monitor_reg_acc();
      int unsigned last_value;
      longint count = 0;
      last_value = 'x;
      forever begin
         @(posedge vi.clk);
         if (enable_reg_acc) begin
            if (vi.q_a_o_i != last_value) begin
               last_value = vi.q_a_o_i;
               report_info("CPU", $sformatf("#%p REG WRITE ACC = 0x%x", ++count, vi.q_a_o_i));
            end
         end
      end
   endtask

   virtual protected task monitor_reg_y();
      int unsigned last_value;
      longint count = 0;
      last_value = 'x;
      forever begin
         @(posedge vi.clk);
         //if (enable_reg_acc) begin
		 if (enable_reg_y) begin //ricardo
            if (vi.q_y_o_i != last_value) begin
               last_value = vi.q_y_o_i;
               report_info("CPU", $sformatf("#%p REG WRITE Y = 0x%x", ++count, vi.q_y_o_i));
            end
         end
      end
   endtask

   virtual protected task monitor_reg_x();
      int unsigned last_value;
      longint count = 0;
      last_value = 'x;
      forever begin
         @(posedge vi.clk);
         //if (enable_reg_acc) begin
		 if (enable_reg_x) begin //Ricardo
            if (vi.q_x_o_i != last_value) begin
               last_value = vi.q_x_o_i;
               report_info("CPU", $sformatf("#%p REG WRITE X = 0x%x", ++count, vi.q_x_o_i));
            end
         end
      end
   endtask

   virtual protected task monitor_rmem();
      longint count = 0;
      forever begin
         // Assuming reading from memory is instantaneous.
         @(posedge vi.clk);
         if (enable_rmem) begin
            if (vi.ren) begin
               report_info("MEM", $sformatf("#%p READ %s [0x%x] = 0x%x", ++count, decode_addr(vi.cpu_addr_out), vi.cpu_addr_out, vi.cpu_data_in));
            end
         end
      end
   endtask
   //###############################
   // Israel: Code.
   //###############################
   virtual protected task monitor_press_control();
	  int temp = 0;
	  int pressed_button = 0;
      forever begin
         // Assuming reading from memory is instantaneous.
         @(posedge vi.clk);
         if (enable_rmem) begin
            if ((vi.ren) && (vi.cpu_addr_out == ADDR_JOYPAD1)) begin
			   fork
			      pressed_button = vi.cpu_data_in & 'h1;
			      repeat(7) begin
				     @(posedge vi.clk);
					 pressed_button = pressed_button <<< 1;
					 temp = vi.cpu_data_in & 'h1;
				     pressed_button = pressed_button + temp;
			      end
			      if ((pressed_button <= 'h9) && (pressed_button >= 'h1))
			         report_info("Button", $sformatf("Pressed = 0x%x", pressed_button));
			      else
			        report_info("Button", $sformatf("Pressed  Invalid = 0x%x", pressed_button));
				join
            end
         end
      end
   endtask
   //###############################

   virtual protected task monitor_wmem();
      longint count = 0;
      forever begin
         @(posedge vi.clk);
         if (enable_wmem) begin
            if (vi.wen) fork verify_wmem(++count, vi.cpu_addr_out, vi.cpu_data_out); join_none
         end
      end
   endtask
/*begin Ricardo's block*/
   virtual protected task monitor_mux_reg();
      int unsigned last_value;
      longint count = 0;
      last_value = '0;
      forever begin
         @(posedge vi.clk);
         if (enable_mux_reg) begin
            if (vi.muxRegSel != last_value) begin
               last_value = vi.muxRegSel;
               report_info("MUX", $sformatf("#%p MUX REG SEL= 0x%x", ++count, vi.muxRegSel));
			   if (vi.muxRegSel) fork verify_muxReg(++count, vi.muxRegSel); join_none
			 end
         end
      end
   endtask

   virtual protected task monitor_mux_reg_out();
      int unsigned last_value;
      longint count = 0;
      last_value = '0;
      forever begin
         @(posedge vi.clk);
         if (enable_mux_reg_Out) begin
            if (vi.muxOut != last_value) begin
               last_value = vi.muxOut;
               report_info("MUX OUT", $sformatf("#%p MUX REG OUT= 0x%x", ++count, vi.muxOut));
			 end
         end
      end
   endtask
   
   task verify_muxReg(longint count, reg [1:0] muxRegSelect);
      int unsigned muxSelecction;
      @(posedge vi.clk);
      case (muxRegSelect)
			'h0: muxSelecction = 0;  //A
			'h1: muxSelecction = 1; // X
			'h2: muxSelecction = 2;  //Y
			'h3: muxSelecction = 3;  //SP
      endcase
      if (muxSelecction  == muxRegSelect)
         report_info("MUX", $sformatf("#%p MUX SELECCTION CORRECT 0x%x", count, muxRegSelect));
      else 
         report_error("MUX", $sformatf("#%p MUX SELECCTION  FAILED  0x%x (expected: 0x%x)", count, vi.muxRegSel, muxRegSelect));
   endtask
   
   
 /*end Ricardo's block*/   
 
 
  /*begin Alex's block*/
   virtual protected task monitor_inst_en();
      int unsigned last_value;
      longint count = 0;
      last_value = '0;
      forever begin
         @(posedge vi.clk);
         if (enable_inst_en) begin
            if (vi.inst_en != last_value) begin
               last_value = vi.inst_en;
               report_info("INSTRUCTION_EN", $sformatf("#%p INSTRUCTION_EN= 0x%x", ++count, vi.inst_en));
			 end
         end
      end
   endtask

   virtual protected task monitor_phi2();
      int unsigned last_value;
      longint count = 0;
      last_value = '0;
      forever begin
         @(posedge vi.clk);
         if (enable_phi2) begin
            if (vi.phi2 != last_value) begin
               last_value = vi.phi2;
               report_info("PHI2", $sformatf("#%p PHI2= 0x%x", ++count, vi.phi2));
			   if (vi.phi2)fork verify_Save_instruction (++count, vi.phi2, vi.inst_en); join_none 
			 end
         end
      end
   endtask
   
   virtual protected task monitor_inst_reg();
      int unsigned last_value;
      longint count = 0;
      last_value = '0;
      forever begin
         @(posedge vi.clk);
         if (enable_inst_reg) begin
            if (vi.inst_reg != last_value) begin
               last_value = vi.inst_reg;
               report_info("INSTRUCTION_REG", $sformatf("#%p INSTRUCTION_REG= 0x%x", ++count, vi.inst_reg));
			    
			 end
         end
      end
   endtask
   
   /*Rst Interruption monitor*/
   virtual protected task monitor_cpu_addr_out();
       int count = 0;
       longint inc = 0;
       forever begin
         @( negedge vi.b_rst or vi.clk)
         if(!vi.b_rst) begin
           count = 0;
         end
         
         else
           if(enable_cpu_addr_out) begin
             count = count + 1;
             if(count == 11) begin
               inc= inc +1;
               fork verify_cpu_address_rst_int(inc); join_none
             end
           end
         end
        
   endtask
   
   
   
   task verify_Save_instruction(longint count, bit phi2, bit inst_en);
    @(posedge vi.clk);
      if (phi2 == inst_en)
         report_info("INSTRUCTION_SAVE", $sformatf("#%p WRITE INSTRUCTION CORRECT [0x%x] = 0x%x", count, phi2, inst_en));
      else 
         report_error("INSTRUCTION_SAVE", $sformatf("#%p WRITE INSTRUCTION FAILED  [0x%x] = 0x%x (expected: 0x%x 0x%x)", count , phi2, inst_en, 1,1));
   endtask 
   
 /*end Alex's block*/

 /******************GUS::BEGIN**********************/
   virtual protected task monitor_reg_SP();
      int unsigned last_value;
      longint count = 0;
      last_value = 'x;
      forever begin
         @(posedge vi.clk);
         if (enable_reg_sp) begin
            if (vi.result_low1_o_i != last_value) begin
               last_value = vi.result_low1_o_i;
               report_info("CPU", $sformatf("#%p REG WRITE SP = 0x%x", ++count, vi.result_low1_o_i));			   
            end
         end
      end
   endtask
   
   virtual protected task monitor_TXS();
      longint count = 0;
	  bit r=0;
      forever begin
         @(posedge vi.clk);		
		 r=~r;		 
         if (enable_TXS==1 && r==1) begin
              fork verify_TXS(++count, vi.cpu_addr_out, vi.cpu_data_out); join_none
         end
      end
   endtask   
   
   task verify_TXS(longint count, int unsigned addr, int unsigned data);
      int unsigned rdata;
	 
	  @(posedge vi.clk);	 
	  case (addr[15:13])
         ADDR_15_13_RAM   : rdata = vi.mem_ram_r  [addr[10:0]];
         ADDR_15_13_SRAM  : rdata = vi.mem_sram_r [addr[12:0]];
         ADDR_15_13_IOREG : rdata = vi.mem_ioreg_r[addr[02:0]];
         ADDR_15_13_OTHER : rdata = 'x;
      endcase	
	 if (vi.opcode==8'h9A)	 
	begin
      if (vi.result_low1_o_i == vi.q_x_o_i)
	  begin
		 report_info("TXS", $sformatf("#%p TXS_OK %s [0x%x] = 0x%x ", count, decode_addr(addr), addr, data));		
	  end
      else
	  begin
         report_error("TXS", $sformatf("#%p TXS_FAILED %s [0x%x] = 0x%x (expected: 0x%x) ", count, decode_addr(addr), addr, rdata, data));		 
	  end
	end	
	
   endtask
   
   /******************GUS::END************************/
   
    //**************David monitor y cheker**********************************************
  virtual protected task monitor_reg_x2();
      int unsigned registrox_antvalor;
      int unsigned last_value = 'x;
      longint count = 0;
      longint bandera = 0;
      
      forever begin
         @(posedge vi.clk); begin
		       if (vi.opcode=='hE8 && count==0) 
		         begin
		           bandera=1;
		           count=count+1;
		           registrox_antvalor = vi.q_x_o_i;
		          end
      
		       if (bandera == 1 && vi.q_x_o_i != registrox_antvalor && count==1) begin
               last_value = vi.q_x_o_i;
               count=0;
               bandera=0;		               
            fork verify_incregx(++count,registrox_antvalor, last_value); join_none
              end
        end
    end
   endtask
   
   task verify_incregx(longint count, int unsigned registro, int unsigned q_x_o_i);
     if(q_x_o_i== registro + 1)
       report_info("RegX INCX", $sformatf(" REG X incrementado anterior = %x, nuevo = %x ",registro, vi.q_x_o_i));
     else 
       report_info("RegX INCX", $sformatf(" Error No incrementado %x  %x", vi.q_x_o_i, registro));
   endtask
   
 /////*************************end Davidmonitor y cheker****************************





/******************** begin Gil B. block ***************
*******************************************************/
    virtual protected task monitor_logic_aritmetic();
      logic [7:0] last_value_acc;
      longint count = 0;
      int bandera = 0;
      forever begin
         @(posedge vi.clk);
         if (enable_rmem & enable_reg_acc & enable_phi2) begin
            if (vi.opcode == 8'h29 && vi.phi2==0) begin
              bandera = 1;
              last_value_acc = vi.q_a_o_i;
            end
            else 
              if (bandera & vi.phi2)
                begin
                  bandera = 0;
                  fork verify_logic_aritmetic (++count, vi.cpu_data_out, vi.q_a_o_i, last_value_acc); join_none 
		            end
         end
      end
   endtask
  
  
  task verify_logic_aritmetic (longint count, int unsigned data, int unsigned acc, int unsigned last_value_acc);
      @(posedge vi.clk);  
        if (acc == (last_value_acc & data))
          report_info("AND IMM", $sformatf("#%p OPERACION  0x%x = 0x%x & %x", count, acc, last_value_acc,  data));
        else
          report_info("AND IMM", $sformatf("#%p OPERACION ERRONEA 0x%x != 0x%x & %x ", count, acc, last_value_acc, data ));
  endtask
  
  
  task verify_rmem(longint count, int unsigned addr, int unsigned data);
      int unsigned rdata;
      @(posedge vi.clk);
      case (addr[15:13])
         ADDR_15_13_RAM   : rdata = vi.mem_ram_r  [addr[10:0]];
         ADDR_15_13_SRAM  : rdata = vi.mem_sram_r [addr[12:0]];
         ADDR_15_13_IOREG : rdata = vi.mem_ioreg_r[addr[02:0]];
         ADDR_15_13_OTHER : rdata = 'x;
      endcase
      if (rdata == data)
         report_info("MEM", $sformatf("#%p READ %s [0x%x] = 0x%x", count, decode_addr(addr), addr, data));
      else 
         report_error("MEM", $sformatf("#%p READ FAILED %s [0x%x] = 0x%x (expected: 0x%x)", count, decode_addr(addr), addr, rdata, data));
   endtask

/******************** end Gil B. block *****************
*******************************************************/
//gil
   virtual protected task monitor_b_rst();
      int unsigned last_value;
      longint count = 0;
      last_value = '0;
      forever begin
         @(posedge vi.clk);
         if (enable_b_rst) begin
            if (vi.b_rst != last_value) begin
               last_value = vi.b_rst;
               report_info("B_RST", $sformatf("#%p B_RST= 0x%x", ++count, vi.b_rst));
               fork verify_interruption_rst( count, vi.b_rst); join_none
			 end
         end
      end
   endtask
   
   task verify_interruption_rst(longint count, longint b_rst);
    @(posedge vi.clk);
      if ( b_rst == vi.b_rst)
         report_info("RESET_COMPLET", $sformatf("#%p RESET INTERRUPTION CORRECT 0x%x", count, b_rst));
      else 
         report_error("RESET_SAVE", $sformatf("#%p RESET INTERRUPTION FAILED  [0x%x] = 0x%x (expected: 0x%x 0x%x)", count , b_rst, vi.b_rst, 1,1));
   endtask 
   
   
   
   
   /*Rst Interruption checkers*/
   task verify_cpu_address_rst_int (longint inc);
     if(vi.cpu_addr_out == 16'hfffc )
       report_info("RST_INTERRUPTION", $sformatf("#%p  CPU address: 0x%x", inc, vi.cpu_addr_out));

     else 
       report_error("RST_INTERRUPTION", $sformatf("#%p RST INT FAILED address:0x%x (expected address: 0xfffc)", inc, vi.cpu_addr_out));
   endtask
 

   task verify_wmem(longint count, int unsigned addr, int unsigned data);
      int unsigned rdata;
      @(posedge vi.clk);
      case (addr[15:13])
         ADDR_15_13_RAM   : rdata = vi.mem_ram_r  [addr[10:0]];
         ADDR_15_13_SRAM  : rdata = vi.mem_sram_r [addr[12:0]];
         ADDR_15_13_IOREG : rdata = vi.mem_ioreg_r[addr[02:0]];
         ADDR_15_13_OTHER : rdata = 'x;
      endcase
      if (rdata == data)
         report_info("MEM", $sformatf("#%p WRITE %s [0x%x] = 0x%x", count, decode_addr(addr), addr, data));
      else 
         report_error("MEM", $sformatf("#%p WRITE FAILED %s [0x%x] = 0x%x (expected: 0x%x)", count, decode_addr(addr), addr, rdata, data));
   endtask

   local function string decode_addr(int unsigned addr);
      string s; s = "OTHER";
      case (addr[15:13])
         ADDR_15_13_ROM0,
         ADDR_15_13_ROM1,
         ADDR_15_13_ROM2,
         ADDR_15_13_ROM3  : s = "ROM";
         ADDR_15_13_RAM   : s = "RAM";
         ADDR_15_13_SRAM  : s = "SRAM";
         ADDR_15_13_IOREG : s = "IOREG";
         ADDR_15_13_OTHER : begin
            case (addr)
               ADDR_PPU_CR1        : s = "ADDR_PPU_CR1";
               ADDR_PPU_CR2        : s = "ADDR_PPU_CR2";
               ADDR_PPU_SR         : s = "ADDR_PPU_SR";
               ADDR_SPR_RAM_ADDR   : s = "ADDR_SPR_RAM_ADDR";
               ADDR_SPR_RAM_DATA   : s = "ADDR_SPR_RAM_DATA";
               ADDR_PPU_BGND_SCRLL : s = "ADDR_PPU_BGND_SCRLL";
               ADDR_VRAM_ADDR      : s = "ADDR_VRAM_ADDR";
               ADDR_VRAM_DATA      : s = "ADDR_VRAM_DATA";
               ADDR_APU_CH1_VOL    : s = "ADDR_APU_CH1_VOL";
               ADDR_APU_CH1_SWEEP  : s = "ADDR_APU_CH1_SWEEP";
               ADDR_APU_CH1_FREQ   : s = "ADDR_APU_CH1_FREQ";
               ADDR_APU_CH1_LEN    : s = "ADDR_APU_CH1_LEN";
               ADDR_APU_CH2_VOL    : s = "ADDR_APU_CH2_VOL";
               ADDR_APU_CH2_SWEEP  : s = "ADDR_APU_CH2_SWEEP";
               ADDR_APU_CH2_FREQ   : s = "ADDR_APU_CH2_FREQ";
               ADDR_APU_CH2_LEN    : s = "ADDR_APU_CH2_LEN";
               ADDR_APU_CH3_LCNT   : s = "ADDR_APU_CH3_LCNT";
               ADDR_APU_CH3_NA     : s = "ADDR_APU_CH3_NA";
               ADDR_APU_CH3_FREQ   : s = "ADDR_APU_CH3_FREQ";
               ADDR_APU_CH3_LEN    : s = "ADDR_APU_CH3_LEN";
               ADDR_APU_CH4_VOL    : s = "ADDR_APU_CH4_VOL";
               ADDR_APU_CH4_NA     : s = "ADDR_APU_CH4_NA";
               ADDR_APU_CH4_FREQ   : s = "ADDR_APU_CH4_FREQ";
               ADDR_APU_CH4_LEN    : s = "ADDR_APU_CH4_LEN";
               ADDR_APU_CH5_PLAY   : s = "ADDR_APU_CH5_PLAY";
               ADDR_APU_CH5_DCNT   : s = "ADDR_APU_CH5_DCNT";
               ADDR_APU_CH5_ADDR   : s = "ADDR_APU_CH5_ADDR";
               ADDR_APU_CH5_LEN    : s = "ADDR_APU_CH5_LEN";
               ADDR_SPR_RAM_DMA    : s = "ADDR_SPR_RAM_DMA";
               ADDR_DMC_IRQ_LCNT   : s = "ADDR_DMC_IRQ_LCNT";
               ADDR_JOYPAD1        : s = "ADDR_JOYPAD1";
               ADDR_JOYPAD2        : s = "ADDR_JOYPAD2";
            endcase
         end
      endcase
      return s;
   endfunction

endclass

`endif

