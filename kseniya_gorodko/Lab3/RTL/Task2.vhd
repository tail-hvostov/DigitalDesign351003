library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task2 is
-- sw_i(1) = d, sw_i(0) = clr_n
    port(
        sw_i: in std_logic_vector(1 downto 0);
        led_o: out std_logic_vector(0 to 0);
        clk: in std_logic
    );
end Task2;

architecture Behavioral of Task2 is
signal q: std_logic;
begin
    p: process(sw_i, clk)
    begin
        if sw_i(0) = '0' then
            q <= '0';
        elsif rising_edge(clk) then
            q <= sw_i(1);
        end if;
    end process p;
    led_o(0) <= q;
end Behavioral;
