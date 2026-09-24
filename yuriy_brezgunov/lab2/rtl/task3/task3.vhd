library ieee;
use ieee.std_logic_1164.all;
-- G = 7421
-- L = Berger's code (Sum of 1)
-- c1 = (x3 xor x2)(x1 xor x0) + !x3!x2x1x0
-- c0 = (x3 xor x2) !x1!x0 + !x3!x2(x1 xor x0)
entity task3 is
    port (
        led : out std_logic_vector(15 downto 10);
        sw: in std_logic_vector(15 downto 12)
    );
end task3;

architecture rtl of task3 is
    constant T_INV:  time := 2 ns;
    constant T_AND:  time := 4 ns;  
    constant T_OR:   time := 4 ns; 
    constant T_XOR:  time := 6 ns; 
    constant T_WIRE: time := 1 ns;

    component wire 
        generic (T: time := T_WIRE);
        port (i : in std_logic; o : out std_logic);
    end component;
    component inv 
        generic (T: time := T_INV);
        port (i : in std_logic; o : out std_logic);
    end component;
    component and2 
        generic (T : time := T_AND);
        port (i0 : in std_logic; i1 : in std_logic; o : out std_logic);
    end component;
    component or2 
        generic (T : time := T_OR);
        port (i0 : in std_logic; i1 : in std_logic; o : out std_logic);
    end component;
    component xor2 
        generic (T : time := T_XOR);
        port (i0 : in std_logic; i1 : in std_logic; o : out std_logic);
    end component;

    signal x0, x1, x2, x3: std_logic;
    signal x0_w, x1_w, x2_w, x3_w: std_logic;

    signal not_x0, not_x1, not_x2, not_x3: std_logic;
    signal not_x0_w, not_x1_w, not_x2_w, not_x3_w: std_logic;

    signal x3_xor_x2, x1_xor_x0: std_logic;
    signal x3_xor_x2_w, x1_xor_x0_w: std_logic;

    signal c1_conj1, c1_conj2_p1, c1_conj2_p2, c1_conj2_p3, c1_res: std_logic;
    signal c1_conj1_w, c1_conj2_p1_w, c1_conj2_p2_w, c1_conj2_p3_w: std_logic;

    signal c0_conj1_p1, c0_conj1_p2, c0_conj2_p1, c0_conj2_p2, c0_res: std_logic;
    signal c0_conj1_p1_w, c0_conj1_p2_w, c0_conj2_p1_w, c0_conj2_p2_w: std_logic;

begin
    x0 <= sw(12);
    x1 <= sw(13);
    x2 <= sw(14);
    x3 <= sw(15);

    WIRE_X0: wire port map (i => x0, o => x0_w);
    WIRE_X1: wire port map (i => x1, o => x1_w);
    WIRE_X2: wire port map (i => x2, o => x2_w);
    WIRE_X3: wire port map (i => x3, o => x3_w);

    INV_X0: inv port map (i => x0_w, o => not_x0);
    INV_X1: inv port map (i => x1_w, o => not_x1);
    INV_X2: inv port map (i => x2_w, o => not_x2);
    INV_X3: inv port map (i => x3_w, o => not_x3);

    WIRE_NOT_X0: wire port map (i => not_x0, o => not_x0_w);
    WIRE_NOT_X1: wire port map (i => not_x1, o => not_x1_w);
    WIRE_NOT_X2: wire port map (i => not_x2, o => not_x2_w);
    WIRE_NOT_X3: wire port map (i => not_x3, o => not_x3_w);

    XOR_X2_X3: xor2 port map (i0 => x3_w, i1 => x2_w, o => x3_xor_x2);
    XOR_X1_X0: xor2 port map (i0 => x1_w, i1 => x0_w, o => x1_xor_x0);

    WIRE_XOR1: wire port map (i => x3_xor_x2, o => x3_xor_x2_w);
    WIRE_XOR2: wire port map (i => x1_xor_x0, o => x1_xor_x0_w);

    -- C1 = (x3 xor x2)(x1 xor x0) + !x3!x2x1x0
    AND_C1_11: and2 port map (i0 => x3_xor_x2_w, i1 => x1_xor_x0_w, o => c1_conj1);
    WIRE_C1_11: wire port map (i => c1_conj1, o => c1_conj1_w);

    AND_C1_21: and2 port map (i0 => not_x3_w, i1 => not_x2_w, o => c1_conj2_p1);
    WIRE_C1_21: wire port map (i => c1_conj2_p1, o => c1_conj2_p1_w);

    AND_C1_22: and2 port map (i0 => c1_conj2_p1_w, i1 => x1_w, o => c1_conj2_p2);
    WIRE_C1_22: wire port map (i => c1_conj2_p2, o => c1_conj2_p2_w);

    AND_C1_23: and2 port map (i0 => c1_conj2_p2_w, i1 => x0_w, o => c1_conj2_p3);
    WIRE_C1_23: wire port map (i => c1_conj2_p3, o => c1_conj2_p3_w);

    OR_C1: or2 port map (i0 => c1_conj2_p3_w, i1 => c1_conj1_w, o => c1_res);

    led(11) <= c1_res;

    -- C0 = (x3 xor x2)!x1!x0 + !x3!x2(x1 xor x0)
    AND_C0_11: and2 port map (i0 => x3_xor_x2_w, i1 => not_x1_w, o => c0_conj1_p1);
    WIRE_C0_11: wire port map (i => c0_conj1_p1, o => c0_conj1_p1_w);

    AND_C0_12: and2 port map (i0 => c0_conj1_p1_w, i1 => not_x0_w, o => c0_conj1_p2);
    WIRE_C0_12: wire port map (i => c0_conj1_p2, o => c0_conj1_p2_w);

    AND_C0_21: and2 port map (i0 => not_x2_w, i1 => not_x3_w, o => c0_conj2_p1);
    WIRE_C0_21: wire port map (i => c0_conj2_p1, o => c0_conj2_p1_w);

    AND_C0_22: and2 port map (i0 => c0_conj2_p1_w, i1 => x1_xor_x0_w, o => c0_conj2_p2);
    WIRE_C0_22: wire port map (i => c0_conj2_p2, o => c0_conj2_p2_w);

    OR_C2: or2 port map (i0 => c0_conj1_p2_w, i1 => c0_conj2_p2_w, o => c0_res);

    led(10) <= c0_res;
    led(12) <= x0_w;
    led(13) <= x1_w;
    led(14) <= x2_w;
    led(15) <= x3_w;
end rtl;