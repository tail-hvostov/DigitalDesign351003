----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 04:41:18
-- Design Name: 
-- Module Name: task6 - Behavioral
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

entity task6 is
port (
    sw_i: in std_logic_vector(1 downto 0);
    led_o : out std_logic_vector(1 downto 0)
);  
end task6;

architecture Behavioral of task6 is
signal s0, s1, S, R, Q, nQ: std_logic;
    attribute ALLOW_COMBINATORIAL_LOOPS : string;
    attribute ALLOW_COMBINATORIAL_LOOPS of s0 : signal is "TRUE";
    attribute ALLOW_COMBINATORIAL_LOOPS of s1 : signal is "TRUE";
begin
    S <= sw_i(1);
    R <= sw_i(0);
    P0: process (S, s1)
    begin
        s0 <= S nor s1;
    end process P0;
    P1: process (R, s0)
    begin
        s1 <= R nor s0;
    end process P1;
    Q <= s1;
    nQ <= s0;
    led_o(1) <= Q;
    led_o(0) <= nQ;
end Behavioral;
