library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task5 is
    generic(n: natural := 10);
    port(
        clk:    in  std_logic;                          -- system clock, rising edge
        clr:    in  std_logic;                          -- async reset, active high
        en:     in  std_logic;                          -- enable, active high
        mode:   in  std_logic_vector(1 downto 0);       -- mode select
        load:   in  std_logic;                          -- parallel load enable
        din:    in  std_logic_vector(n - 1 downto 0);   -- parallel load data
        dout:   out std_logic_vector(n - 1 downto 0)    -- parallel data read
    );
end Task5;

architecture Behavioral of Task5 is
-- Линейный регистр сдвига с обратной связью (LFSR) по схеме Фибоначчи
-- Полином: x^10 + x^7 + 1
-- mode = "00" - Генерация псевдослучайной последовательности
-- mode = "01" - Параллельная загрузка
signal current_state: std_logic_vector(n - 1 downto 0);
begin
    p: process(clk, clr, en)
    variable new_value: std_logic;
    begin
        if clr = '1' then
            current_state <= (others => '0');
        elsif en = '1' and rising_edge(clk) then
            if mode = "00" then
                new_value := current_state(9) xor current_state(6);
                current_state <= current_state(8 downto 0) & new_value;
            elsif mode = "01" and load = '1' then
                current_state <= din;
            end if;
        end if;
    end process p;
    dout <= current_state;
end Behavioral;
