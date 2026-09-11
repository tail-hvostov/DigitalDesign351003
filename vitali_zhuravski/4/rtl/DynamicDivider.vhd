----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2026 00:17:07
-- Design Name: 
-- Module Name: DynamicDivider - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DynamicDivider is
    generic(
        N : natural range 2 to 20
    );
    port(
        LIMIT : in  std_logic_vector(N - 1 downto 0);
        CLK   : in  std_logic;
        EN    : in  std_logic;
        CLR   : in  std_logic;
        Q     : out std_logic
    );
end DynamicDivider;

architecture Behavioral of DynamicDivider is
    signal cur_max : std_logic_vector(LIMIT'range);
    signal store : std_logic_vector(LIMIT'range);
    signal next_store : std_logic_vector(LIMIT'range);
begin
    cur_max <= std_logic_vector(unsigned(LIMIT) - 1);
    Q <= '1' when (cur_max = store) else '0';
    next_store <= std_logic_vector(1 + unsigned(store));
    
    process(CLK, CLR)
    begin
        if CLR = '1' then
            store <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                if store = cur_max then
                    store <= (others => '0');
                else
                    store <= next_store;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
