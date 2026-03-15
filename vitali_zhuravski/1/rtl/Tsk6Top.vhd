library ieee;
use ieee.std_logic_1164.all;

-- 3: nAnBCD
-- 2: nAnBCnD
-- 1: nAnBnCD
-- 0: nAnBnCnD

entity tsk6_top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end tsk6_top;

architecture rtl of tsk6_top is
    signal inp : std_logic_vector(3 downto 0);
begin
    inp <= sw_in(3 downto 0);

    led_out(15 downto 4) <= "000000000000";
    -- led_out(3) <= (not inp(3)) and (not inp(2)) and inp(1) and inp(0);
    led_out(3) <= (inp(3) nor inp(2)) and inp(1) and inp(0);
    --led_out(2) <= (not inp(3)) and (not inp(2)) and inp(1) and (not inp(0));
    led_out(2) <= (inp(3) nor inp(2)) and inp(1) and (not inp(0));
    --led_out(1) <= (not inp(3)) and (not inp(2)) and (not inp(1)) and inp(0);
    led_out(1) <= (inp(3) nor inp(2)) and (not inp(1)) and inp(0);
    --led_out(0) <= (not inp(3)) and (not inp(2)) and (not inp(1)) and (not inp(0));
    led_out(0) <= (inp(3) nor inp(2)) and (not inp(1)) and (not inp(0));
end rtl;