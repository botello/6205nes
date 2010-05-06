library verilog;
use verilog.vl_types.all;
entity vic_text is
    generic(
        ABW             : integer := 15;
        DBW             : integer := 31;
        phTotal         : integer := 799;
        phSyncOn        : integer := 658;
        phSyncOff       : integer := 754;
        phBlankOn       : integer := 639;
        phBlankOff      : integer := 799;
        pvTotal         : integer := 524;
        pvSyncOn        : integer := 493;
        pvSyncOff       : integer := 494;
        pvBlankOn       : integer := 479;
        pvBlankOff      : integer := 524
    );
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        ce25            : in     vl_logic;
        cs              : in     vl_logic;
        rw              : in     vl_logic;
        rs              : in     vl_logic_vector(8 downto 0);
        d               : inout  vl_logic_vector(7 downto 0);
        cdin            : in     vl_logic_vector(7 downto 0);
        scrin           : in     vl_logic_vector(7 downto 0);
        ce50            : in     vl_logic;
        va              : out    vl_logic_vector;
        cra             : out    vl_logic_vector(8 downto 0);
        irq             : out    vl_logic;
        hSync           : out    vl_logic;
        vSync           : out    vl_logic;
        vdo             : out    vl_logic_vector(5 downto 0)
    );
end vic_text;
