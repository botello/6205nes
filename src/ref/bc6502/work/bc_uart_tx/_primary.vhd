library verilog;
use verilog.vl_types.all;
entity bc_uart_tx is
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        baud16x_ce      : in     vl_logic;
        wr              : in     vl_logic;
        clear           : in     vl_logic;
        di              : in     vl_logic_vector(7 downto 0);
        sout            : out    vl_logic;
        full            : out    vl_logic;
        empty           : out    vl_logic
    );
end bc_uart_tx;
