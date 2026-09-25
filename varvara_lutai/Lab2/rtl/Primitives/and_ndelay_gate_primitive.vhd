library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity AND2_ndelay is
generic (
T : time := 50ns
);
port(
A:  in std_logic;
B:  in std_logic;
C:  out std_logic
);
end AND2_ndelay;
architecture Behavioral of AND2_ndelay is
begin
C <=reject 25 ns inertial A and B after T;
end Behavioral;
