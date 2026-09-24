library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rs_latch is
    port (
        R   : in    std_logic;
        S   : in    std_logic;
        Q   : out   std_logic;
        nQ  : out   std_logic
    );
end rs_latch;

architecture Structural of rs_latch is
    signal s0, s1   :   std_logic;
    
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
    NAND2_0: LUT_NAND2 port map (
        X1 => s1,
        X2 => S,
        Y => s0
    );
    
    NAND2_1: LUT_NAND2 port map (
        X1 => s0,
        X2 => R,
        Y => s1
    );
    
    nQ <= s0;
    Q <= s1;
end Structural;