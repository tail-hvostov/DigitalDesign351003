----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2026 18:12:25
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

entity task3 is
port (
sw_i  :in std_logic_vector (3 downto 0);
led_o   :out std_logic_vector (3 downto 0)
);
end task3;

architecture Behavioral of task3 is
signal NX1l, NX2l, NX3l, NX0l, SU1l, SU2l, SU3l, SU4l, SU5l, SU6l, SU7l, SU8l, SU9l, SU10l, SU11l, SU12l, SU13l: std_logic;
signal NX1r, NX2r, NX3r, NX0r, SU1r, SU2r, SU3r, SU4r, SU5r, SU6r, SU7r, SU8r, SU9r, SU10r, SU11r, SU12r, SU13r: std_logic;
component AND2_ndelay port (A: in std_logic; B: in std_logic; C: out std_logic);
end component;
component OR2_ndelay port (A: in std_logic; B: in std_logic; C: out std_logic);
end component;
component INV_ndelay port (A: in std_logic; B: out std_logic);
end component;
component interconnect port (A : in std_logic; B: out std_logic);
end component;
begin
--Вычисление y3 и y1
I1: INV_ndelay port map(A => sw_i(0), B => NX0l);
I2: INV_ndelay port map(A => sw_i(1), B => NX1l);
I3: INV_ndelay port map(A => sw_i(2), B => NX2l);
I4: INV_ndelay port map(A => sw_i(3), B => NX3l);
    --соединительные провода после инвертеров
IC1: interconnect port map (A => NX0l, B => NX0r);
IC2: interconnect port map (A => NX1l, B => NX1r);
IC3: interconnect port map (A => NX2l, B => NX2r);
IC4: interconnect port map (A => NX3l, B => NX3r);
            
U1: AND2_ndelay port map (A => NX3r, B => sw_i(2), C => SU1l);
U2: AND2_ndelay port map (A => sw_i(1), B => sw_i(0), C => SU2l);
U3: AND2_ndelay port map (A => sw_i(3), B => NX2r, C => SU3l);

    --соединительные провода между and
IC5: interconnect port map (A => SU1l, B => SU1r);
IC6: interconnect port map (A => SU2l, B => SU2r);
IC7: interconnect port map (A => SU3l, B => SU3r);

U4: AND2_ndelay port map (A => SU1r, B => SU2r, C => SU4l);
U5: AND2_ndelay port map (A => SU3r, B => NX0r, C => SU5l);
U6: AND2_ndelay port map (A => SU3r, B => NX1r, C => SU6l);

    --соединительные провода между and
IC8: interconnect port map (A => SU4l, B => SU4r);
IC9: interconnect port map (A => SU5l, B => SU5r);
IC10: interconnect port map (A => SU6l, B => SU6r);

U7: OR2_ndelay port map (A => SU4r, B => SU5r, C => SU7l);
U8: OR2_ndelay port map (A => SU7r, B => SU6r, C => SU8l);

    --соединительные провода между or
IC11: interconnect port map (A => SU7l, B => SU7r);
IC12: interconnect port map (A => SU8l, B => SU8r);  


--Вычисление y2
U9: AND2_ndelay port map (A => NX2r, B => NX1r, C => SU9l);
U10: AND2_ndelay port map (A => NX2r, B => sw_i(1), C => SU10l);
U11: AND2_ndelay port map (A => SU9r, B => sw_i(0), C => SU11l);
U12: AND2_ndelay port map (A => SU10r, B => NX0r, C => SU12l);

    --соединительные провода между and
IC13: interconnect port map (A => SU9l, B => SU9r);
IC14: interconnect port map (A => SU10l, B => SU10r);
IC15: interconnect port map (A => SU11l, B => SU11r);
IC16: interconnect port map (A => SU12l, B => SU12r);

U13: OR2_ndelay port map (A => SU11r, B => SU12r, C => SU13l);
    --соединительный провод между or
IC17: interconnect port map (A => SU13l, B => SU13r);

led_o(0) <= '0';
led_o(1) <= SU8r;
led_o(2) <= SU13r;
led_o(3) <= SU8r;


end Behavioral;
