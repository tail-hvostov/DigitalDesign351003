library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task2test is
end task2test;

architecture Behavioural of task2test is
    component FDCE
        port (
            CLR_N : in  std_logic;
            CLK   : in  std_logic;
            D     : in  std_logic;
            Q     : out std_logic
        );
    end component;

    signal CLR_N_tb : std_logic := '1';
    signal CLK_tb   : std_logic := '0';
    signal D_tb     : std_logic := '0';
    signal Q_tb     : std_logic;

begin
    UUT: FDCE
        port map (
            CLR_N => CLR_N_tb,
            CLK   => CLK_tb,
            D     => D_tb,
            Q     => Q_tb
        );

    CLK_tb <= not CLK_tb after 5 ns;

    process
    begin
        CLR_N_tb <= '0'; D_tb <= '1';
        wait for 30 ns;
        assert Q_tb = '0'
            report "FAIL: async reset, Q should be 0" severity error;

        CLR_N_tb <= '1'; D_tb <= '0';
        wait until rising_edge(CLK_tb);
        wait for 1 ns;
        assert Q_tb = '0'
            report "FAIL: write 0, Q should be 0" severity error;

        D_tb <= '1';
        wait until rising_edge(CLK_tb);
        wait for 1 ns;
        assert Q_tb = '1'
            report "FAIL: write 1, Q should be 1" severity error;

        D_tb <= '0';
        wait for 7 ns; 
        assert Q_tb = '1'
            report "FAIL: hold, Q should still be 1" severity error;

        wait until rising_edge(CLK_tb);
        wait for 1 ns;
        assert Q_tb = '0'
            report "FAIL: write 0 after hold, Q should be 0" severity error;

        D_tb <= '1';
        wait until rising_edge(CLK_tb);
        wait for 1 ns;
        assert Q_tb = '1'
            report "FAIL: write 1 before async reset test" severity error;
        CLR_N_tb <= '0';
        wait for 8 ns; 
        assert Q_tb = '0'
            report "FAIL: async reset mid-work, Q should be 0" severity error;
        CLR_N_tb <= '1';

        wait for 50 ns;
        report "Simulation complete" severity note;
        wait;
    end process;

end Behavioural;