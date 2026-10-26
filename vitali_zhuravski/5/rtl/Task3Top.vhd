----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2026 23:19:24
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
        sw_in   : in  std_logic_vector(1 downto 0);
        btnL    : in  std_logic;
        btnR    : in  std_logic;
        led_out : out std_logic_vector(3 downto 0)
    );
end Task3Top;

architecture Behavioral of Task3Top is

    component Task3Machine is
        generic(
            ADDR_LENGTH : natural := 4;
            ROM : std_logic_vector :=
                X"0" & X"F" & X"1" &
                X"1" & X"0" & X"2" &
                X"2" & X"1" & X"3" &
                X"3" & X"2" & X"4" &
                X"4" & X"3" & X"5" &
                X"5" & X"4" & X"6" &
                X"6" & X"5" & X"7" &
                X"7" & X"6" & X"8" &
                X"8" & X"7" & X"9" &
                X"9" & X"8" & X"A" &
                X"A" & X"9" & X"B" &
                X"B" & X"A" & X"C" &
                X"C" & X"B" & X"D" &
                X"D" & X"C" & X"E" &
                X"E" & X"D" & X"F" &
                X"F" & X"E" & X"0"
        );
        port(
            CLK : in  std_logic;
            CLR : in  std_logic;
            CE  : in  std_logic;
            X   : in  std_logic;
            DO  : out std_logic_vector(ADDR_LENGTH - 1 downto 0)
        );
    end component;

begin

    U0 : Task3Machine
    port map(CLK => btnL, CLR => btnR, CE => sw_in(1), X => sw_in(0), DO => led_out);

end Behavioral;
