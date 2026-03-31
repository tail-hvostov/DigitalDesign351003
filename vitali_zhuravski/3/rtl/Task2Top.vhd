----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 11:30:06
-- Design Name: 
-- Module Name: Task2Top - Behavioral
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

entity Task2Top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0);
        btnR : in std_logic
    );
end Task2Top;

architecture Behavioral of Task2Top is

    component DomFDCE is
        port(
            CLK : in std_logic;
            D : in std_logic;
            CLR_N : in std_logic;
            Q : out std_logic
        );
    end component;

begin
    led_out(15 downto 1) <= (others => '0');
    U0 : DomFDCE port map(CLK => btnR, D => sw_in(1), CLR_N => sw_in(0), Q => led_out(0));
end Behavioral;
