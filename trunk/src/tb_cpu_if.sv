

`ifndef CPU_IF_SV
`define CPU_IF_SV

interface tb_cpu_if (cpu_duv_if duv_intf, cpu_ref_if ref_intf);

   logic        clk;
   logic        syn_clk;
   logic        b_rst;
   logic        b_nmi;
   logic        b_irq;

   logic [15:0] addr_out;
   logic [ 7:0] data_out;
   logic [ 7:0] data_in;
   logic        ren;
   logic        wen;
   logic        rdy;
   logic        so;

   modport cpu(
      input  clk,
      input  b_rst,
      input  b_nmi,
      input  b_irq,
      input  data_in,
      input  rdy,
      output syn_clk,
      output addr_out,
      output data_out,
      output ren,
      output wen,
      output so
   );

   modport mem(
      input  clk,
      input  b_rst,
      input  addr_out,
      input  data_out,
      output data_in
   );

endinterface

`endif

