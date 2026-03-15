library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TASK1 is
  port(
    sw_i  : in  std_logic_vector(3 downto 0);
    led_o : out std_logic_vector(1 downto 0)
  );
end entity;

architecture structural of TASK1 is
  component OR2 is
    port(a, b : in  std_logic;
         f    : out std_logic);
  end component;

begin
  OR2_0 : OR2 port map(
    a => sw_i(1),
    b => sw_i(2),
    f => led_o(0)
  );

  OR2_1 : OR2 port map(
    a => sw_i(2),
    b => sw_i(3),
    f => led_o(1)
  );
end architecture;