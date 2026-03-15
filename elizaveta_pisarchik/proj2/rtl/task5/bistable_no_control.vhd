library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BISTABLE_NO_CONTROL is
   port(
       Q, nQ : out std_logic
   );
end entity;

architecture structural of BISTABLE_NO_CONTROL is
  component INV_LUT
    port(
      a : in  std_logic;
      f : out std_logic
    );
  end component;
  signal s1, s2 : std_logic;
begin
  INV1 : INV_LUT port map(
    a => s1,
    f => s2
  );
  INV2 : INV_LUT port map(
    a => s2,
    f => s1
  );
  
  Q <= s1;
  nQ <= s2;
end architecture;