library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COMPN is
    generic(n: integer range 1 to 64);
    port(
        a: in std_logic_vector(n - 1 downto 0);
        b: in std_logic_vector(n - 1 downto 0);
        gr_o, ls_o, eq_o: out std_logic
    );
end COMPN;

architecture Structural of COMPN is
component COMP1 is
    port(
        x, y, gr_i, eq_i, ls_i: in std_logic;
        gr_o, eq_o, ls_o: out std_logic
    );
end component COMP1;
signal gr, ls, eq: std_logic_vector(n - 1 downto 0);
begin
    u0: COMP1 port map(x => a(n - 1), y => b(n - 1), gr_i => '0', eq_i => '1', ls_i => '0',
                       gr_o => gr(n - 1), eq_o => eq(n - 1), ls_o => ls(n - 1));
    u1: for i in n - 2 downto 0 generate
        u2: COMP1 port map(x => a(i), y => b(i), gr_i => gr(i), eq_i => eq(i), ls_i => '0',
                           gr_o => gr(i - 1), eq_o => eq(i - 1), ls_o => ls(i - 1));
    end generate;
    gr_o <= gr(0);
    eq_o <= eq(0);
    ls_o <= ls(0);
end Structural;