library verilog;
use verilog.vl_types.all;
entity bc6502 is
    generic(
        ABW             : integer := 16;
        DBW             : integer := 8
    );
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        nmi             : in     vl_logic;
        irq             : in     vl_logic;
        rdy             : in     vl_logic;
        so              : in     vl_logic;
        di              : in     vl_logic_vector;
        do              : out    vl_logic_vector;
        rw              : out    vl_logic;
        ma              : out    vl_logic_vector;
        rw_nxt          : out    vl_logic;
        ma_nxt          : out    vl_logic_vector;
        sync            : out    vl_logic;
        state           : out    vl_logic_vector(31 downto 0);
        flags           : out    vl_logic_vector(4 downto 0)
    );
end bc6502;
