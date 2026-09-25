----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.04.2026 21:21:02
-- Design Name: 
-- Module Name: task1 - Structure
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

entity task1 is
Port(
sw_i: in std_logic_vector (1 downto 0);
led_o:  out std_logic_vector (1 downto 0)
);
end task1;

architecture Structure of task1 is
    signal s0, s1, nS, nR, Q, nQ: std_logic;
    component NAND2 port (A, B: in std_logic; C: out std_logic);
    end component;
begin
    nS <= sw_i(1); 
    nR <= sw_i(0); 
    U1: NAND2 port map (A => nS, B => s0, C => s1);
    U2: NAND2 port map (A => s1, B => nR, C => s0);
    Q <= s1;
    nQ <= s0;
    led_o(1) <= Q;
    led_o(0) <= nQ;
end Structure;
