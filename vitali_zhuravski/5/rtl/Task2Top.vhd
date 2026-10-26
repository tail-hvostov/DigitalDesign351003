----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2026 18:01:42
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
    port(
        sw_in   : in  std_logic_vector(1 downto 0);
        btnL    : in  std_logic;
        btnR    : in  std_logic;
        led_out : out std_logic_vector(3 downto 0)
    );
end Task2Top;

architecture Behavioral of Task2Top is

    component Task2Machine is
        port(
            CLK : in  std_logic;
            CLR : in  std_logic;
            CE  : in  std_logic;
            DIR : in  std_logic;
            DO  : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    U0 : Task2Machine
    port map(CLK => btnL, CLR => btnR, CE => sw_in(0), DIR => sw_in(1), DO => led_out);

end Behavioral;
