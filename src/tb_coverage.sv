

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

   covergroup cg_store @(posedge cpu_ref_intf.clk);
      cp_store: coverpoint cpu_ref_intf.wen {
         bins n_wen    = {1'b1};
         bins others   = default;
      }
      cp_sta_addr_mode: coverpoint opcode_t'(cpu_ref_intf.opcode) {
         bins sta_addr_mode[] = {STA_ZPAGE, STA_ZPAGEX, STA_INDX, STA_INDY, STA_ABS, STA_ABSX, STA_ABSY};
         bins others          = default;
      }
      //
      // TODO: add coverpoints for other store operations.
      //
      cross_store: cross cp_store, cp_sta_addr_mode;
   endgroup

   covergroup cg_load @(posedge cpu_ref_intf.clk);
      cp_load: coverpoint cpu_ref_intf.ren {
         bins n_ren    = {1'b1};
         bins others   = default;
      }
      cp_lda_addr_mode: coverpoint opcode_t'(cpu_ref_intf.opcode) {
         bins lda_addr_mode[] = {LDA_ZPAGE, LDA_ZPAGEX, LDA_INDX, LDA_INDY, LDA_ABS, LDA_ABSX, LDA_ABSY, LDA_IMM};
         bins others          = default;
      }
      //
      // TODO: add coverpoints for other load operations.
      //
      cross_load: cross cp_load, cp_lda_addr_mode;
   endgroup

   cg_load  cg_load_inst = new();
   cg_store cg_store_inst = new();

endmodule

`endif

