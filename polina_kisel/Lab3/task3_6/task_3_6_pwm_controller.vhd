library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_controller is
    Generic ( CNT_WIDTH : natural := 8 ); -- Разрядность счетчика 8 бит (число 0 до 255)
    Port (
        CLK  : in  std_logic; -- Тактовый сигнал
        CLR  : in  std_logic; -- Асинхронный сброс
        EN   : in  std_logic; -- Разрешение работы
        FILL : in  std_logic_vector (CNT_WIDTH-1 downto 0); -- Коэф. заполнения (fILL имеет размер 8 бит (от 7 до 0))
        Q    : out std_logic  -- Выход ШИМ
    );
end pwm_controller;

architecture Behavioral of pwm_controller is
    signal counter : unsigned(CNT_WIDTH-1 downto 0) := (others => '0');
begin

    process(CLK, CLR)
    begin
        if CLR = '1' then -- Асинхронный сброс
            counter <= (others => '0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                counter <= counter + 1; -- Модулярный счет (до 255 и  в ноль и тд)
            end if;
        end if;
    end process;

    -- Компаратор для формирования Q
    Q <= '1' when (counter < unsigned(FILL)) else '0';
end Behavioral;