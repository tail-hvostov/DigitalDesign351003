----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2026 23:29:18
-- Design Name: 
-- Module Name: task2_TB - Behavioral
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

entity task2_TB is
--  Port ( );
end task2_TB;

architecture Behavioral of task2_TB is
component DFF_async_CLR_N port (CLR_N : in std_logic; CLK : in std_logic; D : in std_logic; Q : out std_logic);
end component;
--signal input_vector: std_logic_vector (2 downto 0);
signal clear, clock, data: std_logic;
signal output: std_logic;
begin
--    UT: DFF_async_CLR_N port map (CLR_N => input_vector(2), CLK => input_vector(1), D => input_vector(0), Q => output);
--    P0: process
--    constant T : time := 100ns;
--    begin
--        wait for 20*T;
--        input_vector <= "100";
--        wait for 20*T;
--        input_vector <= "110";
--        wait for 20*T;
--        input_vector <= "111";        
--        wait for 20*T;
--        input_vector <= "011";              
--    end process P0;
    UT: DFF_async_CLR_N port map (CLR_N => clear, CLK => clock, D => data, Q => output);
    P0: process
    constant T : time := 100ns;
    begin
        wait for 20*T;
        clear <= '1';
        clock <= '0';
        data <= '0';
        wait for 20*T;
        clear <= '1';
        clock <= '1';
        data <= '0';
        wait for 10*T; -- для переднего фронта на CLK
        clock <= '0';        
        wait for 10*T;
        clear <= '1';
        clock <= '1';
        data <= '1'; 
        wait for 10*T; -- для переднего фронта на CLK
        clock <= '0';           
        wait for 10*T;
        clear <= '0';
        clock <= '1';
        data <= '1';  
    end process P0;
end Behavioral;
