----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2026 23:28:19
-- Design Name: 
-- Module Name: Task4Top - Behavioral
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

entity Task4Top is
    port(
        sw_in   : in  std_logic_vector(2 downto 0);
        led_out : out std_logic_vector(2 downto 0);
        btnL    : in  std_logic;
        btnR    : in  std_logic;
        CLK     : in  std_logic
    );
end Task4Top;

architecture Behavioral of Task4Top is

    component Task4Machine is
        generic(
            CLK_FREQ     : natural := 100_000_000;
            MAX_ERRORS   : natural := 3
        );
        port(
            CLK          : in  std_logic;
            RST          : in  std_logic;
            BTN          : in  std_logic_vector(2 downto 0);
            ADMIN_UNLOCK : in  std_logic;
            
            LED_GREEN    : out std_logic;
            LED_RED      : out std_logic;
            LED_BLUE     : out std_logic
        );
    end component;

begin

    U0 : Task4Machine
    port map(
        CLK => CLK, RST => btnL, BTN => sw_in, ADMIN_UNLOCK => btnR,
        LED_GREEN => led_out(2), LED_RED => led_out(1), LED_BLUE => led_out(0)
    );

end Behavioral;
