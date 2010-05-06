library verilog;
use verilog.vl_types.all;
entity nyb_sub is
    port(
        dec             : in     vl_logic;
        ci              : in     vl_logic;
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        o               : out    vl_logic_vector(3 downto 0);
        c               : out    vl_logic
    );
end nyb_sub;
