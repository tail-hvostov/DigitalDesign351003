----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2026 21:06:53
-- Design Name: 
-- Module Name: task4 - Behavioral
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

entity freq_div_behav is
Generic(K : natural := 10);
Port ( 
    CLK : in std_logic;
    RST : in std_logic;
    EN : in std_logic;
    Q : out std_logic
);
end freq_div_behav;

architecture Behavioral of freq_div_behav is
signal output: std_logic;
constant maxCount : integer := K/2-1;
begin
    P0: process (CLK, EN, RST)
    variable counter : integer range 0 to maxCount;
    begin
        if (rising_edge(CLK)) then
            if RST = '1' then
                counter := 0;
                output <= '0';
            elsif EN = '1' then
                if counter = maxCount then
                    counter := 0;
                    output <= not output;
                else
                    counter := counter + 1;
                end if;
            end if;   
        end if;
    end process P0;
    Q <= output;

end Behavioral;
