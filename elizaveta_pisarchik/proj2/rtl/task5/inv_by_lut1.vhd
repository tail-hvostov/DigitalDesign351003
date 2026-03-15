library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity INV_LUT is
  port(
    a : in  std_logic;
    f : out std_logic
  );
end entity;

architecture structural of INV_LUT is
begin
  LUT_INV : LUT1
    generic map(
      INIT => "01"
    )
    port map(
      I0 => a,
      O  => f
    );
end architecture;