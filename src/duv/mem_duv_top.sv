

`ifndef MEM_DUV_TOP_SV
`define MEM_DUV_TOP_SV

`include "mem_duv_bfm.sv"

module mem_duv_top(cpu_duv_if.mem intf);

   mem_duv_bfm mem_bfm;
   initial begin
      mem_bfm = new();
      mem_bfm.clear();
   end

   /*
   initial forever begin
      @(posedge intf.clk);
      if (intf.wen) begin
         mem_bfm.write(intf.addr_out, intf.data_out);
      end
   end

   initial forever begin
      if (~intf.wen) begin
         intf.data_in = mem_read(intf.addr_out);
      end
   end
   */
endmodule

`endif

