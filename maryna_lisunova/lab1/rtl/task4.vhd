library ieee;
use ieee.std_logic_1164.all;

entity task4 is
    port(
    led_o: out std_logic_vector(15 downto 0);
    sw_i: in std_logic_vector(3 downto 0)
    -- sw3 - A, sw2 - B, sw1 - C, sw0 - D
    );
end task4;

architecture rtl of task4 is

component not_gate
    Port ( x: in std_logic; y: out std_logic );
end component;

component and2_gate
    Port ( x1, x2: in std_logic; y: out std_logic );
end component;

component and3_gate
    Port ( x1, x2, x3: in std_logic; y: out std_logic );
end component;

component or5_gate
    Port ( x1, x2, x3, x4, x5: in std_logic; y: out std_logic );
end component;

signal notA, notB, notC, notD: std_logic;
signal and2_o, and3_nAnCD_o, and3_nAnBnC_o, and3_ABC_o, and3_AnBnC_o, or5_o: std_logic;
begin
-- not A
    U1: not_gate port map (
    x => sw_i(3), 
    y => notA
    ); 
-- not B
    U2: not_gate port map (
    x => sw_i(2), 
    y => notB
    ); 
-- not C
    U3: not_gate port map (
    x => sw_i(1),
    y => notC
    );
 -- not D
    U4: not_gate port map (
    x => sw_i(0),
    y => notD
    );
-- and2 A*notD
    U5: and2_gate port map (
    x1 => sw_i(3),
    x2 => notD,
    y => and2_o
    ); 
-- and3 notA*notC*D
    U6: and3_gate port map (
    x1 => notA,
    x2 => notC,
    x3 => sw_i(0),
    y => and3_nAnCD_o
    );
-- and3 notA*notB*notC
    U7: and3_gate port map (
    x1 => notA,
    x2 => notB,
    x3 => notC,
    y => and3_nAnBnC_o
    );
-- and3 A*B*C
    U8: and3_gate port map (
    x1 => sw_i(3),
    x2 => sw_i(2),
    x3 => sw_i(1),
    y => and3_ABC_o
    );
-- and3 A*notB*notC
    U9: and3_gate port map (
    x1 => sw_i(3),
    x2 => notB,
    x3 => notC,
    y => and3_AnBnC_o
    );
-- or5 - result
    U10: or5_gate port map (
    x1 => and2_o,
    x2 => and3_nAnCD_o,
    x3 => and3_nAnBnC_o,
    x4 => and3_ABC_o,
    x5 => and3_AnBnC_o,
    y => or5_o 
    );
    
    led_o <= (others => or5_o);
end rtl;