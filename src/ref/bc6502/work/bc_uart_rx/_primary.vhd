library verilog;
use verilog.vl_types.all;
entity bc_uart_rx is
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        baud16x_ce      : in     vl_logic;
        rd              : in     vl_logic;
        clear           : in     vl_logic;
        do              : out    vl_logic_vector(7 downto 0);
        sin             : in     vl_logic;
        data_present    : out    vl_logic;
        full            : out    vl_logic;
        frame_err       : out    vl_logic;
        over_run        : out    vl_logic
    );
end bc_uart_rx;
