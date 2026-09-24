library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_bench_dff is
end test_bench_dff;

architecture Sim_Arch of test_bench_dff is

    signal D     : std_logic := '0';
    signal CLK   : std_logic := '0';
    signal CLR_N : std_logic := '0';
    signal Q     : std_logic;
    
    constant CLK_PERIOD : time := 10 ns;
begin

    UUT: entity work.DFF_Async_Reset
        port map (
            D     => D,
            CLK   => CLK,
            CLR_N => CLR_N,
            Q     => Q
        );

    CLK_process : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    
    stim_proc: process
    begin
        -- асинхр сброс 
        CLR_N <= '0'; 
        D <= '1'; 
        wait for 15 ns; 
        assert (Q = '0') 
        report "Error: Q is not '0' after Reset" 
        severity error;

        -- сн€ие сброс а + запись 1
        CLR_N <= '1';
        D <= '1';
        wait until rising_edge(CLK); 
        wait for 2 ns;               
        assert (Q = '1') 
        report "Error: Q should be '1' when D='1'" 
        severity error;

        -- запись 0
        D <= '0';
        wait until rising_edge(CLK);
        wait for 2 ns;
        assert (Q = '0') 
        report "Error: Q should be '0' when D='0'" 
        severity error;

        -- сброс вне зависимости от CLK
        D <= '1';
        wait for 2 ns;  -- D изменилс€, но фронта еще нет
        CLR_N <= '0';   -- сброс
        wait for 2 ns;
        assert (Q = '0') 
        report "Error: Async Reset did not work immediately" 
        severity error;

        --  возврат в раб сост
        CLR_N <= '1';
        D <= '1';
        wait until rising_edge(CLK);
        wait for 2 ns;
        assert (Q = '1') 
        report "Error: Reset recovery failed" 
        severity error;

        report "Simulation finished successfully!" severity note;
        wait; 
    end process stim_proc;

end Sim_Arch;