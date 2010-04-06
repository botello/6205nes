
`ifndef CPU_INTF
`define CPU_INTF

interface cpu_intf();

   logic        clk;
   logic        syn_clk;
   logic        rst;
   logic        nmi;
   logic        irq;

   logic [15:0] addr_out;
   logic [ 7:0] data_out;
   logic [ 7:0] data_in;
   logic        ren;
   logic        wen;
   logic        rdy;
   logic        so;

endinterface

`endif

