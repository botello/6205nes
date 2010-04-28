

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

