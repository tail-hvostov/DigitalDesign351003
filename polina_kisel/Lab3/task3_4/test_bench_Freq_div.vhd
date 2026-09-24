library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity tb_freq_div is
End tb_freq_div;

Architecture sim of tb_freq_div is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal en  : std_logic := '0';
    signal q_10   : std_logic;
    signal q_4   : std_logic;
    signal q_100   : std_logic;

Begin

    -- Тест с K=4. Cсмена Q каждые 2 тактов (20 нс)
    UUT: entity work.freq_div_behav 
        generic map ( K => 4 ) 
        port map ( clk, rst, en, q_4 );

    clk <= not clk after 5 ns;

    Sim: process
    begin
        -- Сброс
        rst <= '1'; 
        wait for 20 ns;
        assert (q_4 = '0') 
        report "FAIL: Q must be 0 on Reset" 
        severity error;
        
        rst <= '0'; 
        en <= '1';
        
        -- 1-е преключенипе (через 5 тактов = 50 нс) Ждем чуть больше 5 тактов от момента снятия RST
        wait for 51 ns; 
        assert (q_4 = '1') 
        report "FAIL: Q did not switch to '1' after K/2 cycles" 
        severity error;
        
        -- 2-е преключение (еще через 50 нс)
        wait for 50 ns;
        assert (q_4 = '0') 
        report "FAIL: Q did not switch back to '0'" 
        severity error;
        
        -- пауза(EN=0)
        en <= '0';
        wait for 100 ns; 
        assert (q_4 = '0') 
        report "FAIL: Q changed while EN = '0'" 
        severity error;
        
        en <= '1';
        wait for 200 ns;

        report "--- SUCCESS: freq_div_behav tests passed! ---" 
        severity note;
        wait; 
    end process Sim;
    
     -- Тест с K=10. Cсмена Q каждые 5 тактов (50 нс)
       UUT1: entity work.freq_div_behav 
           generic map ( K => 10 ) 
           port map ( clk, rst, en, q_10 );
   
       clk <= not clk after 5 ns;
   
       Sim1: process
       begin
           -- Сброс
           rst <= '1'; 
           wait for 20 ns;
           assert (q_10 = '0') 
           report "FAIL: Q must be 0 on Reset" 
           severity error;
           
           rst <= '0'; 
           en <= '1';
           
           -- 1-е преключенипе (через 5 тактов = 50 нс) Ждем чуть больше 5 тактов от момента снятия RST
           wait for 51 ns; 
           assert (q_10 = '1') 
           report "FAIL: Q did not switch to '1' after K/2 cycles" 
           severity error;
           
           -- 2-е преключение (еще через 50 нс)
           wait for 50 ns;
           assert (q_10 = '0') 
           report "FAIL: Q did not switch back to '0'" 
           severity error;
           
           -- пауза(EN=0)
           en <= '0';
           wait for 100 ns; 
           assert (q_10 = '0') 
           report "FAIL: Q changed while EN = '0'" 
           severity error;
           
           en <= '1';
           wait for 200 ns;
   
           report "--- SUCCESS: freq_div_behav tests passed! ---" 
           severity note;
           wait; 
       end process Sim1;
       
        -- Тест с K=100. Cсмена Q каждые 50 тактов (500 нс)
          UUT2: entity work.freq_div_behav 
              generic map ( K => 100 ) 
              port map ( clk, rst, en, q_100 );
      
          clk <= not clk after 5 ns;
      
          Sim2: process
          begin
              -- Сброс
              rst <= '1'; 
              wait for 20 ns;
              assert (q_100 = '0') 
              report "FAIL: Q must be 0 on Reset" 
              severity error;
              
              rst <= '0'; 
              en <= '1';
              
              -- 1-е преключенипе (через 5 тактов = 50 нс) Ждем чуть больше 5 тактов от момента снятия RST
              wait for 51 ns; 
              assert (q_100 = '1') 
              report "FAIL: Q did not switch to '1' after K/2 cycles" 
              severity error;
              
              -- 2-е преключение (еще через 50 нс)
              wait for 50 ns;
              assert (q_100 = '0') 
              report "FAIL: Q did not switch back to '0'" 
              severity error;
              
              -- пауза(EN=0)
              en <= '0';
              wait for 100 ns; 
              assert (q_100 = '0') 
              report "FAIL: Q changed while EN = '0'" 
              severity error;
              
              en <= '1';
              wait for 200 ns;
      
              report "--- SUCCESS: freq_div_behav tests passed! ---" 
              severity note;
              wait; 
          end process Sim2;
End sim;