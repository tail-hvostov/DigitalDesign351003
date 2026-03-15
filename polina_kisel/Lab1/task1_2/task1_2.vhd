----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 13:49:34
-- Design Name: 
-- Module Name: task1_2 - Behavioral
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
entity task1_2 is
    port(
        led_o : out std_logic_vector(15 downto 0);
        sw_i : in std_logic_vector(15 downto 0) 
    );
 
end task1_2;
 
 
--Вар 11: 
architecture Behavioral of task1_2 is
begin
    led_o <= sw_i;
 
end Behavioral;

