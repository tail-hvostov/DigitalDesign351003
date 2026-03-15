library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity task5 is
  Port ( 
  led_o: out std_logic_vector(5 downto 0);
  sw_i: in std_logic_vector(15 downto 0)
  );
end task5;

architecture rtl of task5 is
begin
    P0: process(sw_i)
    variable x1, x2, res: unsigned(5 downto 0);
    begin
    x1 := unsigned(sw_i(15 downto 10));
    x2 := unsigned(sw_i(9 downto 4));  
      
        case sw_i(3 downto 0) is
            when "0001" => res := x1 and x2;
            when "0010" => res := x1 - x2;                           
            when "0100" => res := '0' & x1(5 downto 1);
            when "1000" => res := not (x1 or x2);
            when others => res := (others => '0');
        end case;
        
        led_o <= std_logic_vector(res);
    end process P0;   
end rtl;
