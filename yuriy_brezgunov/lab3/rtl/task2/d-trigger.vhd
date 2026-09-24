library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_trigger is
    port (
        sw  : in  std_logic_vector(15 downto 14);
        clk : in std_logic;
        led : out std_logic_vector(15 downto 15)
    );
end d_trigger;

architecture Behavioral of d_trigger is
    signal D, CLR_N, Q : std_logic;
begin
    D <= sw(15);
    CLR_N <= sw(14);

    P0: process(CLK, CLR_N)
    begin
        if (CLR_N = '0') then
            Q <= '0';
        elsif (rising_edge(CLK)) then
            Q <= D;
        end if;
    end process;
    
    led(15) <= Q;
end Behavioral;
