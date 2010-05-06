library verilog;
use verilog.vl_types.all;
entity ram32Kx8 is
    port(
        clk             : in     vl_logic;
        ce              : in     vl_logic;
        oe              : in     vl_logic;
        we              : in     vl_logic;
        addr            : in     vl_logic_vector(14 downto 0);
        d               : out    vl_logic_vector(7 downto 0)
    );
end ram32Kx8;
