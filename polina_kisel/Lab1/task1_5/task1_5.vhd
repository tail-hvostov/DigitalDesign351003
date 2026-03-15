----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2026 14:55:34
-- Design Name: 
-- Module Name: task1_5 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity task1_5 is
  Port ( 
        sw_i: in std_logic_vector(15 downto 0);
        led_o: out std_logic_vector(5 downto 0)
  );
end task1_5;

architecture Behavioral of task1_5 is
    signal Operation: std_logic_vector(3 downto 0);
    signal Num1: unsigned (5 downto 0);
    signal Num2: unsigned (5 downto 0);
    signal Res: unsigned (5 downto 0);
begin
    Operation <= sw_i(3 downto 0);
    Num1 <= unsigned(sw_i(9 downto 4));
    Num2 <= unsigned(sw_i(15 downto 10));
    
    process(Operation, Num1, Num2)
    begin
    case Operation is
        when "0001" =>
          Res <= not (Num1 or Num2);
        when "0010" =>
           Res <= shift_right (Num1,1);
        when "0100" =>
           Res <= Num1 - Num2;
        when "1000" =>
           Res <= Num1 and Num2;
        when others => 
           Res <= "000000";
    end case;
    end process;
    
    led_o <= std_logic_vector(Res);
    
end Behavioral;
