

`ifndef CPU_IF_SV
`define CPU_IF_SV

interface cpu_if(cpu_duv_if duv_intf, cpu_ref_if ref_intf);

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

   always_comb begin
      duv_intf.clk = clk;
      duv_intf.rst = rst;
      duv_intf.nmi = nmi;
      duv_intf.irq = irq;
      syn_clk = duv_intf.syn_clk;

      ref_intf.clk = clk;
      ref_intf.rst = rst;
      ref_intf.nmi = nmi;
      ref_intf.irq = irq;
      syn_clk = ref_intf.syn_clk;
   end

   modport cpu_duv_if_mp(
      input  clk,
      input  rst,
      input  nmi,
      input  irq,
      input  data_in,
      input  rdy,
      output syn_clk,
      output addr_out,
      output data_out,
      output ren,
      output wen,
      output so
   );

   modport cpu_duv_mem_mp(
      input  clk,
      input  rst,
      input  addr_out,
      input  data_out,
      output data_in
   );

   modport cpu_ref_if_mp(
      input  clk,
      input  rst,
      input  nmi,
      input  irq,
      input  data_in,
      input  rdy,
      output syn_clk,
      output addr_out,
      output data_out,
      output ren,
      output wen,
      output so
   );

   modport cpu_ref_mem_mp(
      input  clk,
      input  rst,
      input  addr_out,
      input  data_out,
      output data_in
   );

endinterface

`endif

