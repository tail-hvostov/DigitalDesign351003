----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2026 13:09:41
-- Design Name: 
-- Module Name: task3_TB - Behavioral
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

entity task3_TB is
--  Port ( );
end task3_TB;

architecture Behavioral of task3_TB is
component reg_unit is generic (N: natural); port (
CLK : in std_logic;
RST : in std_logic;
EN : in std_logic;
Din : in std_logic_vector (3 downto 0);  
Dout : out std_logic_vector (3 downto 0)
); end component;
signal clock, reset, enable: std_logic;
signal data, output : std_logic_vector (3 downto 0);
begin
    UT: reg_unit generic map (4) port map (CLK => clock, RST => reset, EN => enable, Din => data, Dout => output);
    CLK_PROCESS: process
        constant T : time := 100 ns;
    begin
        clock <= '0';
        wait for 2*T;
        clock <= '1';
        wait for 2*T;
    end process;
    P0: process
        constant T : time := 100 ns;
        begin      
            wait for 20*T;
            reset <= '1';
            enable <= '1';
            data <= "0110"; --не должно записаться
        --запись
            wait for 20*T; -- для переднего фронта на CLK        
            reset <= '0';
            enable <= '1';
            data <= "1100";
        --хранение
            wait for 20*T;
            reset <= '0';
            enable <= '0';
            data <= "0011"; --не должно записаться
        --запись
            wait for 20*T;
            reset <= '0';
            enable <= '1';
            data <= "1010";  
--хранение
            wait for 20*T;
            reset <= '0';
            enable <= '0';
            data <= "0011"; --не должно записаться   
--хранение
            wait for 20*T;
            reset <= '0';
            enable <= '0';
            data <= "0011"; --не должно записаться    
        end process P0;
end Behavioral;
