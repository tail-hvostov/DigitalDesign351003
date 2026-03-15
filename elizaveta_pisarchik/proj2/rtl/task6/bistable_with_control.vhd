library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BISTABLE_WITH_CONTROL is
   port(
       S, R : in std_logic;
       Q, nQ : out std_logic
   );
end entity;

architecture structural of BISTABLE_WITH_CONTROL is
  component NOR_LUT
    port(
      a, b : in  std_logic;
      f : out std_logic
    );
  end component;
  signal s1, s2 : std_logic;
begin
  NOR1 : NOR_LUT port map(
    a => s1,
    b => S,
    f => s2
  );
  NOR2 : NOR_LUT port map(
    a => s2,
    b => R,
    f => s1
  );
  
  Q <= s1;
  nQ <= s2;
end architecture;