library ieee;
use ieee.std_logic_1164.all;

entity and3_gate is
     port(
     x1, x2, x3: in std_logic;
     y: out std_logic
     );
end and3_gate;

architecture Behavioral of and3_gate is
begin
    y <= x1 and x2 and x3;
end Behavioral;