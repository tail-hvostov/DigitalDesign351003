----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.09.2026 14:04:35
-- Design Name: 
-- Module Name: OddDivider - Behavioral
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

entity OddDivider is
    generic(
        ODD : natural
    );
    port(
        CLK : in  std_logic;
        CLR : in  std_logic;
        EN  : in  std_logic;
        Q   : out std_logic
    );
end OddDivider;

architecture Behavioral of OddDivider is
    constant MAX_VAL : natural := ODD - 1;
    signal store : natural range 0 to MAX_VAL;
begin
    Q <= '1' when (store = MAX_VAL) else '0';
    
    process(CLK, CLR)
    begin
        if CLR = '1' then
            store <= 0;
        elsif rising_edge(CLK) then
            if EN = '1' then
                store <= store + 1;
            end if;
        end if;
    end process;

end Behavioral;
