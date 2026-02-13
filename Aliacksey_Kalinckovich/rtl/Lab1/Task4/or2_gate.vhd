library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or2_gate is
    Port ( IN1, IN2 : in std_logic;
           Y : out std_logic );
end or2_gate;

architecture Behavioral of or2_gate is
begin
    Y <= IN1 or IN2;
end Behavioral;