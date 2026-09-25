----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2026 23:32:58
-- Design Name: 
-- Module Name: task4_TE - Behavioral
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

entity task4_TE is
--  Port ( );
end task4_TE;

architecture Behavioral of task4_TE is
signal clk : std_logic := '0';
signal reset, enable, output: std_logic;
constant half_period : time := 5ns;
constant kTimes : natural := 10;
constant repeatNTimes : natural := kTimes*5;

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
    UT: freq_div_behav generic map (kTimes) port map (CLK => clk, RST => reset, EN => enable, Q => output);
    Clock_process: process
    begin
        --10ns => 100MHz
        clk <= '0';
        wait for half_period;
        clk <= '1';
        wait for half_period;
    end process Clock_process;
    Test_process: process
    begin
        wait for half_period;
        reset <= '1';
        enable <= '0';
        wait for half_period;
        reset <= '0';
        wait for half_period;
        enable <= '1';
        wait for half_period*repeatNTimes;
    end process;
end Behavioral;
