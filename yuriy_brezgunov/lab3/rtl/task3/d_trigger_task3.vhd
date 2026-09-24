library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_trigger_comp is
    port (
        D : in std_logic;
        CLR_N : in std_logic;
        CLK : in std_logic;
        Q : out std_logic
    );
end d_trigger_comp;

architecture rtl of d_trigger_comp is

begin
    P0: process(CLK, CLR_N)
    begin
        if (CLR_N = '0') then
            Q <= '0';
        elsif (rising_edge(CLK)) then
            Q <= D;
        end if;
    end process;
end rtl;
