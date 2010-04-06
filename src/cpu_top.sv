
`ifndef CPU_TOP
`define CPU_TOP

module cpu_top(
   input  logic        clk,
   output logic        syn_clk,
   input  logic        rst,
   input  logic        nmi,
   input  logic        irq,
   input  logic [ 7:0] data_in,
   output logic [ 7:0] data_out,
   output logic [15:0] addr_out,
   output logic        ren,
   output logic        wen,
   input  logic        rdy,
   input  logic        so
);

   `include "reg_pc.v"
   `include "reg_sp.v"
   `include "regbank_axy.v"
   `include "r6502_tc.v"
   `include "fsm_execution_unit.v"
   `include "fsm_nmi.v"
   `include "core.v"

   Core refmodel(
      .clk_clk_i   (clk),
      .d_i         (data_in),
      .irq_n_i     (irq),
      .nmi_n_i     (nmi),
      .rdy_i       (rdy),
      .rst_rst_n_i (rst),
      .so_n_i      (),
      .a_o         (addr_out),
      .d_o         (data_out),
      .rd_o        (ren),
      .sync_o      (syn_clk),
      .wr_o        (wen)
   );

endmodule

`endif

