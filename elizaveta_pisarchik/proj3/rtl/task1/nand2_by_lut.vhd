library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity NAND2 is
  port(
    A, B : in  std_logic;
    F : out std_logic
  );
end entity;

architecture rtl of NAND2 is
begin
  NAND2_LUT : LUT2
    generic map(
      INIT => "0111"
    )
    port map (
      I0 => A,
      I1 => B,
      O => F
    );
end rtl;