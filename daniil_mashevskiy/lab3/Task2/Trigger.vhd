library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Trigger is
    port (
        CLR_N : in  std_logic;
        CLK   : in  std_logic;
        D     : in  std_logic;
        Q     : out std_logic
    );
end Trigger;

architecture Behavioral of Trigger is
begin
    process(CLK, CLR_N)
    begin
        if (CLR_N = '0') then
            Q <= '0';
        elsif (rising_edge(CLK)) then
            Q <= D;
        end if;
    end process;
end Behavioral;