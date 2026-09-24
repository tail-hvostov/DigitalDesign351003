library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF_Async_Reset is
    Port ( 
        D     : in  std_logic;
        CLK   : in  std_logic;
        CLR_N : in  std_logic; 
        Q     : out std_logic
    );
end DFF_Async_Reset;

architecture Behavioral of DFF_Async_Reset is
begin
    process(CLK, CLR_N)
    begin
        if CLR_N = '0' then
            Q <= '0'; -- Асинхр сброс важнее всего
        elsif rising_edge(CLK) then
            Q <= D;  
        end if;
    end process;
end Behavioral;