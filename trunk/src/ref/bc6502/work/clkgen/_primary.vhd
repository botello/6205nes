library verilog;
use verilog.vl_types.all;
entity clkgen is
    port(
        reset           : in     vl_logic;
        clki            : in     vl_logic;
        clk             : out    vl_logic;
        wse             : out    vl_logic
    );
end clkgen;
