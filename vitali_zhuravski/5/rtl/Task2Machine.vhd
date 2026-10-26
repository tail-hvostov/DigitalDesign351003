----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2026 17:49:08
-- Design Name: 
-- Module Name: Task2Machine - Behavioral
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

entity Task2Machine is
    port(
        CLK : in  std_logic;
        CLR : in  std_logic;
        CE  : in  std_logic;
        DIR : in  std_logic;
        DO  : out std_logic_vector(3 downto 0)
    );
end Task2Machine;

architecture Behavioral of Task2Machine is
    constant COMMAND_COUNT : natural := 16;
    subtype command is std_logic_vector(3 downto 0);
    type command_rom is array(0 to COMMAND_COUNT - 1) of command;
    
    constant commands : command_rom := (
        0  => "0000",
        1  => "0001",
        2  => "0011",
        3  => "0010",
        4  => "0110",
        5  => "0111",
        6  => "0101",
        7  => "0100",
        8  => "1100",
        9  => "1101",
        10 => "1111",
        11 => "1110",
        12 => "1010",
        13 => "1011",
        14 => "1001",
        15 => "1000"
    );
    
    signal command_counter : natural range 0 to COMMAND_COUNT - 1;
    signal next_command_counter : natural range 0 to COMMAND_COUNT - 1;
begin
    process(DIR, command_counter)
    begin
        if DIR = '0' then
            if command_counter = 0 then
                next_command_counter <= COMMAND_COUNT - 1;
            else
                next_command_counter <= command_counter - 1;
            end if;
        else
            if command_counter = COMMAND_COUNT - 1 then
                next_command_counter <= 0;
            else
                next_command_counter <= command_counter + 1;
            end if;
        end if;
    end process;

    process(CLK, CLR)
    begin
        if CLR = '1' then
            command_counter <= 0;
        elsif rising_edge(CLK) and (CE = '1') then
            command_counter <= next_command_counter;
        end if;
    end process;
    
    DO <= commands(command_counter);
end Behavioral;
