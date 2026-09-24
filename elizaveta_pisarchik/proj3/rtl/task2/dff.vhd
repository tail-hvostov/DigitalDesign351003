library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF is
    port (
        D     : in  std_logic;
        CLK   : in  std_logic;
        CLR_N : in  std_logic;
        Q     : out std_logic
    );
end DFF;

architecture rtl of DFF is
signal store : std_logic := '0';
begin
    P0: process (CLK, CLR_N)
    begin
        if (CLR_N = '0') then
            store <= '0';
        elsif rising_edge(CLK) then
            store <= D;
        end if;
    end process P0;
    Q <= store;
end rtl;