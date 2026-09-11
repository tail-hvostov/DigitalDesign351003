----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2026 03:17:13
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
        led_out : out std_logic_vector(5 downto 0);
        btnL    : in  std_logic;
        btnR    : in  std_logic;
        CLK     : in  std_logic
    );
end Task2Top;

architecture Behavioral of Task2Top is

    
    component Task2Machine is
        generic(
            CLK_FREQ    : natural := 100_000_000
        );
        port(
            CLK         : in  std_logic;
            RST         : in  std_logic;
            MODE        : in  std_logic;
            CAR_SENSOR  : in  std_logic;
            MANUAL_NEXT : in  std_logic;
            MAIN_RED    : out std_logic;
            MAIN_YELLOW : out std_logic;
            MAIN_GREEN  : out std_logic;
            SEC_RED     : out std_logic;
            SEC_YELLOW  : out std_logic;
            SEC_GREEN   : out std_logic
        );
    end component;

begin

    U0 : Task2Machine
    port map(CLK => CLK, RST => btnR, MODE => sw_in(0), CAR_SENSOR => sw_in(1), MANUAL_NEXT => btnL,
                MAIN_RED => led_out(5), MAIN_YELLOW => led_out(4), MAIN_GREEN => led_out(3),
                SEC_RED => led_out(2), SEC_YELLOW => led_out(1), SEC_GREEN => led_out(0));

end Behavioral;
