library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and2_gate is
    Port ( IN1, IN2 : in std_logic;
           Y : out std_logic );
end and2_gate;

architecture Behavioral of and2_gate is
begin
    Y <= IN1 and IN2;
end Behavioral;