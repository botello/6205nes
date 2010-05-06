library verilog;
use verilog.vl_types.all;
entity dp_group0 is
    generic(
        DBW             : integer := 8
    );
    port(
        ir              : in     vl_logic_vector;
        a_reg           : in     vl_logic_vector;
        x_reg           : in     vl_logic_vector;
        y_reg           : in     vl_logic_vector;
        d               : in     vl_logic_vector;
        ni              : in     vl_logic;
        vi              : in     vl_logic;
        zi              : in     vl_logic;
        ci              : in     vl_logic;
        n               : out    vl_logic;
        v               : out    vl_logic;
        z               : out    vl_logic;
        c               : out    vl_logic
    );
end dp_group0;
