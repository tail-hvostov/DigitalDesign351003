library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task6 is
    generic(cnt_width: natural := 8);
    port(
        clk:    in  std_logic;
        clr:    in  std_logic;
        en:     in  std_logic;
        fill:   in  std_logic_vector(cnt_width - 1 downto 0);
        q:      out std_logic
    );
end Task6;

architecture Behavioral of Task6 is
begin
    p: process(clk, clr, en)
    variable count: integer range 0 to 2 ** cnt_width := 0;
    begin
        if en = '1' then
            if clr = '1' then
                count := 0;
            elsif rising_edge(clk) then
                if count < to_integer(unsigned(fill)) then
                    q <= '1';
                else
                    q <= '0';
                end if;
                count := (count + 1) mod (2 ** cnt_width);
            end if;
        end if;
    end process p;
end Behavioral;
