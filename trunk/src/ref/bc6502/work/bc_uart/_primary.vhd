library verilog;
use verilog.vl_types.all;
entity bc_uart is
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        ce              : in     vl_logic;
        cs              : in     vl_logic;
        rd              : in     vl_logic;
        wr              : in     vl_logic;
        a               : in     vl_logic_vector(2 downto 0);
        di              : in     vl_logic_vector(7 downto 0);
        do              : out    vl_logic_vector(7 downto 0);
        irq             : out    vl_logic;
        cts             : in     vl_logic;
        rts             : out    vl_logic;
        sin             : in     vl_logic;
        sout            : out    vl_logic
    );
end bc_uart;
