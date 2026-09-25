----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 03:37:36
-- Design Name: 
-- Module Name: task4_testbench - Behavioral
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

entity task4_testbench is
--  Port ( );
end task4_testbench;

architecture Behavioral of task4_testbench is
component task4 port (sw_i : in std_logic_vector; led_o : out std_logic_vector);
end component;
signal xy: std_logic_vector (7 downto 0);
signal F: std_logic_vector (2 downto 0);
begin
    UT: task4 port map (sw_i => xy, led_o => F);
    P1: process
    constant T : time := 100ns;
    begin
        wait for 20*T;
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                wait for 20*T;
                xy <= std_logic_vector(to_unsigned(i, 4)) & std_logic_vector(to_unsigned(j, 4));
            end loop;
        end loop;
    end process;

end Behavioral;
