library verilog;
use verilog.vl_types.all;
entity rom8Kx8 is
    port(
        ce              : in     vl_logic;
        oe              : in     vl_logic;
        addr            : in     vl_logic_vector(12 downto 0);
        d               : out    vl_logic_vector(7 downto 0)
    );
end rom8Kx8;
