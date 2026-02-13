library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and3_gate is
    Port ( IN1, IN2, IN3 : in std_logic;
           Y : out std_logic );
end and3_gate;

architecture Behavioral of and3_gate is
begin
    Y <= IN1 and IN2 and IN3;
end Behavioral;