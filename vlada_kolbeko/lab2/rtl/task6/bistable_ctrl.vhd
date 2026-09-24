library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BISTABLE_C is
    port (
        S   : in    std_logic;
        R   : in    std_logic;
        nQ  : out   std_logic;
        Q   : out   std_logic
    );
end entity BISTABLE_C;

architecture RTL of BISTABLE_C is
    signal s0, s1   :   std_logic;
    signal ns0, ns1 :   std_logic;
    
    component OR2 is
        port (
            X1, X2  : in    std_logic;
            Y       : out   std_logic
        );
    end component;
    
    component LUT_INV is
        port (
            X   : in    std_logic;
            Y   : out   std_logic
        );
    end component;
begin
    OR2_0: OR2 port map (
        X1 => S,
        X2 => s1,
        Y => ns0
    );
    
    INV_0: LUT_INV port map (
        X => ns0,
        Y => s0
    );
    
    OR2_1: OR2 port map (
        X1 => R,
        X2 => s0,
        Y => ns1
    );
    
    INV_1: LUT_INV port map (
        X => ns1,
        Y => s1
    );
    
    nQ <= s0;
    Q <= s1;
end RTL;