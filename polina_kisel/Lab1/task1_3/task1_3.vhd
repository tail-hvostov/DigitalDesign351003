----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2026 13:57:14
-- Design Name: 
-- Module Name: task1_3 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity task1_3 is
    port(
        led_o : out std_logic_vector(15 downto 0);
        sw_i : in std_logic_vector(7 downto 0) 
    );
 
end task1_3;
 
--Вар 11: I:=83 это 1000 0011  J:=FA это 1111 1010 
architecture Behavioral of task1_3 is
    constant I: std_logic_vector(15 downto 8):= x"83";
    signal result: std_logic_vector(15 downto 8) ;
begin
    result <= sw_i xor I;
 
    led_o(15 downto 8) <= result;
    --led_o <= result & result;  FAFA?(спросить) или нам нужно 00FA или Fa00
    led_o(7 downto 0) <="00000000";
 
end Behavioral;

