library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND2 is
  port(
    a, b : in  std_logic;
    f : out std_logic
  );
end entity;

architecture structural of AND2 is
begin
  f <= a and b;
end architecture;