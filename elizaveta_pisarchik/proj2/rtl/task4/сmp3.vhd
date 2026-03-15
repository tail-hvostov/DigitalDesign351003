library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CMP3 is
  port(
    a, b : in  std_logic_vector(2 downto 0);
    g, l, e : out std_logic
  );
end entity;

architecture structural of CMP3 is
  component CMP1
    port(
      a, b, g_in, l_in, e_in : in std_logic;
      g_out, l_out, e_out : out std_logic
    );
  end component;

  signal g1, g2 : std_logic;
  signal l1, l2 : std_logic;
  signal e1, e2 : std_logic;
begin
  C2 : CMP1 port map(
    a(2), b(2),
    '0','0','1',
    g2, l2, e2
  );

  C1 : CMP1 port map(
    a(1), b(1),
    g2, l2, e2,
    g1, l1, e1
  );

  C0 : CMP1 port map(
    a(0), b(0),
    g1, l1, e1,
    g, l, e
  );

end architecture;