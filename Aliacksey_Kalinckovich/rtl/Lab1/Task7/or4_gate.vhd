library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or4_gate is
    Port ( IN1, IN2, IN3, IN4 : in std_logic;
           Y : out std_logic );
end or4_gate;

architecture Behavioral of or4_gate is
begin
    Y <= IN1 or IN2 or IN3 or IN4;
end Behavioral;