library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity not_gate is
    Port ( X : in std_logic;
           Y : out std_logic );
end not_gate;

architecture Behavioral of not_gate is
begin
    Y <= not X;
end Behavioral;