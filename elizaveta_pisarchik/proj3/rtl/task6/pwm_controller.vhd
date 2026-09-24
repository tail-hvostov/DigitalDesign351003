library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity pwm_controller is
    generic ( CNT_WIDTH : natural := 8);
    port (
        CLK : in std_logic; --System Clock, Rising Edge
        CLR : in std_logic; -- Asyncronous reset, Active High
        EN : in std_logic; --Enable, Active High
        FILL : in std_logic_vector (CNT_WIDTH-1 downto 0); --Fill factor
        Q: out std_logic --PWM output signal
);
end pwm_controller;

architecture rtl of pwm_controller is
   signal counter : unsigned(CNT_WIDTH-1 downto 0) := (others => '0');
begin
    P0: process(CLK, CLR)
    begin
        if CLR = '1' then
            counter <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                counter <= counter + 1;
            end if;
        end if;
    end process;

    Q <= '1' when counter < unsigned(FILL) else '0';
end rtl;