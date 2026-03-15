library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TASK5 is
  port(
    led_o : out std_logic_vector(1 downto 0)
  );
end entity;

architecture structural of TASK5 is
  component BISTABLE_NO_CONTROL
    port(
      Q  : out std_logic;
      nQ : out std_logic
    );
  end component;
begin
  DUT : BISTABLE_NO_CONTROL port map(
    Q => led_o(0),
    nQ => led_o(1)
  );
end architecture;