library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_reg_file is
    generic (
        M: integer := 4;
        N: integer := 8;
        AW: integer := 2
    );
end TB_reg_file;

architecture Behavioral of TB_reg_file is
    constant clk_period: time := 10 ns;
    
    signal CLK: std_logic := '0';
    signal RST: std_logic := '0';
    signal WE: std_logic := '0';
    signal AddrW: std_logic_vector(AW-1 downto 0) := (others => '0');
    signal AddrR: std_logic_vector(AW-1 downto 0) := (others => '0');
    signal DataW: std_logic_vector(N-1 downto 0) := (others => '0');
    signal DataR: std_logic_vector(N-1 downto 0);
    
    -- Для проверки
    signal test_passed: boolean := true;
    
begin
    -- Генерация тактов
    CLK <= not CLK after clk_period/2;

    -- Тестируемый модуль
    UUT: entity work.reg_file
        generic map (
            M => M,
            N => N
        )
        port map (
            CLK   => CLK,
            RST   => RST,
            WE    => WE,
            AddrW => AddrW,
            AddrR => AddrR,
            DataW => DataW,
            DataR => DataR
        );

    -- Тестовый процесс
    TEST_PROCESS: process
    begin
        -- 1. Сброс
        RST <= '1';
        WE <= '0';
        wait for 20 ns;
        RST <= '0';
        wait for 20 ns;
        
        -- 2. Запись в регистр 0
        WE <= '1';
        AddrW <= "00";
        DataW <= x"AA";
        wait for clk_period;
        wait for 10 ns;
        
        -- 3. Чтение регистра 0
        WE <= '0';
        AddrR <= "00";
        wait for clk_period;
        wait for 10 ns;
        
        -- 4. Запись в регистр 1
        WE <= '1';
        AddrW <= "01";
        DataW <= x"55";
        wait for clk_period;
        wait for 10 ns;
        
        -- 5. Чтение регистра 1
        WE <= '0';
        AddrR <= "01";
        wait for clk_period;
        wait for 10 ns;
        
        -- 6. Чтение регистра 0 (проверка)
        AddrR <= "00";
        wait for clk_period;
        wait for 10 ns;
        
        -- 7. Запись в регистр 2
        WE <= '1';
        AddrW <= "10";
        DataW <= x"F0";
        wait for clk_period;
        wait for 10 ns;
        
        -- 8. Чтение регистра 2
        WE <= '0';
        AddrR <= "10";
        wait for clk_period;
        wait for 10 ns;
        
        -- 9. Запись в регистр 3
        WE <= '1';
        AddrW <= "11";
        DataW <= x"0F";
        wait for clk_period;
        wait for 10 ns;
        
        -- 10. Чтение регистра 3
        WE <= '0';
        AddrR <= "11";
        wait for clk_period;
        wait for 10 ns;
        
        -- 11. Сброс
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 10 ns;
        
        -- 12. Проверка после сброса
        AddrR <= "00";
        wait for clk_period;
        wait for 10 ns;
        
        AddrR <= "01";
        wait for clk_period;
        wait for 10 ns;
        
        AddrR <= "10";
        wait for clk_period;
        wait for 10 ns;
        
        AddrR <= "11";
        wait for clk_period;
        wait for 10 ns;
        
        -- Завершение
        report "=== Simulation completed ===" severity note;
        wait;
    end process;
end Behavioral;