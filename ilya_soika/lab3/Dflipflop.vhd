library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity myFDCE is
    Port (
        CLR_N: in std_logic;
        CLK: in std_logic;
        D: in std_logic;
        Q: out std_logic
    );
end myFDCE;

architecture Behavioral of myFDCE is
begin
    U: process(CLK, CLR_N)
    begin
        if CLR_N = '0' then 
            Q <= '0';
        elsif rising_edge(CLK) then 
            Q <= D;
        end if;
    end process;
end Behavioral;
