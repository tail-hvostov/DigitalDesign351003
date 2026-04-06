----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2026 03:45:14
-- Design Name: 
-- Module Name: Task5Top - Behavioral
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

entity Task5Top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0);
        btnR : in std_logic
    );
end Task5Top;

architecture Behavioral of Task5Top is
    component UniversalShiftRegister is
        generic (
            N : natural := 8
        );
        port(
            CLK  : in std_logic;
            CLR  : in std_logic;
            EN   : in std_logic;
            MODE : in std_logic_vector(1 downto 0);
            LOAD : in std_logic;
            Din  : in std_logic_vector(N - 1 downto 0);
            Dout : out std_logic_vector(N - 1 downto 0)
        );
    end component;
begin
    U0 : UniversalShiftRegister
    port map(CLK => btnR, CLR => sw_in(12), EN => sw_in(11), MODE => sw_in(10 downto 9), LOAD => sw_in(8), Din => sw_in(7 downto 0), Dout => led_out(7 downto 0));

    led_out(15 downto 8) <= (others => '0');
end Behavioral;
