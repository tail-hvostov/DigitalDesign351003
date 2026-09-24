library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_controller is
    generic (
        CNT_WIDTH   : natural   := 8
    );
    port (
        CLK         : in    std_logic;                                  -- System Clock, Rising Edge
        CLR         : in    std_logic;                                  -- Asyncronous Clear, Active High
        EN          : in    std_logic;                                  -- Enable, Active High
        FILL        : in    std_logic_vector(CNT_WIDTH - 1 downto 0);   -- Fill Factor
        Q           : out   std_logic                                   -- PWM Output Signal
    );
end pwm_controller;

architecture Behavioral of pwm_controller is
    signal counter  : std_logic_vector(CNT_WIDTH - 1 downto 0);
begin
    P0: process (CLK, CLR, EN)
    begin
        if CLR = '1' then
            counter <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;
    end process P0;

    Q <= '1' when unsigned(counter) < unsigned(FILL) else
         '0';
end Behavioral;