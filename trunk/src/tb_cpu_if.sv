

`ifndef CPU_IF_SV
`define CPU_IF_SV

interface tb_cpu_if ();

   logic        clk;
   logic        syn_clk;
   logic        b_rst;
   logic        b_nmi;
   logic        b_irq;

   logic [15:0] cpu_addr_out;
   logic [ 7:0] cpu_data_out;
   logic [ 7:0] cpu_data_in;
   logic        ren;
   logic        wen;
   logic        rdy;
   logic        so;

   logic [ 7:0] q_a_o_i;
   logic [ 7:0] q_x_o_i;
   logic [ 7:0] q_y_o_i;
   logic [ 7:0] result_low1_o_i;//gus

   reg [7:0] mem_rom_r   [2**15-1:0];
   reg [7:0] mem_ram_r   [2**11-1:0];
   reg [7:0] mem_sram_r  [2**13-1:0];
   reg [7:0] mem_ioreg_r [2**03-1:0];

   reg [7:0] opcode;
   reg [7:0] fsm_current_state;

   reg [1:0] muxRegSel;
   reg [7:0] muxOut;
   reg [7:0] regAinternal; //Ricardo
   reg [7:0] regXinternal;//Ricardo
   reg [7:0] regYinternal;//Ricardo
   
   reg [7:0] inst_reg;//Alex
   reg       phi2;//Alex
   reg       inst_en;//Alex
   
   
   modport cpu (
      input  clk,
      input  b_rst,
      input  b_nmi,
      input  b_irq,
      input  rdy,
      input  cpu_data_in,
      output cpu_data_out,
      output cpu_addr_out,
      output ren,
      output wen,
      output syn_clk,
      output so
   );

   modport mem (
      input  clk,
      input  b_rst,
      input  wen,
      input  ren,
      input  cpu_addr_out,
      input  cpu_data_out,
      output cpu_data_in
   );

   modport tb (
      input  clk,
      input  b_rst,
      input  b_nmi,
      input  b_irq,
      input  rdy,
      input  cpu_data_in,
      output cpu_data_out,
      output cpu_addr_out,
      output ren,
      output wen,
      output syn_clk,
      output so
   );

endinterface

`endif

