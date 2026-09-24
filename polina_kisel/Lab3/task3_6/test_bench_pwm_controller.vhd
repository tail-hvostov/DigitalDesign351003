library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_pwm is
end tb_pwm;

architecture sim of tb_pwm is
    signal clk, clr, en, q : std_logic := '0';
    signal fill : std_logic_vector(7 downto 0) := (others => '0');
begin
    -- ѕодключение модул€
    UUT: entity work.pwm_controller 
    port map(
            clk=>clk,
            clr=>clr,
            en=>en,
            fill=>fill,
             q=>q);

    -- √енераци€ частоты
    clk <= not clk after 5 ns;

    process
    begin
        --  сброс
        clr <= '1'; 
        wait for 20 ns; 
        clr <= '0';
        en <= '1';
        
        -- фул цикл счетчика (от 0 до 255) = 256 * 10 ns = 2560 ns.
        -- след ждем по 3000 ns, чтобы увидеть минимум один полный цикл шим

        -- –абота при (0, 25, 50, 75, 100%)
        fill <= x"00"; 
        wait for 3000 ns; -- 0% €ркости (Q всегда 0)
        
        
        clr <= '0';
        en <= '1';
        fill <= x"40"; 
        wait for 23000 ns; -- 25% €ркости (64 из 256)

         clr <= '0';
        en <= '1';
        fill <= x"80";
         wait for 23000 ns; -- 50% €ркости (128 из 256)
          --  сброс
      
        clr <= '0';
          en <= '1';
        fill <= x"C0";
         wait for 23000 ns; -- 75% €ркости (192 из 256)


               clr <= '0';
               en <= '1';
        fill <= x"FF";
         wait for 23000 ns; -- 100% €ркости (почти всегда 1)
        
        -- изм-е коэффициента пр€мо во врем€ работы
        fill <= x"40"; 
         wait for 1000 ns; -- ¬ключили 25% и подождали полцикла
        fill <= x"C0";
         wait for 23000 ns; -- –езко переключили на 75%
        
        -- ќтключение модул€ сигналом EN
        en <= '0'; 
        wait for 23000 ns; -- —четчик должен замереть, Ў»ћ остановитс€
        
        report "Simulation finished successfully!";
        wait;
    end process;
end sim;