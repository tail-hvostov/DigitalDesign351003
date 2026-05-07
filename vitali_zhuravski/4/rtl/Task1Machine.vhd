----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2026 01:27:05
-- Design Name: 
-- Module Name: Task1Machine - Behavioral
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

entity Task1Machine is
    port(
        CLK : in  std_logic;
        RST : in  std_logic;
        EN  : in  std_logic;
        Q   : out std_logic_vector(3 downto 0)
    );
end Task1Machine;

--States:
--A ? B ? E ? B ? F ? C ? F ? D ? A

architecture Behavioral of Task1Machine is
    constant LOW_STATE : natural := 1;
    constant HIGH_STATE : natural := 9;

    signal cur_state : natural range LOW_STATE to HIGH_STATE;
    
    type letter_map is array (LOW_STATE to HIGH_STATE) of std_logic_vector(3 downto 0);
    constant state_letters : letter_map := (
        1 => X"A",
        2 => X"B",
        3 => X"E",
        4 => X"B",
        5 => X"F",
        6 => X"C",
        7 => X"F",
        8 => X"D",
        9 => X"A"
    );
begin
    Q <= state_letters(cur_state);
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                cur_state <= LOW_STATE;
            elsif EN = '1' and (cur_state < HIGH_STATE) then
                cur_state <= 1 + cur_state;
            end if;
        end if;
    end process;
end Behavioral;
