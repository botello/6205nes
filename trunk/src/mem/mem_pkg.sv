

`ifndef MEM_PKG_SV
`define MEM_PKG_SV

package mem_pkg;

   // Memory address map (4 MSB):
   //   Address[15:13] == 3'b1XX PrgROM           32kB de ROM at Address[14:0]
   //   Address[15:13] == 3'b011 SRAM              8kB de SRAM at Address[12:0]
   //   Address[15:13] == 3'b000 RAM               2kB de RAM at Address[10:0]
   //   Address[15:13] == 3'b001 Picture I/O regs  8Bytes IO  at Address[2:0]
   //   Address[15:13] == 3'b010 Expanssion ROM, audio, DMA & controllers I/O regs (see IO register map below).
   localparam  ADDR_15_13_ROM0  = 3'b100,
               ADDR_15_13_ROM1  = 3'b101,
               ADDR_15_13_ROM2  = 3'b110,
               ADDR_15_13_ROM3  = 3'b111,
               ADDR_15_13_SRAM  = 3'b011,
               ADDR_15_13_OTHER = 3'b010,
               ADDR_15_13_IOREG = 3'b001,
               ADDR_15_13_RAM   = 3'b000;

   localparam  ADDR_RESET_H = 16'hFFFD,
               ADDR_RESET_L = 16'hFFFC,
               ADDR_NMI_H   = 16'hFFFB,
               ADDR_NMI_L   = 16'hFFFA,
               ADDR_IRQ_H   = 16'hFFFF,
               ADDR_IRQ_L   = 16'hFFFE;

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

endpackage

`endif

