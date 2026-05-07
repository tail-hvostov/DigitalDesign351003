----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2026 01:19:04
-- Design Name: 
-- Module Name: Task1Top - Behavioral
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

entity Task1Top is
    port(
        sw_in   : in  std_logic_vector(0 downto 0);
        led_out : out std_logic_vector(3 downto 0);
        btnL    : in  std_logic;
        btnR    : in  std_logic
    );
end Task1Top;

architecture Behavioral of Task1Top is
    component Task1Machine is
        port(
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic_vector(3 downto 0)
        );
    end component;
begin
    U0 : Task1Machine
    port map(CLK => btnL, RST => btnR, EN => sw_in(0), Q => led_out);
end Behavioral;
