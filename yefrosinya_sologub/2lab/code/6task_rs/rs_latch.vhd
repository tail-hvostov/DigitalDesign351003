library IEEE;
use ieee.std_logic_1164.all;

entity rs_latch is
    port (
        sw_i: in std_logic_vector(1 downto 0);
        led_o: out std_logic_vector(1 downto 0)
    );
end rs_latch;

architecture rtl of rs_latch is
    signal Q, nQ, S, R: std_logic;
    
    attribute DONT_TOUCH: string;
    attribute DONT_TOUCH of Q: signal is "TRUE";
    attribute DONT_TOUCH of nQ: signal is "TRUE";
begin
    S <= sw_i(1);
    R <= sw_i(0);
    nQ <= Q nor S;
    Q <= nQ nor R;
    led_o <= Q & nQ;
end rtl;