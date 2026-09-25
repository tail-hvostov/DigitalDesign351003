----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2026 17:31:23
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Task3Top is
    port(
        sw_in   : in  std_logic_vector(0 to 11);
        led_out : out std_logic_vector(5 downto 0);
        btnL    : in  std_logic;
        CLK     : in  std_logic
    );
end Task3Top;

architecture Behavioral of Task3Top is

    component Task3Machine is
        generic(
            FLOOR_COUNT : natural := 4
        );
        port(
            CLK                : in  std_logic;
            RST                : in  std_logic;
            CALL               : in  std_logic_vector(1 to FLOOR_COUNT);
            FLOOR_SENSOR       : in  std_logic_vector(1 to FLOOR_COUNT);
            DOOR_OPEN_SENSOR   : in  std_logic;
            DOOR_CLOSED_SENSOR : in  std_logic;
            TIMEOUT            : in  std_logic;
            
            MOTOR_UP           : out std_logic;
            MOTOR_DOWN         : out std_logic;
            DOOR_OPEN_CMD      : out std_logic;
            DOOR_CLOSE_CMD     : out std_logic
        );
    end component;

begin

    U0 : Task3Machine
    port map(
        CLK => btnL, RST => sw_in(11), CALL => sw_in(7 to 10), FLOOR_SENSOR => sw_in(3 to 6), DOOR_OPEN_SENSOR => sw_in(2), DOOR_CLOSED_SENSOR => sw_in(1), TIMEOUT => sw_in(0),
        MOTOR_UP => led_out(3), MOTOR_DOWN => led_out(2), DOOR_OPEN_CMD => led_out(1), DOOR_CLOSE_CMD => led_out(0)
    );

end Behavioral;
