library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity NOR_LUT is
  port(
    a, b : in  std_logic;
    f : out std_logic
  );
end entity;

architecture structural of NOR_LUT is
begin
  LUT_INV : LUT2
    generic map(
      INIT => "0001"
    )
    port map(
      I0 => a,
      I1 => b,
      O  => f
    );
end architecture;