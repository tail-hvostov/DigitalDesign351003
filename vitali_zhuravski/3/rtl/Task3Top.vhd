----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2026 16:27:22
-- Design Name: 
-- Module Name: Task3Top - Behavioral
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
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Task3Top is
    port(
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0);
        clk : in std_logic
    );
end Task3Top;

-- ????????? ? constraints4.
architecture Behavioral of Task3Top is
    component RegFile is
        generic(
            N : natural := 6;
            M : natural := 4
        );
        port(
            CLK     : in  std_logic;
            
            RST     : in  std_logic;
            WE      : in  std_logic;
            WD      : in  std_logic_vector(N-1 downto 0);
            WAddr   : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            
            RD      : out std_logic_vector(N-1 downto 0);
            RAddr   : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0)
        );
    end component;
begin
    led_out(15 downto 6) <= (others => '0');

    U0 : RegFile
    port map(CLK => clk,
             RST => sw_in(11),
             WE => sw_in(10),
             WD => sw_in(9 downto 4),
             WAddr => sw_in(3 downto 2),
             RD => led_out(5 downto 0),
             RAddr => sw_in(1 downto 0)
    );

end Behavioral;
