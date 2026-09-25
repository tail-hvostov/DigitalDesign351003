----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 01:56:19
-- Design Name: 
-- Module Name: comparator - Structural
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
entity comparator is
port(
gin, ein : in std_logic;
x, y: in std_logic;
gout, eout : out std_logic
);
end comparator;

architecture Structural of comparator is
signal NX, NY, SU1, SU2, SU3, SU4, SU5, SU6, SU7, SU8, SU9, SU10, SU11, SU12: std_logic;
component AND2_ndelay port (A: in std_logic; B: in std_logic; C: out std_logic);
end component;
component OR2_ndelay port (A: in std_logic; B: in std_logic; C: out std_logic);
end component;
component INV_ndelay port (A: in std_logic; B: out std_logic);
end component;
begin
Ix : INV_ndelay port map (A => x, B => NX);
Iy : INV_ndelay port map (A => y, B => NY);

U1: AND2_ndelay port map (A => ein, B => x, C => SU1);
U2: AND2_ndelay port map (A => SU1, B => NY, C => SU2);

U3: AND2_ndelay port map (A => gin, B => ein, C => SU3);
U4: AND2_ndelay port map (A => ein, B => NX, C => SU4);
U5: AND2_ndelay port map (A => SU4, B => NY, C => SU5);
U6: AND2_ndelay port map (A => x, B => ein, C => SU6);
U7: AND2_ndelay port map (A => SU6, B => y, C => SU7);

U8: OR2_ndelay port map (A => gin, B => SU2, C => gout);
U9: OR2_ndelay port map (A => SU3, B => SU5, C => SU9);
U10: OR2_ndelay port map (A => SU9, B => SU7, C => eout);
end Structural;
