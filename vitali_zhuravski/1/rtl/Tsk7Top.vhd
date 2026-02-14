library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

-- 3: nAnBCD
-- 2: nAnBCnD
-- 1: nAnBnCD
-- 0: nAnBnCnD

entity tsk7_top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end tsk7_top;

architecture structure of tsk7_top is
    alias A : std_logic is sw_in(3);
    alias B : std_logic is sw_in(2);
    alias C : std_logic is sw_in(1);
    alias D : std_logic is sw_in(0);
    
    signal nA : std_logic;
    signal nB : std_logic;
    signal nC : std_logic;
    signal nD : std_logic;
    
    signal nAnB : std_logic;
    signal nAnBC : std_logic;
    signal nAnBnC : std_logic;
begin
    led_out(15 downto 4) <= "000000000000";
    
    U0 : INV port map (I => A, O => nA);
    U1 : INV port map (I => B, O => nB);
    U2 : INV port map (I => C, O => nC);
    U3 : INV port map (I => D, O => nD);
    
    U4 : AND2 port map (I0 => nA, I1 => nB, O => nAnB);
    U5 : AND2 port map (I0 => nAnB, I1 => C, O => nAnBC);
    U6 : AND2 port map (I0 => nAnB, I1 => nC, O => nAnBnC);
    
    U7 : AND2 port map (I0 => nAnBC, I1 => D, O => led_out(3));
    U8 : AND2 port map (I0 => nAnBC, I1 => nD, O => led_out(2));
    U9 : AND2 port map (I0 => nAnBnC, I1 => D, O => led_out(1));
    U10 : AND2 port map (I0 => nAnBnC, I1 => nD, O => led_out(0));
end structure;