----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2026 01:57:02
-- Design Name: 
-- Module Name: task2_for_implementation - Behavioral
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

entity task2_for_implementation is
port (
sw_i: in std_logic_vector (2 downto 0);
led_o : out std_logic_vector (0 downto 0)
);
end task2_for_implementation;

architecture Behavioral of task2_for_implementation is
component DFF_async_CLR_N port (CLR_N : in std_logic; CLK : in std_logic; D : in std_logic; Q : out std_logic);
end component;
begin
    UT: DFF_async_CLR_N port map (CLR_N => sw_i(2), CLK => sw_i(1), D => sw_i(0), Q => led_o(0));
end Behavioral;
