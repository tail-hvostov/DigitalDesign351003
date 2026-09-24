library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF is
    port (
        D       : in    std_logic;  -- Input Data
        CLK     : in    std_logic;  -- System Clock, Rising Edge
        CLR_N   : in    std_logic;  -- Asynchronous Clear, Active Low 
        Q       : out   std_logic   -- Output Data
    );
end DFF;

architecture Behavioral of DFF is
    signal store    :   std_logic;
begin
    P0: process (CLR_N, CLK)
    begin
        if CLR_N = '0' then
            store <= '0';
        elsif rising_edge(CLK) then
            store <= D;
        end if;
    end process P0;
    
    Q <= store;
end Behavioral;