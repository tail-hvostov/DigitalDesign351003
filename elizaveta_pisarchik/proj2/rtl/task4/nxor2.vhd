library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NXOR2 is
  port(
    a, b : in  std_logic;
    f : out std_logic
  );
end entity;

architecture structural of NXOR2 is
begin
  f <= not (a xor b);
end architecture;