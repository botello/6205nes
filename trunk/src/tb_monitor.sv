

`ifndef TB_MONITOR_SV
`define TB_MONITOR_SV

`include "mem_pkg.sv"

class tb_monitor extends component_base;

   protected virtual tb_cpu_if vi;
   bit enable_rmem    = 1;
   bit enable_wmem    = 1;
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

