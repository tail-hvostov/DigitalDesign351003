library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BISTABLE_C_OLD is
    port (
        S   : in    std_logic;
        R   : in    std_logic;
        nQ  : out   std_logic;
        Q   : out   std_logic
    );
end entity BISTABLE_C_OLD;

architecture RTL of BISTABLE_C_OLD is
    signal s0, s1   :   std_logic;
begin
    s0 <= S nor s1;
    s1 <= R nor s0;
    
    nQ <= s0;
    Q <= s1;
end RTL;