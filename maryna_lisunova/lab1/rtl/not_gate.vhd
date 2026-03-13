library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity not_gate is
  Port ( 
    x: in std_logic;
    y: out std_logic
  );
end not_gate;

architecture Behavioral of not_gate is
begin
    y <= not x;
end Behavioral;
