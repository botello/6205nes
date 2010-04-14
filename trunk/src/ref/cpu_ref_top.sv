

`ifndef CPU_REF_TOP_SV
`define CPU_REF_TOP_SV

module cpu_ref_top(cpu_ref_if.cpu intf);

   `include "reg_pc.v"
   `include "reg_sp.v"
   `include "regbank_axy.v"
   `include "r6502_tc.v"
   `include "fsm_execution_unit.v"
   `include "fsm_nmi.v"
   `include "core.v"

   Core refmodel(
      .clk_clk_i   (intf.clk),
      .d_i         (intf.data_in),
      .irq_n_i     (intf.irq),
      .nmi_n_i     (intf.nmi),
      .rdy_i       (intf.rdy),
      .rst_rst_n_i (intf.rst),
      .so_n_i      (intf.so),
      .a_o         (intf.addr_out),
      .d_o         (intf.data_out),
      .rd_o        (intf.ren),
      .sync_o      (intf.syn_clk),
      .wr_o        (intf.wen)
   );

endmodule

`endif

