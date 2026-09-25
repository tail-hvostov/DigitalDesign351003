----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2026 22:38:46
-- Design Name: 
-- Module Name: task1 - Structural
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
port (
sw_i  :in std_logic_vector (3 downto 0);
led_o   :out std_logic_vector (3 downto 0)
);
end task1;

architecture Structural of task1 is
signal NX1, NX2, NX3, NX0, SU1, SU2, SU3, SU4, SU5, SU6, SU7, SU8, SU9, SU10, SU11, SU12: std_logic;
component AND2 port (A: in std_logic; B: in std_logic; C: out std_logic);
end component;
component OR2 port (A: in std_logic; B: in std_logic; C: out std_logic);
end component;
component INV port (A: in std_logic; B: out std_logic);
end component;
begin
--Вычисление y3 и y1
I1: INV port map(A => sw_i(0), B => NX0);
I2: INV port map(A => sw_i(1), B => NX1);
I3: INV port map(A => sw_i(2), B => NX2);
I4: INV port map(A => sw_i(3), B => NX3);

U1: AND2 port map (A => NX3, B => sw_i(2), C => SU1);
U2: AND2 port map (A => sw_i(1), B => sw_i(0), C => SU2);
U3: AND2 port map (A => sw_i(3), B => NX2, C => SU3);
U4: AND2 port map (A => SU1, B => SU2, C => SU4);
U5: AND2 port map (A => SU3, B => NX0, C => SU5);
U6: AND2 port map (A => SU3, B => NX1, C => SU6);

U7: OR2 port map (A => SU4, B => SU5, C => SU7);
U8: OR2 port map (A => SU7, B => SU6, C => SU8);

--Вычисление y2
U9: AND2 port map (A => NX2, B => NX1, C => SU9);
U10: AND2 port map (A => NX2, B => sw_i(1), C => SU10);
U11: AND2 port map (A => SU9, B => sw_i(0), C => SU11);
U12: AND2 port map (A => SU10, B => NX0, C => SU12);

U13: OR2 port map (A => SU11, B => SU12, C => led_o(2));

led_o(0) <= '0';
led_o(1) <= SU8;
led_o(3) <= SU8;

end Structural;
