
`ifndef TB_TOP
`define TB_TOP

module tb_top();

   import tb_pkg::*;
   `include "tb_env.sv"

   cpu_intf cpu_intf();

   mem_top mem_top(
      .clk      (cpu_intf.clk),
      .rst      (cpu_intf.rst),
      .wen      (cpu_intf.wen),
      .ren      (cpu_intf.ren),
      .rdy      (cpu_intf.rdy),
      .addr_in  (cpu_intf.addr_out),
      .data_in  (cpu_intf.data_out),
      .data_out (cpu_intf.data_in)
   );

   cpu_top cpu_top(
      .clk      (cpu_intf.clk),
      .syn_clk  (cpu_intf.syn_clk),
      .rst      (cpu_intf.rst),
      .nmi      (cpu_intf.nmi),
      .irq      (cpu_intf.irq),
      .addr_out (cpu_intf.addr_out),
      .data_out (cpu_intf.data_out),
      .data_in  (cpu_intf.data_in),
      .ren      (cpu_intf.ren),
      .wen      (cpu_intf.wen),
      .rdy      (cpu_intf.rdy),
      .so       (cpu_intf.so)
   );

   tb_env env;
   initial begin
      env = new();
      env.assign_vi(cpu_intf);
      env.run();
   end

   initial begin
      cpu_intf.nmi = 1'b0;
      cpu_intf.irq = 1'b0;
      cpu_intf.rst = 1'b1;
      #50;
      cpu_intf.rst = 1'b0;
   end

   initial begin
      cpu_intf.clk = 1'b0;
      forever #5 cpu_intf.clk = ~cpu_intf.clk;
   end

endmodule

`endif

