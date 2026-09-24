library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4 is
    generic(k: natural := 10);
    port(
        clk: in std_logic;  -- rising edge
        rst: in std_logic;  -- sync, active high
        en: in std_logic;   -- enable, active high
        q: out std_logic    -- divided clock
    );
end Task4;

architecture Behavioral of Task4 is
signal output: std_logic := '0';
begin
    p: process(clk, rst, en)
    variable counter: integer range 0 to k / 2 - 1 := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter := 0;    
            elsif en = '1' then
                if counter = k / 2 - 1 then
                    output <= not output;
                    counter := 0;
                else
                    counter := counter + 1;
                end if;
            end if;
        end if;
    end process p;
    q <= output;
end Behavioral;
