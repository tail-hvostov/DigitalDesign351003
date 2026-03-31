----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 11:32:52
-- Design Name: 
-- Module Name: DomFDCE - Behavioral
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

entity DomFDCE is
    port(
        CLK : in std_logic;
        D : in std_logic;
        CLR_N : in std_logic;
        Q : out std_logic
    );
end DomFDCE;

architecture Behavioral of DomFDCE is
    signal store : std_logic;
begin
    FDCE : process(D, CLK, CLR_N)
    begin
        if CLR_N = '0' then
            store <= '0';
        else
            if rising_edge(CLK) then
                store <= D;
            end if;
        end if;
    end process;

    Q <= store;
end Behavioral;
