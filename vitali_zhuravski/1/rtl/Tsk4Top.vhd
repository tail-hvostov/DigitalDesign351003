library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

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
    
    alias A : std_logic is sw_in(3);
    alias B : std_logic is sw_in(2);
    alias C : std_logic is sw_in(1);
    alias D : std_logic is sw_in(0);
    alias F : std_logic is led_out(0);
begin
    led_out(15 downto 1) <= "000000000000000";

    U0 : INV port map (I => A, O => nA);
    U1 : INV port map (I => B, O => nB);
    U2 : INV port map (I => C, O => nC);
    U3 : INV port map (I => D, O => nD);
    
    U4 : OR3 port map (I0 => A, I1 => nB, I2 => D, O => first_or);
    U5 : OR2 port map (I0 => A, I1 => nC, O => second_or);
    U6 : OR3 port map (I0 => B, I1 => nC, I2 => nD, O => third_or);
    U7 : OR4 port map (I0 => nA, I1 => nB, I2 => C, I3 => nD, O => fourth_or);
    
    U8 : AND4 port map (I0 => first_or, I1 => second_or, I2 => third_or, I3 => fourth_or, O => F);
end structure;