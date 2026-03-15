library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WIRE_DELAY is
  generic(
    T_DELAY : time := 1 ns
  );
  port(
    a : in std_logic;
    f : out std_logic
  );
end entity;

architecture rtl of WIRE_DELAY is
begin
  f <= a after T_DELAY;
end architecture;