----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2026 02:15:12
-- Design Name: 
-- Module Name: task3 - Behavioral
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

entity reg_unit is
generic (
N: natural := 34
);
Port ( 
CLK : in std_logic;
RST : in std_logic;
EN : in std_logic;
Din : in std_logic_vector (N-1 downto 0);  
Dout : out std_logic_vector (N-1 downto 0)
);
end reg_unit;

architecture Behavioral of reg_unit is
component DFF_async_CLR_N port (CLR_N : in std_logic; CLK : in std_logic; D : in std_logic; Q : out std_logic);
end component;
signal sreg : std_logic_vector (N-1 downto 0);
signal clear: std_logic;
begin
    SCH: for i in N-1 downto 0 generate
        Ui0 : DFF_async_CLR_N port map (CLR_N=> clear, CLK => CLK, D => sreg(i), Q => Dout(i));
    end generate;
    P0: process (CLK) -- т.к. синхронный ресет, то изменение значения на рст не должно запускать процесс
    begin
        if rising_edge(CLK) then
            clear <= not rst;
        end if;
    end process P0;
    sreg <= Din when EN = '1';  
end Behavioral;
