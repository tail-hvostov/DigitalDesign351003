library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity freq_div_behav is
    generic (
        K   : natural   := 10
    );
    port (
        CLK : in    std_logic;  -- System Clock, Rising Edge
        RST : in    std_logic;  -- Syncronous Reset, Active High
        EN  : in    std_logic;  -- Enable, Active High
        Q   : out   std_logic   -- Divided Clock
    );
end freq_div_behav;

architecture Behavioral of freq_div_behav is
    signal store    : std_logic := '0';
begin
    P0: process (CLK)
        variable counter : integer range 0 to (K / 2) - 1 := 0;
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                counter := 0;
            elsif EN = '1' then
                if counter = (K / 2) - 1 then
                    counter := 0;
                    store   <= not store;
                else
                    counter := counter + 1;
                end if;
            end if;
        end if;
    end process P0;

    Q <= store;
end Behavioral;