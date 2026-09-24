library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_counter is
    generic (
        N       : natural   := 8
    );
    port (
        CLK     : in    std_logic;                          -- System Clock, Rising Edge
        CLR     : in    std_logic;                          -- Asyncronous Clear, Active High
        EN      : in    std_logic;                          -- Enable, Active High
        MODE    : in    std_logic_vector(1 downto 0);       -- Mode Select ("11" - Rotate Right, others - Store)
        LOAD    : in    std_logic;                          -- Parallel Load Enable, Active High
        D_IN    : in    std_logic_vector(N - 1 downto 0);   -- Parallel Data Load
        D_OUT   : out   std_logic_vector(N - 1 downto 0)    -- Parallel Data Read
    );
end universal_counter;

architecture Behavioral of universal_counter is
    signal next_state, curr_state   :   std_logic_vector(N - 1 downto 0);
begin
    next_state <= curr_state(0) & curr_state(N - 1 downto 1);
    
    P0: process (CLK, CLR, EN, LOAD, MODE)
    begin
        if CLR = '1' then
            curr_state <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                if LOAD = '1' then
                    curr_state <= D_IN;
                elsif MODE = "11" then
                    curr_state <= next_state;
                end if;
            end if;
        end if;
    end process P0;
    
    D_OUT <= curr_state;
end Behavioral;