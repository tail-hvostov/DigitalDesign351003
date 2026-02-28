library ieee;
use ieee.std_logic_1164.all;

library work;
use work.domestic_components.all;

-- 3: nAnBCD = (A nor B)CD
-- 2: nAnBCnD = (A nor B)CnD = (A nor B)(C xor D)C
-- 1: nAnBnCD = (A nor B)nCD = (A nor B)(C xor D)D
-- 0: nAnBnCnD = (A nor B)nCnD = (A nor B)(C nor D)

entity tsk1_top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end tsk1_top;

architecture structure of tsk1_top is
    signal A : std_logic;
    signal B : std_logic;
    signal C : std_logic;
    signal D : std_logic;
    
    signal nC : std_logic;
    signal nD : std_logic;
    
    signal nAnB : std_logic;
    signal nAnBC : std_logic;
    signal nAnBnC : std_logic;
    signal CD : std_logic;
begin
    A <= sw_in(3);
    B <= sw_in(2);
    C <= sw_in(1);
    D <= sw_in(0);

    led_out(15 downto 4) <= "000000000000";
    
    U1 : DOM_INV port map (I => C, O => nC);
    U2 : DOM_INV port map (I => D, O => nD);
    
    U3 : DOM_NOR2 port map (I0 => A, I1 => B, O => nAnB);
    U4 : DOM_AND2 port map (I0 => nAnB, I1 => C, O => nAnBC);
    U5 : DOM_AND2 port map (I0 => nAnB, I1 => nC, O => nAnBnC);
    
    U6 : DOM_AND2 port map (I0 => nAnBC, I1 => D, O => led_out(3));
    U7 : DOM_AND2 port map (I0 => nAnBC, I1 => nD, O => led_out(2));
    U8 : DOM_AND2 port map (I0 => nAnBnC, I1 => D, O => led_out(1));
    U9 : DOM_AND2 port map (I0 => nAnBnC, I1 => nD, O => led_out(0));
end structure;