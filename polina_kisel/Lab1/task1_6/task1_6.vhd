
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity task1_6 is
    Port ( sw_i : in  STD_LOGIC_VECTOR (3 downto 0); 
           led_o : out STD_LOGIC_VECTOR (3 downto 0)); 
end task1_6;
 
architecture Behavioral of task1_6 is
begin
    process(sw_i)
    begin
        case sw_i is
            when "0000" => led_o <= "0000";
            when "0001" => led_o <= "0001";
            when "0010" => led_o <= "0010";
            when "0011" => led_o <= "0100";
            when "0100" => led_o <= "0101";
            when "1011" => led_o <= "0110";
            when "1100" => led_o <= "1000";
            when "1101" => led_o <= "1001";
            when "1110" => led_o <= "1010";
            when "1111" => led_o <= "1100";
            when others => led_o <= "0000"; -- Для ост 
        end case;
    end process;
end Behavioral;


