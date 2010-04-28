

`ifndef MEM_TOP_SV
`define MEM_TOP_SV

module mem_top(tb_cpu_if.mem intf);

   logic debug_mode = 1;

   // Memory address map (4 MSB):
   //   Address[15:13] == 3'b1XX PrgROM           32kB de ROM at Address[14:0]
   //   Address[15:13] == 3'b011 SRAM              8kB de RAM at Address[12:0]
   //   Address[15:13] == 3'b000 RAM               2kB de RAM at Address[10:0]
   //   Address[15:13] == 3'b001 Picture I/O regs  8Bytes IO  at Address[2:0]
   //   Address[15:13] == 3'b010 Expanssion ROM, audio, DMA & controllers I/O regs (see IO register map below).
   localparam  ADDR_15_13_ROM   = 3'b1XX,
               ADDR_15_13_SRAM  = 3'b011,
               ADDR_15_13_OTHER = 3'b010,
               ADDR_15_13_IOREG = 3'b001,
               ADDR_15_13_RAM   = 3'b000;

   // IO Register map:
   //   2000h - PPU Control Register 1 (W)
   //   2001h - PPU Control Register 2 (W)
   //   2002h - PPU Status Register (R)
   //   2003h - SPR-RAM Address Register (W)
   //   2004h - SPR-RAM Data Register (RW)
   //   2005h - PPU Background Scrolling Offset (W2)
   //   2006h - VRAM Address Register (W2)
   //   2007h - VRAM Read/Write Data Register (RW)
   //   4000h - APU Channel 1 (Rectangle) Volume/Decay
   //   4001h - APU Channel 1 (Rectangle) Sweep
   //   4002h - APU Channel 1 (Rectangle) Frequency
   //   4003h - APU Channel 1 (Rectangle) Length
   //   4004h - APU Channel 2 (Rectangle) Volume/Decay
   //   4005h - APU Channel 2 (Rectangle) Sweep
   //   4006h - APU Channel 2 (Rectangle) Frequency
   //   4007h - APU Channel 2 (Rectangle) Length
   //   4008h - APU Channel 3 (Triangle) Linear Counter
   //   4009h - APU Channel 3 (Triangle) N/A
   //   400Ah - APU Channel 3 (Triangle) Frequency
   //   400Bh - APU Channel 3 (Triangle) Length
   //   400Ch - APU Channel 4 (Noise) Volume/Decay
   //   400Dh - APU Channel 4 (Noise) N/A
   //   400Eh - APU Channel 4 (Noise) Frequency
   //   400Fh - APU Channel 4 (Noise) Length
   //   4010h - APU Channel 5 (DMC) Play mode and DMA frequency
   //   4011h - APU Channel 5 (DMC) Delta counter load register
   //   4012h - APU Channel 5 (DMC) Address load register
   //   4013h - APU Channel 5 (DMC) Length register
   //   4014h - SPR-RAM DMA Register
   //   4015h - DMC/IRQ/length counter status/channel enable register (RW)
   //   4016h - Joypad #1 (RW)
   //   4017h - Joypad #2/APU SOFTCLK (RW)
   localparam  ADDR_PPU_CR1        = 16'h2000,
               ADDR_PPU_CR2        = 16'h2001,
               ADDR_PPU_SR         = 16'h2002,
               ADDR_SPR_RAM_ADDR   = 16'h2003,
               ADDR_SPR_RAM_DATA   = 16'h2004,
               ADDR_PPU_BGND_SCRLL = 16'h2005,
               ADDR_VRAM_ADDR      = 16'h2006,
               ADDR_VRAM_DATA      = 16'h2007,
               ADDR_APU_CH1_VOL    = 16'h4000,
               ADDR_APU_CH1_SWEEP  = 16'h4001,
               ADDR_APU_CH1_FREQ   = 16'h4002,
               ADDR_APU_CH1_LEN    = 16'h4003,
               ADDR_APU_CH2_VOL    = 16'h4004,
               ADDR_APU_CH2_SWEEP  = 16'h4005,
               ADDR_APU_CH2_FREQ   = 16'h4006,
               ADDR_APU_CH2_LEN    = 16'h4007,
               ADDR_APU_CH3_LCNT   = 16'h4008,
               ADDR_APU_CH3_NA     = 16'h4009,
               ADDR_APU_CH3_FREQ   = 16'h400A,
               ADDR_APU_CH3_LEN    = 16'h400B,
               ADDR_APU_CH4_VOL    = 16'h400C,
               ADDR_APU_CH4_NA     = 16'h400D,
               ADDR_APU_CH4_FREQ   = 16'h400E,
               ADDR_APU_CH4_LEN    = 16'h400F,
               ADDR_APU_CH5_PLAY   = 16'h4010,
               ADDR_APU_CH5_DCNT   = 16'h4011,
               ADDR_APU_CH5_ADDR   = 16'h4012,
               ADDR_APU_CH5_LEN    = 16'h4013,
               ADDR_SPR_RAM_DMA    = 16'h4014,
               ADDR_DMC_IRQ_LCNT   = 16'h4015,
               ADDR_JOYPAD1        = 16'h4016,
               ADDR_JOYPAD2        = 16'h4017;

   reg [7:0] mem_rom_init[2**15-1:0];
   reg [7:0] mem_rom_r   [2**15-1:0];
   reg [7:0] mem_rom     [2**15-1:0];
   reg [7:0] mem_ram_r   [2**11-1:0];
   reg [7:0] mem_ram     [2**11-1:0];
   reg [7:0] mem_sram_r  [2**13-1:0];
   reg [7:0] mem_sram    [2**13-1:0];
   reg [7:0] mem_ioreg_r [2**03-1:0];
   reg [7:0] mem_ioreg   [2**03-1:0];

   // Specific purpose IO devices mapped at ADDR_15_13_OTHER.
   reg [7:0] io_joypad1_r,     io_joypad1;
   reg [7:0] io_joypad2_r,     io_joypad2;
   reg [7:0] io_spr_ram_dma_r, io_spr_ram_dma;

   always @(*) begin : mem_read_proc
      intf.cpu_data_in = 'h0;

      if (intf.ren) begin
         //$display("%p [MEM] READ at [0x%h]", $time, intf.cpu_addr_out);
         case (intf.cpu_addr_out[15:13])
            ADDR_15_13_ROM   : intf.cpu_data_in = mem_rom_r  [intf.cpu_addr_out[14:0]];
            ADDR_15_13_RAM   : intf.cpu_data_in = mem_ram_r  [intf.cpu_addr_out[10:0]];
            ADDR_15_13_SRAM  : intf.cpu_data_in = mem_sram_r [intf.cpu_addr_out[12:0]];
            ADDR_15_13_IOREG : intf.cpu_data_in = mem_ioreg_r[intf.cpu_addr_out[02:0]];
            //
            // TODO: Add mapping for ADDR_JOYPAD1 and ADDR_SPR_RAM_DMA selected
            //       when the 3 MSB in address are 3'b001.
            //
            ADDR_15_13_OTHER : begin
               case (intf.cpu_addr_out)
                  //
                  // TODO: Emulation of joypads could be implemented in the
                  //       memory BFM instead of just behaving as a regular
                  //       register.
                  //
                  ADDR_JOYPAD1     : intf.cpu_data_in = io_joypad1_r;
                  ADDR_JOYPAD2     : intf.cpu_data_in = io_joypad2_r;
                  ADDR_SPR_RAM_DMA : intf.cpu_data_in = io_spr_ram_dma;
                  16'h0001         : intf.cpu_data_in = 8'hCA;
                  default          : $error("%p [MEM] READ operation to IO not implemented at [0x%h]", $time, intf.cpu_addr_out);
               endcase
            end
         endcase
      end
   end

   always @(posedge intf.clk) begin : mem_write_proc
      integer i;
      for (i = 0; i < 2**15; i = i + 1) mem_rom[i]   = mem_rom_r[i];
      for (i = 0; i < 2**13; i = i + 1) mem_sram[i]  = mem_sram_r[i];
      for (i = 0; i < 2**11; i = i + 1) mem_ram[i]   = mem_ram_r[i];
      for (i = 0; i < 2**03; i = i + 1) mem_ioreg[i] = mem_ioreg_r[i];

      io_joypad1     = io_joypad1_r;
      io_joypad2     = io_joypad2_r;
      io_spr_ram_dma = io_spr_ram_dma_r;

      if (intf.wen) begin
         //$display("%p [MEM] WRITE at [0x%h] 0x%h", $time, intf.cpu_addr_out, intf.cpu_data_out);
         case (intf.cpu_addr_out[15:13])
            ADDR_15_13_ROM   : $fatal("%p [MEM] WRITE operation to ROM detected at [0x%h] 0x%h", $time, intf.cpu_addr_out, intf.cpu_data_out);
            ADDR_15_13_RAM   : mem_ram  [intf.cpu_addr_out[10:0]] = intf.cpu_data_out;
            ADDR_15_13_SRAM  : mem_sram [intf.cpu_addr_out[12:0]] = intf.cpu_data_out;
            ADDR_15_13_IOREG : mem_ioreg[intf.cpu_addr_out[02:0]] = intf.cpu_data_out;
            //
            // TODO: Add mapping for ADDR_JOYPAD1 and ADDR_SPR_RAM_DMA selected
            //       when the 3 MSB in address are 3'b001.
            //
            ADDR_15_13_OTHER : begin
               case (intf.cpu_addr_out)
                  ADDR_JOYPAD1     : io_joypad1     = intf.cpu_data_out;
                  ADDR_JOYPAD2     : io_joypad2     = intf.cpu_data_out;
                  ADDR_SPR_RAM_DMA : io_spr_ram_dma = intf.cpu_data_out;
                  default          : $fatal("%p [MEM] WRITE operation to IO not implemented at [0x%h] 0x%h", $time, intf.cpu_addr_out, intf.cpu_data_out);
               endcase
            end
         endcase
      end
   end

   always @(posedge intf.clk) begin : mem_reg
      integer i;
      for (i = 0; i < 2**15; i = i + 1) mem_rom_r[i]   <= (~intf.b_rst) ? mem_rom_init[i] : mem_rom[i];
      for (i = 0; i < 2**11; i = i + 1) mem_ram_r[i]   <= (~intf.b_rst) ? 'h0             : mem_ram[i];
      for (i = 0; i < 2**13; i = i + 1) mem_sram_r[i]  <= (~intf.b_rst) ? 'h0             : mem_sram[i];
      for (i = 0; i < 2**03; i = i + 1) mem_ioreg_r[i] <= (~intf.b_rst) ? 'h0             : mem_ioreg[i];

      io_joypad1_r     <= (~intf.b_rst) ? 'h0 : io_joypad1;
      io_joypad2_r     <= (~intf.b_rst) ? 'h0 : io_joypad2;
      io_spr_ram_dma_r <= (~intf.b_rst) ? 'h0 : io_spr_ram_dma;
   end

   initial begin : rom_init_proc
      integer i, j; string s; string filename;
      filename = "src/programs/SMB_32PRG.txt";
      for (i = 0; i < 2**15; i = i + 1) mem_rom_init[i] = 'h0;
      $readmemh(filename, mem_rom_init);

      if (debug_mode) begin
         s = $sformatf("%p [MEM] INIT ROM '%s':", $time, filename);
         for (i = 0; i < 2**15; i = i + 32) begin
            s = {s, $sformatf("\n [%h] ", i)};
            for (j = 0; j < 32; j = j + 1) s = {s, $sformatf(" %h", mem_rom_init[i + j])};
         end
         $display("%s\n", s);
      end
   end

endmodule

`endif

