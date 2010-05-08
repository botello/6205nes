

`ifndef TB_COVERAGE_V
`define TB_COVERAGE_V

`include "cpu_ref_top.sv"
`include "cpu_duv_top.sv"

module tb_coverage (
   tb_cpu_if cpu_duv_intf,
   tb_cpu_if cpu_ref_intf
);

   import mem_pkg::*;

   covergroup cg_sta @(posedge cpu_ref_intf.clk);
      cp_sta0: coverpoint cpu_ref_intf.wen {
         bins n_wen   = {1'b1};
         bins n_b_wen = {1'b0};
      }
   endgroup

   covergroup cg_lda @(posedge cpu_ref_intf.clk);
      cp_lda0: coverpoint cpu_ref_intf.ren;
   endgroup

   cg_sta cg_sta_inst = new();
   cg_lda cg_lda_inst = new();

endmodule

`endif

