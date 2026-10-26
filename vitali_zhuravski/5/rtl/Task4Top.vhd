----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2026 00:40:33
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
        sw_in   : in  std_logic_vector(1 downto 0);
        btnL    : in  std_logic;
        btnR    : in  std_logic;
        led_out : out std_logic_vector(3 downto 0)
    );
end Task4Top;

architecture Behavioral of Task4Top is

    component Task4Machine is
        generic(
            ADDR_LENGTH : natural := 4;
            ROM : std_logic_vector :=
                "1" & X"0" & X"F" & X"1" &
                "1" & X"0" & X"0" & X"2" &
                "1" & X"2" & X"1" & X"3" &
                "1" & X"2" & X"2" & X"4" &
                "1" & X"2" & X"3" & X"5" &
                "1" & X"5" & X"4" & X"6" &
                "1" & X"5" & X"5" & X"7" &
                "1" & X"5" & X"6" & X"8" &
                "1" & X"5" & X"7" & X"9" &
                "1" & X"9" & X"8" & X"A" &
                "1" & X"9" & X"9" & X"B" &
                "1" & X"9" & X"A" & X"C" &
                "1" & X"9" & X"B" & X"D" &
                "1" & X"9" & X"C" & X"E" &
                "1" & X"9" & X"D" & X"F" &
                "0" & X"F" & X"E" & X"0"
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

    U0 : Task4Machine
    port map(CLK => btnL, CLR => btnR, CE => sw_in(1), X => sw_in(0), DO => led_out);

end Behavioral;
