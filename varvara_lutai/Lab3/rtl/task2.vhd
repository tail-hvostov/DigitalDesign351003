----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2026 12:17:06
-- Design Name: 
-- Module Name: task2 - Behavioral
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

entity DFF_async_CLR_N is
  Port ( 
  CLR_N : in std_logic;
  CLK : in std_logic;
  D : in std_logic;
  Q : out std_logic
  );
end DFF_async_CLR_N;

architecture Behavioral of DFF_async_CLR_N is
signal store: std_logic;
begin 
    P0: process (CLR_N, CLK, D)
    begin
        if CLR_N='0' then
            store <= '0';
        elsif rising_edge(CLK) then
            store <= D;
        end if;            
    end process P0;
--      P0: process (CLR_N, CLK, D)
--      begin
--        if rising_edge(CLK) then
--            store <= D;
--        end if;
--        if falling_edge(CLR_N) then
--            store <= '0';
--        end if;
--      end process P0;
    Q <= store;
end Behavioral;
