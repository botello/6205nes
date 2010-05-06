library verilog;
use verilog.vl_types.all;
entity bc6502_SoC is
    port(
        xreset          : in     vl_logic;
        xclk            : in     vl_logic;
        xa              : out    vl_logic_vector(16 downto 0);
        xd              : inout  vl_logic_vector(7 downto 0);
        we              : out    vl_logic;
        oe              : out    vl_logic;
        ce              : out    vl_logic;
        cts             : in     vl_logic;
        rts             : out    vl_logic;
        sin             : in     vl_logic;
        sout            : out    vl_logic;
        kclk            : inout  vl_logic;
        kd              : inout  vl_logic;
        hSync           : out    vl_logic;
        vSync           : out    vl_logic;
        vdo             : out    vl_logic_vector(5 downto 0);
        led             : out    vl_logic
    );
end bc6502_SoC;
