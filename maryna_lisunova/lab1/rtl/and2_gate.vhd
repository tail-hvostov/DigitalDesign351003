library ieee;
use ieee.std_logic_1164.all;

entity and2_gate is
     port(
     x1, x2: in std_logic;
     y: out std_logic
     );
end and2_gate;

architecture Behavioral of and2_gate is
begin
    y <= x1 and x2;
end Behavioral;