----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2026 23:19:38
-- Design Name: 
-- Module Name: task4 - Structural
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

entity task4 is
generic (
N : integer range 1 to 8 := 4
);
port (
sw_i : in std_logic_vector (2*N-1 downto 0);
led_o : out std_logic_vector (2 downto 0)
);
end task4;

architecture Structural of task4 is
component comparator is port(gin, ein : in std_logic; x, y : in std_logic; gout, eout : out std_logic);
end component;
signal x, y: std_logic_vector(N-1 downto 0);
signal g, e: std_logic_vector(N downto 0);
begin
g(N) <= '0';
e(N) <= '1';
x <= sw_i(2*N-1 downto N);
y <= sw_i(N-1 downto 0);
SCH: for i in N-1 downto 0 generate
    Ui0 : comparator port map (gin => g(i+1), ein => e(i+1), x => x(i), y => y(i), gout => g(i), eout => e(i));
end generate;
led_o(2) <= g(0);
led_o(1) <= e(0);
led_o (0) <= (not g(0)) and (not e(0));
end Structural;
