library ieee;
use ieee.std_logic_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.delayed_components.all;

entity tsk6_top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end tsk6_top;

-- Q2 = WD + QnW
-- W - write
-- D - data

architecture structure of tsk6_top is
    signal W : std_logic;
    signal D : std_logic;

    signal Q : std_logic;
    signal nQ : std_logic;
    
    signal WD : std_logic;
    signal nW : std_logic;
    signal QnW : std_logic;
    signal Q2 : std_logic;
begin
    W <= sw_in(1);
    D <= sw_in(0);

    led_out(15 downto 2) <= "00000000000000";
    
--    U1 : LUT1
--        generic map (INIT => "01")
--        port map (I0 => Q2, O => nQ);
    U1 : DEL_INV port map (I => Q2, O => nQ);
    
--    U2 : LUT1
--        generic map (INIT => "01")
--        port map (I0 => nQ, O => Q);
    U2 : DEL_INV port map (I => nQ, O => Q);
    
    U3 : DEL_AND2 port map (I0 => W, I1 => D, O => WD);
    U4 : DEL_INV port map (I => W, O => nW);
    U5 : DEL_AND2 port map (I0 => Q, I1 => nW, O => QnW);
    U6 : DEL_OR2 port map (I0 => WD, I1 => QnW, O => Q2);
        
    led_out(1) <= Q2;
    led_out(0) <= nQ;
end structure;