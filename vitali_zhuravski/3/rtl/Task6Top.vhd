----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2026 18:57:50
-- Design Name: 
-- Module Name: Task6Top - Behavioral
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

entity Task6Top is
    port(
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0);
        clk : in std_logic
    );
end Task6Top;

architecture Behavioral of Task6Top is
    component PwmController is
        generic(
            CNT_WIDTH : natural := 8
        );
        port(
            CLK : in std_logic;
            CLR : in std_logic;
            EN : in std_logic;
            FILL : in std_logic_vector(CNT_WIDTH - 1 downto 0);
            Q : out std_logic
        );
    end component;
    
    component FreqDivBehav is
        generic (
            K : natural := 10
        );
        port (
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;
    
    signal pwm_clk : std_logic;
begin
    U0 : FreqDivBehav
    generic map(K => 1500000)
    port map(CLK => clk, RST => '0', EN => '1', Q => pwm_clk);

    U1 : PwmController
    port map(CLK => pwm_clk, CLR => sw_in(9), EN => sw_in(8), FILL => sw_in(7 downto 0), Q => led_out(0));
    
    led_out(15 downto 1) <= (others => '0');
end Behavioral;
