library verilog;
use verilog.vl_types.all;
entity sub is
    generic(
        dec_support     : integer := 1
    );
    port(
        dec             : in     vl_logic;
        ci              : in     vl_logic;
        a               : in     vl_logic_vector(7 downto 0);
        b               : in     vl_logic_vector(7 downto 0);
        o               : out    vl_logic_vector(7 downto 0);
        c               : out    vl_logic
    );
end sub;
