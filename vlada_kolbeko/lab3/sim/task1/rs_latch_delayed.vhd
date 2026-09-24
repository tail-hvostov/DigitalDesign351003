library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RS_Latch_D is
    generic (
        DELAY_IN    : time  := 5 ns;
        DELAY_OUT   : time := 10 ns
    );
    port (
        R   : in    std_logic;
        S   : in    std_logic;
        Q   : out   std_logic;
        nQ  : out   std_logic
    );
end RS_Latch_D;

architecture Structural of RS_Latch_D is
    constant SPIKE  :   time := 1 ns;
    
    signal s0, s1       :   std_logic;
    signal s0_d, s1_d   :   std_logic;
    
    component LUT_NAND2 is
        port (
            X1, X2  : in    std_logic;
            Y       : out   std_logic
        );
    end component;
    
    attribute DONT_TOUCH                :   string;
    attribute ALLOW_COMBINATORIAL_LOOPS :   string;
    
    attribute DONT_TOUCH of s1                  : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s1   : signal is "TRUE";
begin
    s0_d <= reject SPIKE inertial s0 after DELAY_IN;
    s1_d <= reject SPIKE inertial s1 after DELAY_IN;

    NAND2_0: LUT_NAND2 port map (
        X1 => s1_d,
        X2 => S,
        Y => s0
    );
    
    NAND2_1: LUT_NAND2 port map (
        X1 => s0_d,
        X2 => R,
        Y => s1
    );
    
    nQ <= transport s0 after DELAY_OUT;
    Q <= transport s1 after DELAY_OUT;
end Structural;