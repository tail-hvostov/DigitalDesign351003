library ieee;
use ieee.std_logic_1164.all;

-- K = $D723
-- N = 16
-- K = 1101 0111 0010 0011

entity tsk1_top is
    port (
        led_out : out std_logic_vector(15 downto 0)
    );
end tsk1_top;

architecture rtl of tsk1_top is
begin
    led_out <= "1101011100100011";
end rtl;