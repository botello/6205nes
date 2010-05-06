library verilog;
use verilog.vl_types.all;
entity ram32x6s is
    port(
        clk             : in     vl_logic;
        wr              : in     vl_logic;
        a               : in     vl_logic_vector(4 downto 0);
        di              : in     vl_logic_vector(5 downto 0);
        do              : out    vl_logic_vector(5 downto 0)
    );
end ram32x6s;
