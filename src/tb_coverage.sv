

`ifndef TB_COVERAGE_V
`define TB_COVERAGE_V

`include "cpu_ref_top.sv"
`include "cpu_duv_top.sv"

module tb_coverage (
   tb_cpu_if cpu_duv_intf,
   tb_cpu_if cpu_ref_intf
);

   import mem_pkg::*;

   typedef enum logic [7:0] {
      LDA_IMM    = 'hA9,
      LDA_ZPAGE  = 'hA5,
      LDA_ZPAGEX = 'hB5,
      LDA_ABS    = 'hAD,
      LDA_ABSX   = 'hBD,
      LDA_ABSY   = 'hB9,
      LDA_INDX   = 'hA1,
      LDA_INDY   = 'hB1,
      STA_ZPAGE  = 'h85,
      STA_ZPAGEX = 'h95,
      STA_INDX   = 'h81,
      STA_INDY   = 'h91,
      STA_ABS    = 'h8D,
      STA_ABSX   = 'h9D,
      STA_ABSY   = 'h99
   } opcode_t;

   covergroup cg_sta @(posedge cpu_ref_intf.clk);
      cp_store: coverpoint cpu_ref_intf.wen {
         bins n_wen    = {1'b1};
         bins others[] = default;
      }
      cp_sta_addr_mode: coverpoint opcode_t'(cpu_ref_intf.opcode);
   endgroup

   covergroup cg_lda @(posedge cpu_ref_intf.clk);
      cp_load: coverpoint cpu_ref_intf.ren {
         bins n_ren    = {1'b1};
         bins others[] = default;
      }
   endgroup

   cg_sta cg_sta_inst = new();
   cg_lda cg_lda_inst = new();

endmodule

`endif

