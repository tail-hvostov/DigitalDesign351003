library ieee;
use ieee.std_logic_1164.all;

entity task3 is
port (
    led_o: out std_logic_vector(15 downto 0);
    sw_i: in std_logic_vector(7 downto 0)
    );
end task3;

architecture rtl of task3 is
    constant i_const: std_logic_vector(7 downto 0) := "00100010"; -- x22
    -- j = xDB = 11011011 
    -- i xor j = 11111001 = sw_i
begin
    led_o(15 downto 8) <= (others => '0');    
    led_o(7 downto 0) <= sw_i xor i_const;
    
    --led_o(7) <= sw_i(7) nand i_const(7);
    --led_o(6) <= sw_i(6) nand i_const(6);
    --led_o(5) <= sw_i(5) nor i_const(5);
    --led_o(4) <= sw_i(4) nand i_const(4);
    --led_o(3) <= sw_i(3) nand i_const(3);
    --led_o(2) <= sw_i(2) and i_const(2);
    --led_o(1) <= sw_i(1) or i_const(1);
    --led_o(0) <= sw_i(0) nand i_const(0);
end rtl;