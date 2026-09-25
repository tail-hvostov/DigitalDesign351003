----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2026 14:54:11
-- Design Name: 
-- Module Name: task2 - Behavioral
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

entity task2 is
end task2;

architecture Behavioral of task2 is
--component task1 is port(
component task3 is port(
    sw_i : in std_logic_vector (3 downto 0);
    led_o   :out std_logic_vector (3 downto 0));
end component;
signal x : std_logic_vector (3 downto 0);
signal y : std_logic_vector (3 downto 0);
constant T :time := 100ns;
begin
    --UUT : task1 port map (sw_i => x, led_o => y);
    UUT : task3 port map (sw_i => x, led_o => y);
    Sim: process 
    begin
        wait for 20*T;
        --Правильные комбинации
        x <= "0000"; wait for 10*T;
        x <= "0001"; wait for 10*T;
        x <= "0010"; wait for 10*T;
        x <= "0111"; wait for 10*T;
        x <= "1000"; wait for 10*T;
        x <= "1001"; wait for 10*T;
        x <= "1010"; wait for 10*T;
        --Неравильные комбинации
        x <= "0011"; wait for 10*T;
        x <= "0100"; wait for 10*T;
        x <= "0101"; wait for 10*T;
        x <= "0110"; wait for 10*T;
        x <= "1011"; wait for 10*T;
        x <= "1100"; wait for 10*T;
        x <= "1101"; wait for 10*T;
        x <= "1110"; wait for 10*T;
        x <= "1111"; wait for 10*T;
        report "The end of simulation" severity failure;
    end process Sim;
end Behavioral;
