library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity pwm_controller is
    generic (CNT_WIDTH: natural := 8);
    port (
        CLK: in std_logic;
        CLR: in std_logic;
        EN: in std_logic;
        FILL: in std_logic_vector(CNT_WIDTH-1 downto 0);
        Q: out std_logic
    );
end pwm_controller;

architecture Behavioral of pwm_controller is
    signal counter : unsigned(CNT_WIDTH-1 downto 0) := (others => '0');
begin
    process(CLK, CLR)
    begin
        if CLR = '1' then
            counter <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                counter <= counter + 1;
            end if;
        end if;
    end process;
    process(counter, FILL)
    begin
        if unsigned(FILL) = 0 then
            Q <= '0';
        elsif counter < unsigned(FILL) then
            Q <= '1';
        else
            Q <= '0';
        end if;
    end process;
end Behavioral;
