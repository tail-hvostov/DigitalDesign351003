----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2026 23:30:52
-- Design Name: 
-- Module Name: temp - Behavioral
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

entity temp is
port (
A, B, C : in std_logic;
F: out std_logic
);
end temp;

architecture Behavioral of temp is

begin
--P0: process (A, B, C)
--    variable v0, v1 : std_logic;
--    begin
--        v0 := A xor B;
--        v1 := v0 xor C;
--        F <= v1;
--end process P0;

--P1: process
--    variable v0, v1 : std_logic;
--    begin
--        wait on A, B, C;
--        v0 := A xor B;
--        v1 := v0 xor C;
--        F <= v1;
--end process P1;

P2: process
    variable v0, v1 : std_logic;
    begin
        v0 := A xor B;
        v1 := v0 xor C;
        F <= v1;
        wait on A, B, C;
end process P2;
end Behavioral;
