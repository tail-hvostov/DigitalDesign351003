library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR2_ndelay is
generic (
T : time := 30ns
);
port(
A:  in std_logic;
B:  in std_logic;
C:  out std_logic
);
end OR2_ndelay;
architecture Behavioral of OR2_ndelay is
begin
C <= reject 15 ns inertial A or B after T;
end Behavioral;
