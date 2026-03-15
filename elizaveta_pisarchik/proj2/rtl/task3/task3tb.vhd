library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TASK3tb is
end entity;

architecture sim of TASK3tb is
  component TASK3 is
    port(
      sw_i  : in  std_logic_vector(3 downto 0);
      led_o : out std_logic_vector(1 downto 0)
    );
  end component;

  signal sw_i  : std_logic_vector(3 downto 0) := (others => '0');
  signal led_o : std_logic_vector(1 downto 0);

begin
  DUT : TASK3 port map(
    sw_i  => sw_i,
    led_o => led_o
  );

  TESTING : process
    variable exp_led : std_logic_vector(1 downto 0);
  begin
    for i in 0 to 15 loop
      sw_i <= std_logic_vector(to_unsigned(i, 4));
      wait for 10 ns;

      exp_led(0) := sw_i(1) or sw_i(2);
      exp_led(1) := sw_i(2) or sw_i(3);

      assert (led_o = exp_led)
        report "FAIL: sw_i=" & integer'image(i) &
               " expected led_o=" & std_logic'image(exp_led(1)) & std_logic'image(exp_led(0)) &
               " got led_o=" & std_logic'image(led_o(1)) & std_logic'image(led_o(0))
        severity error;
    end loop;

    report "ALL TESTS PASSED." severity note;
  end process;
end architecture;