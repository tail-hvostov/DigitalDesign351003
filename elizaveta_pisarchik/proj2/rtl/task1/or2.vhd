library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR2 is
  generic(
    T_DELAY : time := 2 ns;
    USE_DELAY : boolean := false
  );
  port(
    a, b : in  std_logic;
    f    : out std_logic
  );
end entity;

architecture structural of OR2 is
  signal tmp : std_logic;
begin

  tmp <= a or b;

  GEN_DELAY : if USE_DELAY generate
    f <= tmp after T_DELAY;
  end generate;

  GEN_NODELAY : if not USE_DELAY generate
    f <= tmp;
  end generate;

end architecture;