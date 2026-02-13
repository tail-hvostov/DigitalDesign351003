library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or3_gate is
    Port ( IN1, IN2, IN3 : in std_logic;
           Y : out std_logic );
end or3_gate;

architecture Behavioral of or3_gate is
begin
    Y <= IN1 or IN2 or IN3;
end Behavioral;