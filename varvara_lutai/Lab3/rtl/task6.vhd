----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.05.2026 13:43:20
-- Design Name: 
-- Module Name: pwm - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_controller is
    Generic (CNT_WIDTH : natural := 8);
    Port ( 
        CLK : in std_logic;
        CLR : in std_logic;
        EN : in std_logic;
        FILL : in std_logic_vector (CNT_WIDTH-1 downto 0);
        Q : out std_logic
    );
end pwm_controller;

architecture Behavioral of pwm_controller is
    signal output: std_logic; 
    constant maxCount : integer := 2**CNT_WIDTH-1;
begin
    P0: process (CLR, CLK, EN, FILL)
    variable counter : integer range 0 to maxCount;
    begin
        if CLR = '1' then
            counter := 0;
            output <= '0';
        elsif rising_edge(CLK) then
            if EN = '1' then
                if  to_integer(unsigned(FILL)) = 0 then
                    output <= 'Z';
                elsif counter < to_integer(unsigned(FILL)) then
                    output <= '1';
                else
                    output <= '0';
                end if;
                if counter < maxCount then
                    counter := counter + 1;
                else
                    counter := 0;
                end if;
            end if;
        end if;      
    end process;
    Q <= output;
end Behavioral;
