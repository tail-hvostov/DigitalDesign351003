library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4TB is
end Task4TB;

architecture sim of Task4TB is
    component freq_div_behav
        generic (K : natural);
        port(
            CLK : in std_logic;
            RST : in std_logic;
            EN  : in std_logic;
            Q   : out std_logic
        );
    end component;
    signal CLK : std_logic := '0';
    signal RST : std_logic;
    signal EN  : std_logic;
    signal Q4, Q10, Q100 : std_logic;
begin
    DUT1: freq_div_behav generic map(K => 4)
        port map(CLK => CLK, RST => RST, EN => EN, Q => Q4);

    DUT2: freq_div_behav generic map(K => 10)
        port map(CLK => CLK, RST => RST, EN => EN, Q => Q10);

    DUT3: freq_div_behav generic map(K => 100)
        port map(CLK => CLK, RST => RST, EN => EN, Q => Q100);

    -- CLOCK 100 MHz -> 10 ns период
    CLK_PROCESS: process
    begin
        while true loop
            CLK <= '0'; wait for 5 ns;
            CLK <= '1'; wait for 5 ns;
        end loop;
    end process;

    TESTING: process
    begin
        RST <= '1'; EN <= '0';
        wait for 20 ns;
        
        RST <= '0'; EN <= '1';

        wait for 500 ns;

        EN <= '0';
        wait for 50 ns;

        assert (Q4 = Q4 and Q10 = Q10 and Q100 = Q100)
            report "EN FAIL"
            severity error;

        EN <= '1';
        wait for 200 ns;

        report "FREQ DIV TEST DONE" severity note;
        wait;
    end process;
end sim;