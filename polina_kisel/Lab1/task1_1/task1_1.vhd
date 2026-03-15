----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 13:32:34
-- Design Name: 
-- Module Name: task1_1 - Behavioral
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
entity task1_1 is
    port(
        led_o : out std_logic_vector(15 downto 0)
    );
end task1_1;

--Вар 11: K=F609(16я) тогда K(2й)=1111 0110 0000 1001 
architecture Behavioral of task1_1 is
  --  constant K: std_logic_vector(15 downto 0):="1111011000001001";
begin
  --  led_o <= K; или так нельзя? спросить
  led_o <= x"F609";
 
end Behavioral;
 
