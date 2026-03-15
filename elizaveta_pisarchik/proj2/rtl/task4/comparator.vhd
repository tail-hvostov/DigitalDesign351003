library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CMP1 is
  port(
    a, b, g_in, l_in, e_in : in std_logic;
    g_out, l_out, e_out : out std_logic
  );
end entity;

architecture structural of CMP1 is
  component AND2
    port(a,b : in std_logic; f : out std_logic);
  end component;

  component OR2
    port(a, b : in std_logic; f : out std_logic);
  end component;

  component NXOR2
    port(a, b : in std_logic; f : out std_logic);
  end component;

  component INV
    port(a : in std_logic; f : out std_logic);
  end component;

  signal na, nb, a_b_xor : std_logic;
  signal g_i, l_i, e_i : std_logic;
  signal t1,t2 : std_logic;
begin

-- текущий результат
  INV_A : INV port map(a, na);
  INV_B : INV port map(b, nb);
  AND_G : AND2 port map(a, nb, g_i);
  AND_L : AND2 port map(na, b, l_i);
  NXOR_E : NXOR2 port map(a, b, e_i);
  
--получаем итоговый результат на основе текущего и предыдущего
  AND_1 : AND2 port map(e_i, g_in, t1);
  OR_1  : OR2  port map(g_i, t1, g_out);
  AND_2 : AND2 port map(e_i, l_in, t2);
  OR_2  : OR2  port map(l_i, t2, l_out);
  AND_3 : AND2 port map(e_i, e_in, e_out);
end architecture;