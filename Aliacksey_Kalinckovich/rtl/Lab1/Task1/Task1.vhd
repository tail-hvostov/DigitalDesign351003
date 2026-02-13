library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task1 is
    port ( 
        sw_i  : in  std_logic_vector(15 downto 0);  
        led_o : out std_logic_vector(15 downto 0)  
    );
end Task1;

architecture rtl of Task1 is
begin
    led_o <= "0010111111011100";
end rtl;