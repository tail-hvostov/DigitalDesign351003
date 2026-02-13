library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xnor2_gate is
    Port ( IN1, IN2 : in std_logic;
           Y : out std_logic );
end xnor2_gate;

architecture Behavioral of xnor2_gate is
begin
    Y <= IN1 xnor IN2;
end Behavioral;