library verilog;
use verilog.vl_types.all;
entity dp_group2 is
    generic(
        DBW             : integer := 8
    );
    port(
        ir              : in     vl_logic_vector(7 downto 0);
        ldx             : in     vl_logic;
        stxx            : in     vl_logic;
        d               : in     vl_logic_vector;
        ci              : in     vl_logic;
        ni              : in     vl_logic;
        zi              : in     vl_logic;
        c               : out    vl_logic;
        n               : out    vl_logic;
        z               : out    vl_logic;
        o               : out    vl_logic_vector
    );
end dp_group2;
