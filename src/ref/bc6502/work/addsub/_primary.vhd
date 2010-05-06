library verilog;
use verilog.vl_types.all;
entity addsub is
    generic(
        DBW             : integer := 32
    );
    port(
        op              : in     vl_logic;
        ci              : in     vl_logic;
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        o               : out    vl_logic_vector;
        co              : out    vl_logic;
        v               : out    vl_logic
    );
end addsub;
