library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TASK6tb is
end entity;

architecture sim of TASK6tb is
  component TASK6
    port(
      sw_i  : in  std_logic_vector(1 downto 0);
      led_o : out std_logic_vector(1 downto 0)
    );
  end component;

  signal sw_i  : std_logic_vector(1 downto 0);
  signal led_o : std_logic_vector(1 downto 0);
begin
  DUT: TASK6
    port map(
      sw_i  => sw_i,
      led_o => led_o
    );

  sim: process
  begin
    sw_i <= "01";
    wait for 5 ns;

    sw_i <= "00";
    wait for 5 ns;

    sw_i <= "11";
    wait for 5 ns;

    sw_i <= "00";
    wait for 5 ns;
    
    wait;
  end process;
end architecture;