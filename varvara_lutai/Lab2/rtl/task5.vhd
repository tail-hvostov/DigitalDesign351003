----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 04:22:48
-- Design Name: 
-- Module Name: task5 - Behavioral
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

entity task5 is
port (
    led_o: out std_logic_vector(1 downto 0)
);
end task5;
architecture Behavioral of task5 is
signal s0, s1, Q, nQ: std_logic;
    attribute ALLOW_COMBINATORIAL_LOOPS : string;
    attribute ALLOW_COMBINATORIAL_LOOPS of s0 : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s1 : signal is "TRUE";
begin
s0 <= not s1;
s1 <= not s0;
Q <= s0;
nQ <= s1;
led_o <= Q & nQ;
end Behavioral;
