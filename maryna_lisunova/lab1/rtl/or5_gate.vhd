library ieee;
use ieee.std_logic_1164.all;

entity or5_gate is
     port(
     x1, x2, x3, x4, x5: in std_logic;
     y: out std_logic
     );
end or5_gate;

architecture Behavioral of or5_gate is
begin
    y <= x1 or x2 or x3 or x4 or x5;
end Behavioral;