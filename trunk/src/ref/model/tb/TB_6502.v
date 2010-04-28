
`ifndef TB_6502_V
`define TB_6502_V

module TB_6502();

   reg         clk_clk_i;   //clk
   reg  [ 7:0] d_i;         //dato
   reg         irq_n_i;     //0
   reg         nmi_n_i;     //0
   reg         rdy_i;       // ??
   reg         rst_rst_n_i; //0
   reg         so_n_i;      //
   wire [15:0] a_o;
   wire [ 7:0] d_o;
   wire        rd_o;
   wire        sync_o;
   wire        wr_o;

   initial begin
      irq_n_i     = 0;
      nmi_n_i     = 1;
      rst_rst_n_i = 1;
      rdy_i       = 1;
      so_n_i      = 0;
      //#650 d_i = 8'hA9;
      #102;
      d_i         = 8'hAA;
   end

   initial begin : clk_gen_proc
     clk_clk_i = 0;
     forever #50 clk_clk_i = ~clk_clk_i;
   end

   R6502_TC R6502_TC (
      .clk_clk_i   ( clk_clk_i   ),
      .d_i         ( d_i         ),
      .irq_n_i     ( irq_n_i     ),
      .nmi_n_i     ( nmi_n_i     ),
      .rdy_i       ( rdy_i       ),
      .rst_rst_n_i ( rst_rst_n_i ),
      .so_n_i      ( so_n_i      ),
      .a_o         ( a_o         ),
      .d_o         ( d_o         ),
      .rd_o        ( rd_o        ),
      .sync_o      ( sync_o      ),
      .wr_o        ( wr_o        )
   );

endmodule

`endif

