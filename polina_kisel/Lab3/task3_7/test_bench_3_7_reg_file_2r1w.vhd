library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_reg_file is
end tb_reg_file;

architecture sim of tb_reg_file is
    signal clk : std_logic := '0';
    signal clr, w_en : std_logic := '0';
    signal w_addr, r_addr_0, r_addr_1 : std_logic_vector(4 downto 0) := (others => '0');
    signal w_data, r_data_0, r_data_1 : std_logic_vector(15 downto 0) := (others => '0');
begin
    
    UUT: entity work.reg_file_2r1w 
        port map (
            clk=>clk, clr=>clr, w_en=>w_en, 
            w_addr=>w_addr, w_data=>w_data, 
            r_addr_0=>r_addr_0, r_data_0=>r_data_0, 
            r_addr_1=>r_addr_1, r_data_1=>r_data_1
        );

    -- ген-я такт сигнала (период 10 нс)
    clk <= not clk after 5 ns;

   PR1: process
    begin
        -- сброс
        clr <= '1'; 
        wait for 20 ns; 
        
        clr <= '0';
        wait for 10 ns;

        -- послед запись значений в несколько регистров
        w_en <= '1';
        w_addr <= "00001";
        w_data <= x"1111";
        wait for 10 ns; -- Пишем в рег 1
        
        w_addr <= "00010";
        w_data <= x"2222";
        wait for 10 ns; -- Пишем в рег 2
          
        w_addr <= "00011";
        w_data <= x"3333";
        wait for 10 ns; -- Пишем в рег 3
        
        w_en <= '0';
        wait for 10 ns;

        -- пслед чтение из разных регистров
        -- чит сразу двумя портами
        r_addr_0 <= "00001"; r_addr_1 <= "00010"; wait for 10 ns; -- в резе дб 1111 и 2222
        r_addr_0 <= "00011"; r_addr_1 <= "00000"; wait for 10 ns; -- в резе дб 3333 и 0000
        
        -- т и запись по одному и тому же адресу (проверка forwarding)
        w_en <= '1';
        w_addr <= "00100"; w_data <= x"ABCD"; -- Пишем в рег 4
        r_addr_0 <= "00100";                  -- И СРАЗУ ЖЕ читаем из рег 4 (до фронта CLK!)
        wait for 10 ns;                       -- На выходе r_data_0 должно мгновенно появиться ABCD
        w_en <= '0';
        wait for 10 ns;

        -- Одновр запись в рег и чтение из ДВУХ ДРУГИХ рег-ов
        w_en <= '1';
        w_addr <= "00101"; w_data <= x"9999"; -- Пишем в рег 5
        r_addr_0 <= "00001";                  -- Читаем рег 1 (там 1111)
        r_addr_1 <= "00010";                  -- Читаем рег 2 (там 2222)
        wait for 10 ns;
        w_en <= '0';
        wait for 10 ns;

        --  З при выключенном W_EN
        w_en <= '0';                          -- З ВЫКЛЮЧЕНА!
        w_addr <= "00001"; w_data <= x"FFFF"; -- Пытаемся перезаписать рег 1
        wait for 10 ns;
        
        -- Проверяем, что запись не удалась (читаем рег 1, там должно остаться 1111)
        r_addr_0 <= "00001"; 
        wait for 10 ns;

        -- Сброс и проверка обнуления всех регистров
        clr <= '1';                           -- Жмем сброс
        wait for 10 ns;
        clr <= '0';
        
        -- Везде должны быть 0.
        r_addr_0 <= "00001"; r_addr_1 <= "00010"; wait for 10 ns;
        r_addr_0 <= "00011"; r_addr_1 <= "00100"; wait for 10 ns;

        report "Simulation finished successfully!";
        wait;
    end process PR1;
end sim;