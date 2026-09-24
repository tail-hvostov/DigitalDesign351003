----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2026 17:01:42
-- Design Name: 
-- Module Name: TM_withfreq - Behavioral
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

entity TM_withfreq is

      Generic ( N : natural := 8 );
    Port (
        CLK  : in  std_logic;
        CLR  : in  std_logic; -- Асинхронный сброс
        EN   : in  std_logic;
        MODE : in  std_logic_vector (1 downto 0); 
        DIN  : in  std_logic_vector (N-1 downto 0);
        DOUT : out std_logic_vector (N-1 downto 0)
    );
end TM_withfreq;

architecture Behavioral of TM_withfreq is

signal freq_clk: std_logic;
begin

UFD: entity work.freq_div_behav 
port map (

CLK=> CLK,
RST=> CLR,
EN => EN ,
Q  => freq_clk
);


UTM: entity work.universal_counter 
        generic map (N => N) 
        port map (freq_clk, clr, en, mode, din, dout);
end Behavioral;
