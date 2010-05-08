

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
         if (enable_reg_acc) begin
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
         if (enable_reg_acc) begin
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

   virtual protected task monitor_wmem();
      longint count = 0;
      forever begin
         @(posedge vi.clk);
         if (enable_wmem) begin
            if (vi.wen) fork verify_wmem(++count, vi.cpu_addr_out, vi.cpu_data_out); join_none
         end
      end
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

