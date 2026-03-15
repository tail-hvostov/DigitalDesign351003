library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INV is
  port(
    a : in  std_logic;
    f : out std_logic
  );
end entity;

architecture structural of INV is
begin
  f <= not a;
end architecture;