----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.05.2026 21:56:56
-- Design Name: 
-- Module Name: task6_for_implementation - Behavioral
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

entity task6_for_implementation is
  Generic (CNT_WIDTH : natural := 8);
  Port ( 
  clk : in std_logic;
  sw_i : in std_logic_vector (CNT_WIDTH+1 downto 0);
  led_o: out std_logic_vector (0 downto 0)
  );
end task6_for_implementation;

architecture Behavioral of task6_for_implementation is
component pwm_controller is
    Generic (CNT_WIDTH : natural := 8);
    Port ( 
        CLK : in std_logic;
        CLR : in std_logic;
        EN : in std_logic;
        FILL : in std_logic_vector (CNT_WIDTH-1 downto 0);
        Q : out std_logic
    );
end component pwm_controller;
constant kTimes : natural := 1000000; -- 1 на 10^6, получим 100√ц
component freq_div_behav is
Generic(K : natural); 
Port ( 
    CLK : in std_logic;
    RST : in std_logic;
    EN : in std_logic;
    Q : out std_logic
);
end component freq_div_behav;
signal divided_clock : std_logic;
begin
    UFDB: freq_div_behav generic map (kTimes) port map (CLK => clk, RST => sw_i(CNT_WIDTH+1), EN => sw_i(CNT_WIDTH), Q => divided_clock);
    UPWMC: pwm_controller generic map (CNT_WIDTH) port map (CLK => divided_clock, CLR => sw_i(CNT_WIDTH+1), EN => sw_i(CNT_WIDTH), FILL => sw_i(CNT_WIDTH-1 downto 0), Q => led_o(0));
end Behavioral;
