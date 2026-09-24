library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_universal_counter is
end tb_universal_counter;

architecture sim of tb_universal_counter is
    constant N : integer := 8;
    signal clk, clr, en : std_logic := '0';
    signal mode : std_logic_vector(1 downto 0) := "11";
    signal din  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal dout : std_logic_vector(N-1 downto 0);
    
    -- Твой тестовый вектор
    constant VEC : std_logic_vector(0 to 59) := "101101011100101011101100101101001101010101101100101101110010";
begin
    UUT: entity work.universal_counter 
        generic map (N => N) 
        port map (clk, clr, en, mode, din, dout);

    clk <= not clk after 5 ns; 

    process
    begin
        -- Сброс
        clr <= '1'; 
        wait for 20 ns;
        clr <= '0';
         en <= '1';
        
        report "--- STARTING COMPRESSION ---";
        mode <= "00"; -- Включ сжатие

        -- Подача вектора
        for i in 0 to 59 loop
            din(0) <= VEC(i);
            wait until rising_edge(clk);
        end loop;

        mode <= "11"; -- Стоп
        wait for 20 ns;
        
        -- Простая проверка
        assert (dout /= x"00") 
        report "Signature is generated!" 
        severity note;
        
        wait;
    end process;
end sim;