library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
    port(
        i0, i1, s : in  std_logic;
        y         : out std_logic
    );
end mux2;

architecture behavioral of mux2 is
begin
    -- y = not(s)*i0 + s*i1
    y <= (not s and i0) or (s and i1);
end behavioral ;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task1_7 is
    Port(
        G3, G2, G1, G0  : in  std_logic;
        L3, L2, L1, L0 : out std_logic
    );
end task1_7;

architecture structural of task1_7 is
    component mux2 is
    -- mux: y= ¬s·i0 + s·i1
        port(
            i0, i1, s : in  std_logic;
            y  : out std_logic
        );
    end component;

    signal nG3, nG2, nG1, nG0 : std_logic;
    signal T1, T2 : std_logic; --  L0
    signal T3, T4 : std_logic; --  L1
    signal T5, T6 : std_logic; --  L2

begin
    nG3 <= not G3;
    nG2 <= not G2;
    nG1 <= not G1;
    nG0 <= not G0;
    
    -- L3 = G3·G2  -> mux(G3, 0, G2)
    
    M_Y3 : mux2
        port map(
            i0 => '0',
            i1 => G2,
            s  => G3,
            y  => L3
        );

    -- L0 = ¬G3·G2 + ¬G1·G0
    -- T1 = ¬G3·G2 = mux(G3, G2, 0)
    -- T2 = ¬G1·G0 = mux(G1, G0, 0)
    -- L0 = mux(T1, T2, 1)

    M_T1 : mux2
        port map(
            i0 => G2,
            i1 => '0',
            s  => G3,
            y  => T1
        );

    M_T2 : mux2
        port map(
            i0 => G0,
            i1 => '0',
            s  => G1,
            y  => T2
        );

    M_Y0 : mux2
        port map(
            i0 => T2,
            i1 => '1',
            s  => T1,
            y  => L0
        );

    -- L1 = G3·¬G2 + G1·¬G0
    -- T3 = G3·¬G2 = mux(G3, 0, ¬G2)
    -- T4 = G1·¬G0 = mux(G1, 0, ¬G0)
    -- L1 = mux(T3, T4, 1)

    M_T3 : mux2
        port map(
            i0 => '0',
            i1 => nG2,
            s  => G3,
            y  => T3
        );

    M_T4 : mux2
        port map(
            i0 => '0',
            i1 => nG0,
            s  => G1,
            y  => T4
        );

    M_Y1 : mux2
        port map(
            i0 => T4,
            i1 => '1',
            s  => T3,
            y  => L1
        );

    -- L2 = ¬G3·G2 + G3·¬G2 + G1·G0
    -- T5 = mux(G3, G2, ¬G2)
    -- T6 = G1·G0 = mux(G1, 0, G0)
    -- L2 = mux(T5, T6, 1)

    M_T5 : mux2
        port map(
            i0 => G2,
            i1 => nG2,
            s  => G3,
            y  => T5
        );

    M_T6 : mux2
        port map(
            i0 => '0',
            i1 => G0,
            s  => G1,
            y  => T6
        );

    M_Y2 : mux2
        port map(
            i0 => T6,
            i1 => '1',
            s  => T5,
            y  => L2
        );

end structural;
