library ieee;
use ieee.std_logic_1164.all;

entity task6 is
    port (
    led_o: out std_logic_vector(3 downto 0);
    sw_i: in std_logic_vector(3 downto 0)
    );
end task6;

architecture rtl of task6 is
begin
    P0: process(sw_i)
    begin
        case sw_i is
        when "0010" => led_o <= "0001"; -- 1
        when "0100" => led_o <= "0010"; -- 2
        when "0110" => led_o <= "0100"; -- 3
        
        when "1000" => led_o <= "1001"; -- 7
        when "1010" => led_o <= "1010"; -- 8
        when "1100" => led_o <= "1100"; -- 9
        
        when others => led_o <= "0000";
        end case;
        
    end process P0;
end rtl;