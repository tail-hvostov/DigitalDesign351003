library ieee;
use ieee.std_logic_1164.all;

library work;
use work.delayed_components.all;

-- F = D723
-- F = 1101 0111 0010 0011

-- | A | B | C | D || F |
-- ----------------------
-- | 0 | 0 | 0 | 0 || 1 |
-- ----------------------
-- | 0 | 0 | 0 | 1 || 1 |
-- ----------------------
-- | 0 | 0 | 1 | 0 || 0 |
-- ----------------------
-- | 0 | 0 | 1 | 1 || 0 |
-- ----------------------
-- | 0 | 1 | 0 | 0 || 0 |
-- ----------------------
-- | 0 | 1 | 0 | 1 || 1 |
-- ----------------------
-- | 0 | 1 | 1 | 0 || 0 |
-- ----------------------
-- | 0 | 1 | 1 | 1 || 0 |
-- ----------------------
-- | 1 | 0 | 0 | 0 || 1 |
-- ----------------------
-- | 1 | 0 | 0 | 1 || 1 |
-- ----------------------
-- | 1 | 0 | 1 | 0 || 1 |
-- ----------------------
-- | 1 | 0 | 1 | 1 || 0 |
-- ----------------------
-- | 1 | 1 | 0 | 0 || 1 |
-- ----------------------
-- | 1 | 1 | 0 | 1 || 0 |
-- ----------------------
-- | 1 | 1 | 1 | 0 || 1 |
-- ----------------------
-- | 1 | 1 | 1 | 1 || 1 |
-- ----------------------

-- ???? = (A + nB + D)(A + nC)(B + nC + nD)(nA + nB + C + nD)

entity tsk4_top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end tsk4_top;

architecture structure of tsk4_top is
    signal nA : std_logic;
    signal nB : std_logic;
    signal nC : std_logic;
    signal nD : std_logic;
    
    signal first_or : std_logic;
    signal second_or : std_logic;
    signal third_or : std_logic;
    signal fourth_or : std_logic;
    
    signal A : std_logic;
    signal B : std_logic;
    signal C : std_logic;
    signal D : std_logic;
    signal F : std_logic;
    
    signal A_nB : std_logic;
    signal B_nC : std_logic;
    signal nA_nB : std_logic;
    signal nA_nB_C : std_logic;
    
    signal f_s : std_logic;
    signal f_s_t : std_logic;
begin
    led_out(15 downto 1) <= "000000000000000";

    A <= sw_in(3);
    B <= sw_in(2);
    C <= sw_in(1);
    D <= sw_in(0);
    led_out(0) <= F;

    U0 : DEL_INV port map (I => A, O => nA);
    U1 : DEL_INV port map (I => B, O => nB);
    U2 : DEL_INV port map (I => C, O => nC);
    U3 : DEL_INV port map (I => D, O => nD);
    
    U41 : DEL_OR2 port map (I0 => A, I1 => nB, O => A_nB);
    U42 : DEL_OR2 port map (I0 => A_nB, I1 => D, O => first_or);
    --U4 : DEL_OR3 port map (I0 => A, I1 => nB, I2 => D, O => first_or);
    U5 : DEL_OR2 port map (I0 => A, I1 => nC, O => second_or);
    
    U61 : DEL_OR2 port map (I0 => B, I1 => nC, O => B_nC);
    U62 : DEL_OR2 port map (I0 => B_nC, I1 => nD, O => third_or);
    --U6 : DEL_OR3 port map (I0 => B, I1 => nC, I2 => nD, O => third_or);
    
    U71 : DEL_OR2 port map (I0 => nA, I1 => nB, O => nA_nB);
    U72 : DEL_OR2 port map (I0 => nA_nB, I1 => C, O => nA_nB_C);
    U73 : DEL_OR2 port map (I0 => nA_nB_C, I1 => nD, O => fourth_or);
    --U7 : DEL_OR4 port map (I0 => nA, I1 => nB, I2 => C, I3 => nD, O => fourth_or);
    
    U81 : DEL_AND2 port map (I0 => first_or, I1 => second_or, O => f_s);
    U82 : DEL_AND2 port map (I0 => f_s, I1 => third_or, O => f_s_t);
    U83 : DEL_AND2 port map (I0 => f_s_t, I1 => fourth_or, O => F);
    --U8 : DEL_AND4 port map (I0 => first_or, I1 => second_or, I2 => third_or, I3 => fourth_or, O => F);
end structure;