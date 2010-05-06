library verilog;
use verilog.vl_types.all;
entity timer is
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        ce              : in     vl_logic;
        cs              : in     vl_logic;
        rw              : in     vl_logic;
        a               : in     vl_logic_vector(3 downto 0);
        di              : in     vl_logic_vector(7 downto 0);
        do              : out    vl_logic_vector(7 downto 0);
        irq             : out    vl_logic
    );
end timer;
