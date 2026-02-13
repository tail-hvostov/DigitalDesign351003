library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Task6 is
    Port ( 
        sw_i : in std_logic_vector(2 downto 0);
        led_o : out std_logic_vector(2 downto 0)
    );
end Task6;

architecture Behavioral of Task6 is
    signal Y0,Y1,Y2 : std_logic;
begin
    
    Y0 <= not(sw_i(2));
    
    Y1 <= sw_i(0) or (sw_i(1) and sw_i(2));
    
    Y2 <= sw_i(0);
    
    led_o <= Y2 & Y1 & Y0;
end Behavioral;
