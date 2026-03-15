library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TASK3 is
  port(
    sw_i  : in  std_logic_vector(3 downto 0);
    led_o : out std_logic_vector(1 downto 0)
  );
end entity;

architecture structural of TASK3 is
  component OR2
    generic(
      USE_DELAY : boolean := true
    );
    port(a, b : in std_logic;
         f    : out std_logic);
  end component;

  component WIRE_DELAY
    port(a : in std_logic;
         f : out std_logic);
  end component;

  signal g1, g2, g3 : std_logic;
begin
  W1 : WIRE_DELAY port map(sw_i(1), g1);
  W2 : WIRE_DELAY port map(sw_i(2), g2);
  W3 : WIRE_DELAY port map(sw_i(3), g3);

  OR2_0 : OR2 port map(
    a => g1,
    b => g2,
    f => led_o(0)
  );

  OR2_1 : OR2 port map(
    a => g2,
    b => g3,
    f => led_o(1)
  );

end architecture;