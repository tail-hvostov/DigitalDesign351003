----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2026 00:21:22
-- Design Name: 
-- Module Name: task1_TB - Behavioral
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

entity task1_TB is
--  Port ( );
end task1_TB;

architecture Behavioral of task1_TB is
component task1 port (sw_i : in std_logic_vector; led_o : out std_logic_vector);
end component;
signal nSnR, QnQ: std_logic_vector (1 downto 0);
begin
    UT: task1 port map (sw_i => nSnR, led_o =>QnQ);
    P0: process 
    constant T : time := 100ns;
    begin
        wait for 20*T;
        nSnR <= "10"; --Q=0, nQ=1 -- Set
        wait for 20*T; 
        nSnR <= "11"; --Q_prev=0, Q_cur=0, nQ_cur=1, короче, сохранили 0
        wait for 20*T; 
        nSnR <= "01"; --Q=1, nQ=0 -- Reset
        wait for 20*T;
        nSnR <= "11"; --Q_prev=1, Q_cur=1, nQ_cur=0, короче, сохранили 1   
        wait for 20*T;
        nSnR <= "00"; --Q=1, nQ=1 -- запрещенное состояние  
        wait for 20*T;
        nSnR <= "11"; --выход из запрещенного состояния в состояние хранения          
    end process;

end Behavioral;
