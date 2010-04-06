

`ifndef MEM_TOP
`define MEM_TOP

`include "mem_bfm.sv"

module mem_top(
   input  logic  clk,
   input  logic  rst,
   input  logic  wen,
   input  logic  ren,
   output logic  rdy,
   input  t_addr addr_in,
   input  t_data data_in,
   output t_data data_out
);

   mem_bfm mem_bfm;
   initial begin
      mem_bfm = new();
      mem_bfm.clear();
   end

   /*
   initial forever begin
      @(posedge clk);
      if (wen) begin
         mem_bfm.write(addr, data);
      end
   end

   initial forever begin
      if (~wen) begin
         data = mem_read(addr);
      end
   end
   */
endmodule

`endif

