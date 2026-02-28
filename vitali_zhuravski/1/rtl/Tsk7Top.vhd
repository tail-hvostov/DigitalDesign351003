library ieee;
use ieee.std_logic_1164.all;

-- 3: nAnBCD
-- 2: nAnBCnD
-- 1: nAnBnCD
-- 0: nAnBnCnD

library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

entity tsk7_top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end tsk7_top;

architecture structure of tsk7_top is
    signal A : std_logic;
    signal B : std_logic;
    signal C : std_logic;
    signal D : std_logic;
    
    signal nA : std_logic;
    signal nB : std_logic;
    signal nC : std_logic;
    signal nD : std_logic;
    signal GND : std_logic;
    
    signal nAnB : std_logic;
    signal nAnBC : std_logic;
    signal nAnBnC : std_logic;
    
    component MUX2
        port(
            I0, I1, S : in std_logic;
            O : out std_logic
        );
    end component;
    
begin
    
    A <= sw_in(3);
    B <= sw_in(2);
    C <= sw_in(1);
    D <= sw_in(0);

    led_out(15 downto 4) <= "000000000000";
    
    GND <= '0';
    
    U0 : INV port map (I => A, O => nA);
    U1 : INV port map (I => B, O => nB);
    U2 : INV port map (I => C, O => nC);
    U3 : INV port map (I => D, O => nD);
    
    U4 : MUX2 port map (I0 => GND, I1 => nA, S => nB, O => nAnB);
    U5 : MUX2 port map (I0 => GND, I1 => nAnB, S => C, O => nAnBC);
    U6 : MUX2 port map (I0 => GND, I1 => nAnB, S => nC, O => nAnBnC);
    U7 : MUX2 port map (I0 => GND, I1 => nAnBC, S => D, O => led_out(3));
    U8 : MUX2 port map (I0 => GND, I1 => nAnBC, S => nD, O => led_out(2));
    U9 : MUX2 port map (I0 => GND, I1 => nAnBnC, S => D, O => led_out(1));
    U10 : MUX2 port map (I0 => GND, I1 => nAnBnC, S => nD, O => led_out(0));
    -- U4 : AND2 port map (I0 => nA, I1 => nB, O => nAnB);
    -- U5 : AND2 port map (I0 => nAnB, I1 => C, O => nAnBC);
    -- U6 : AND2 port map (I0 => nAnB, I1 => nC, O => nAnBnC);
    -- U7 : AND2 port map (I0 => nAnBC, I1 => D, O => led_out(3));
    -- U8 : AND2 port map (I0 => nAnBC, I1 => nD, O => led_out(2));
    -- U9 : AND2 port map (I0 => nAnBnC, I1 => D, O => led_out(1));
    -- U10 : AND2 port map (I0 => nAnBnC, I1 => nD, O => led_out(0));
end structure;