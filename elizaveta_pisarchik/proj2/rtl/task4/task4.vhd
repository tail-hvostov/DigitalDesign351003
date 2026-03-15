library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TASK4tb is
end entity;

architecture sim of TASK4tb is
  component CMP3 is
    port(
      a,b : in std_logic_vector(2 downto 0);
      g,l,e : out std_logic
    );
  end component;
  
  signal a,b : std_logic_vector(2 downto 0) := (others => '0');
  signal g,l,e : std_logic;
begin
  DUT : CMP3 port map(
    a => a,
    b => b,
    g => g,
    l => l,
    e => e
  );

  TESTING : process
    variable exp_g, exp_l, exp_e : std_logic;
    variable ai, bi : integer;
  begin
    for ai in 0 to 7 loop
      for bi in 0 to 7 loop
        a <= std_logic_vector(to_unsigned(ai,3));
        b <= std_logic_vector(to_unsigned(bi,3));
        wait for 20 ns;

        if ai > bi then
          exp_g := '1';
          exp_l := '0';
          exp_e := '0';
        elsif ai < bi then
          exp_g := '0';
          exp_l := '1';
          exp_e := '0';
        else
          exp_g := '0';
          exp_l := '0';
          exp_e := '1';
        end if;

        assert (g = exp_g and l = exp_l and e = exp_e)
          report "FAIL: A=" & integer'image(ai) &
                 " B=" & integer'image(bi)
          severity error;
      end loop;
    end loop;
    report "ALL TESTS PASSED." severity note;
    wait;
  end process;
end architecture;