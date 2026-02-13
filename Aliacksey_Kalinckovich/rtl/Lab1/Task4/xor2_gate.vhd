library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor2_gate is
    Port ( IN1, IN2 : in std_logic;
           Y : out std_logic );
end xor2_gate;

architecture Behavioral of xor2_gate is
begin
    Y <= IN1 xor IN2;
end Behavioral;