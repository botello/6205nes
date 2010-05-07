

`ifndef MEM_TOP_SV
`define MEM_TOP_SV

`include "mem_pkg.sv"

module mem_top(tb_cpu_if.mem intf);

   import mem_pkg::*;

   logic debug_mode = 0;

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
         case (intf.cpu_addr_out[15:13])
            ADDR_15_13_ROM   : intf.cpu_data_in = mem_rom_r[intf.cpu_addr_out[14:0]];
            ADDR_15_13_RAM   : intf.cpu_data_in = mem_ram_r[intf.cpu_addr_out[10:0]];
            ADDR_15_13_SRAM  : intf.cpu_data_in = mem_sram_r[intf.cpu_addr_out[12:0]];
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
                  default          : begin
                     intf.cpu_data_in = 8'hXX;
                     $display("%p [MEM] READ operation to IO not implemented at [0x%h]", $time, intf.cpu_addr_out);
                  end
               endcase
            end
         endcase
         if (debug_mode) $display("%p [MEM] READ at [0x%h] 0x%h", $time, intf.cpu_addr_out, intf.cpu_data_in);
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
         case (intf.cpu_addr_out[15:13])
            ADDR_15_13_ROM   : $display("%p [MEM] WRITE operation to ROM detected at [0x%h] 0x%h", $time, intf.cpu_addr_out, intf.cpu_data_out);
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
                  default          : $display("%p [MEM] WRITE operation to IO not implemented at [0x%h] 0x%h", $time, intf.cpu_addr_out, intf.cpu_data_out);
               endcase
            end
         endcase
         if (debug_mode) $display("%p [MEM] WRITE at [0x%h] 0x%h", $time, intf.cpu_addr_out, intf.cpu_data_out);
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

