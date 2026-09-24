library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BISTABLE_U is
    port (
        nQ   : out   std_logic;
        Q  : out     std_logic
    );
end BISTABLE_U;

architecture Structural of BISTABLE_U is
    signal s0, s1   :   std_logic;
    
    component LUT_INV is
        port (
            X   : in    std_logic;
            Y   : out   std_logic
        );
     end component;
begin
    INV_0: LUT_INV port map (
        X => s1,
        Y => s0
    );
    
    INV_1: LUT_INV port map (
        X => s0,
        Y => s1
    );
    
    nQ <= s0;
    Q <= s1;
end Structural;