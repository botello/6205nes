library verilog;
use verilog.vl_types.all;
entity dp_group1 is
    generic(
        DBW             : integer := 8
    );
    port(
        ir              : in     vl_logic_vector(7 downto 0);
        dec             : in     vl_logic;
        ni              : in     vl_logic;
        vi              : in     vl_logic;
        zi              : in     vl_logic;
        ci              : in     vl_logic;
        a_reg           : in     vl_logic_vector;
        d               : in     vl_logic_vector;
        o               : out    vl_logic_vector;
        n               : out    vl_logic;
        v               : out    vl_logic;
        z               : out    vl_logic;
        c               : out    vl_logic
    );
end dp_group1;
