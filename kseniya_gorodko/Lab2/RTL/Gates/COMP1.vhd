library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COMP1 is
    port(
        x, y, gr_i, eq_i, ls_i: in std_logic;
        gr_o, eq_o, ls_o: out std_logic
    );
end COMP1;

architecture Structural of COMP1 is
component INV is
    port(
        a: in std_logic;
        z: out std_logic
    );
end component INV;
component AND2 is
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end component AND2;
component OR2 is
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end component OR2;
component NOR2 is
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end component NOR2;
-- > := gr * nls + eq * x * ny
-- < := ngr * ls + eq * nx * y
-- = := > nor <
signal Nx, Ny, Ngr_i, Nls_i, grNls, eqx, eqxNy, Ngrls, eqNx, eqNxy, gr_o_s, ls_o_s: std_logic;
begin
    u1: INV port map(gr_i, Ngr_i);
    u2: INV port map(ls_i, Nls_i);
    u3: INV port map(x, Nx);
    u4: INV port map(y, Ny);

    u5: AND2 port map(gr_i, Nls_i, grNls);
    u6: AND2 port map(eq_i, x, eqx);
    u7: AND2 port map(eqx, Ny, eqxNy);
    u8: OR2 port map(grNls, eqxNy, gr_o_s);
    gr_o <= gr_o_s;
    
    u9: AND2 port map(Ngr_i, ls_i, Ngrls);
    u10: AND2 port map(eq_i, Nx, eqNx);
    u11: AND2 port map(eqNx, y, eqNxy);
    u12: OR2 port map(Ngrls, eqNxy, ls_o_s);
    ls_o <= ls_o_s;
    
    u13: NOR2 port map(gr_o_s, ls_o_s, eq_o);
end Structural;
