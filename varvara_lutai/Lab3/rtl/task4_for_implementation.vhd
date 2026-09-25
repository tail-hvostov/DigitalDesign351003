----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.04.2026 03:49:20
-- Design Name: 
-- Module Name: task4_for_implementation - Behavioral
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

entity task4_for_implementation is
Port ( 
clk : in std_logic;
sw_i : in std_logic_vector (1 downto 0);
led_o : out std_logic_vector (0 downto 0)
);
end task4_for_implementation;

architecture Behavioral of task4_for_implementation is
constant kTimes : natural := 50000000;
component freq_div_behav is
Generic(K : natural);
Port ( 
    CLK : in std_logic;
    RST : in std_logic;
    EN : in std_logic;
    Q : out std_logic
);
end component;

begin
    UT: freq_div_behav generic map (kTimes) port map (CLK => clk, RST => sw_i(1), EN => sw_i(0), Q => led_o(0));
end Behavioral;
