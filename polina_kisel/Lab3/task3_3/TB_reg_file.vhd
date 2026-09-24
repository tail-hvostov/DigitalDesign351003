library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_reg_file is
end TB_reg_file;

architecture Behavioral of TB_reg_file is
    constant M : integer := 4;
    constant N : integer := 8;
    constant clk_period : time := 10 ns;
    
    signal CLK  : std_logic := '0';
    signal RST  : std_logic := '0';
    signal WE   : std_logic := '0';
    signal AddrW: integer range 0 to M-1 := 0;
    signal AddrR: integer range 0 to M-1 := 0;
    signal DataW: std_logic_vector(N-1 downto 0) := (others => '0');
    signal DataR: std_logic_vector(N-1 downto 0);
    
    -- Для проверки ожидаемых значений
    signal expected : std_logic_vector(N-1 downto 0);
begin
 
    UUT: entity work.reg_file
        generic map (M => M, N => N)
        port map (
            CLK   => CLK,
            RST   => RST,
            WE    => WE,
            AddrW => AddrW,
            AddrR => AddrR,
            DataW => DataW,
            DataR => DataR
        );
    
    -- Генерация тактового сигнала
    CLK <= not CLK after clk_period/2;
    
    -- Тестовый процесс
    process
    begin
        -- Отчет о начале теста
        report "Starting Register File Test" severity note;
        
        -- 1. Сброс системы
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 20 ns;
        report "Reset completed" severity note;
        
        -- 2. Запись в регистр 0
        WE <= '1';
        AddrW <= 0;
        DataW <= x"AA";
        wait for clk_period;
        report "Written xAA to register 0" severity note;
        
        -- 3. Чтение из регистра 0
        WE <= '0';
        AddrR <= 0;
        wait for clk_period;
        assert DataR = x"AA" 
            report "ERROR: Register 0 = " & to_hstring(DataR) & " expected AA" 
            severity error;
      
        -- 4. Запись в регистр 1
        WE <= '1';
        AddrW <= 1;
        DataW <= x"55";
        wait for clk_period;
        report "Written x55 to register 1" severity note;
        
        -- 5. Чтение из регистра 1
        WE <= '0';
        AddrR <= 1;
        wait for clk_period;
        assert DataR = x"55" 
            report "ERROR: Register 1 = " & to_hstring(DataR) & " expected 55" 
            severity error;
    
        -- 6. Проверка, что регистр 0 не изменился
        AddrR <= 0;
        wait for clk_period;
        assert DataR = x"AA" 
            report "ERROR: Register 0 changed! = " & to_hstring(DataR) & " expected AA" 
            severity error;
        
        -- 7. Попытка записи при WE=0 (должна игнорироваться)
        WE <= '0';
        AddrW <= 2;
        DataW <= x"FF";
        wait for clk_period;
        report "Attempted write to register 2 with WE=0" severity note;
        
        -- 8. Чтение регистра 2 (должен быть 0)
        AddrR <= 2;
        wait for clk_period;
        assert DataR = x"00" 
            report "ERROR: Register 2 changed when WE=0! = " & to_hstring(DataR) 
            severity error;
       
        -- 9. Запись в регистр 2 с WE=1
        WE <= '1';
        AddrW <= 2;
        DataW <= x"F0";
        wait for clk_period;
        report "Written xF0 to register 2" severity note;
        
        -- 10. Чтение регистра 2
        WE <= '0';
        AddrR <= 2;
        wait for clk_period;
        assert DataR = x"F0" 
            report "ERROR: Register 2 = " & to_hstring(DataR) & " expected F0" 
            severity error;
      
        -- 11. Сброс во время работы
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 10 ns;
        report "Reset during operation" severity note;
        
        -- 12. Проверка, что все регистры обнулились
        AddrR <= 0;
        wait for clk_period;
        assert DataR = x"00" report "ERROR: Register 0 not reset" severity error;
        
        AddrR <= 1;
        wait for clk_period;
        assert DataR = x"00" report "ERROR: Register 1 not reset" severity error;
        
        AddrR <= 2;
        wait for clk_period;
        assert DataR = x"00" report "ERROR: Register 2 not reset" severity error;
        
        report "All registers reset to 0" severity note;
        
        -- 13. Запись после сброса
        WE <= '1';
        AddrW <= 0;
        DataW <= x"12";
        wait for clk_period;
        
        WE <= '0';
        AddrR <= 0;
        wait for clk_period;
        assert DataR = x"12" 
            report "ERROR: Register 0 = " & to_hstring(DataR) & " expected 12" 
            severity error;
      
        -- Завершение теста
        report "ALL TESTS COMPLETED" severity note;
        wait;
    end process;
end Behavioral;