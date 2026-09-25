----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2026 00:13:01
-- Design Name: 
-- Module Name: task6_TB - Behavioral
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

entity task6_TB is
--  Port ( );
end task6_TB;

architecture Behavioral of task6_TB is
constant const_CNT_WIDTH : natural := 2;
component pwm_controller is
    Generic (CNT_WIDTH : natural);
    Port ( 
        CLK : in std_logic;
        CLR : in std_logic;
        EN : in std_logic;
        FILL : in std_logic_vector (CNT_WIDTH-1 downto 0);
        Q : out std_logic
    );
end component pwm_controller;
signal clock, clear, enable, q_sig : std_logic;
signal fill_sig: std_logic_vector(const_CNT_WIDTH-1 downto 0);
constant half_period : time := 5ns;
constant modulo : natural := 2**const_CNT_WIDTH;
begin
    UPWMC: pwm_controller generic map (const_CNT_WIDTH) port map (CLK => clock, CLR => clear, EN => enable, FILL => fill_sig, Q => q_sig);
    Clock_process: process
        begin
            clock <= '0';
            wait for half_period;
            clock <= '1';
            wait for half_period;
        end process Clock_process;
        Test_process: process
        begin
            wait for half_period;
            clear <= '1';
            enable <= '0';
            wait for half_period;
            clear <= '0';
            wait for half_period;
            enable <= '1';
            --0%
            fill_sig <= "00";
            wait for half_period*modulo*2;
            --25%
            fill_sig <= "01";
            wait for half_period*modulo*2;
            --50%
            fill_sig <= "10";
            wait for half_period*modulo*2;
            --75%
            fill_sig <= "11";
            wait for half_period*modulo*2;
            --100% невозможно, т.к. счет по модулю 2^CNT_WIDTH
            --изменение коэффициента заполнения
            fill_sig <= "01";
            wait for half_period*modulo;
            fill_sig <= "11";
            wait for half_period*modulo*2;
        end process;

end Behavioral;
