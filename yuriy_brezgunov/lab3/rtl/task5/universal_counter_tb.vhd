library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_counter_tb is
end universal_counter_tb;

architecture rtl of universal_counter_tb is
    component universal_counter is
        Generic ( N : natural := 8 );
        Port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            MODE : in  std_logic_vector(1 downto 0);
            LOAD : in  std_logic;
            Din  : in  std_logic_vector(N-1 downto 0);
            Dout : out std_logic_vector(N-1 downto 0)
        );
    end component;

    constant N          : natural := 8;
    constant CLK_PERIOD : time := 20 ns;
    constant ZEROS      : std_logic_vector(N-1 downto 0) := (others => '0');

    signal CLK  : std_logic := '0';
    signal CLR  : std_logic := '0';
    signal EN   : std_logic := '0';
    signal MODE : std_logic_vector(1 downto 0) := "00";
    signal LOAD : std_logic := '0';
    signal Din  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal Dout : std_logic_vector(N-1 downto 0);

begin
    UUT: universal_counter
        generic map ( N => N )
        port map (
            CLK  => CLK,
            CLR  => CLR,
            EN   => EN,
            MODE => MODE,
            LOAD => LOAD,
            Din  => Din,
            Dout => Dout
        );

    CLK_proc: process
    begin
        while now < 5000 ns loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    STIM: process
    begin
        CLR <= '0'; EN <= '0';
        MODE <= "00"; LOAD <= '0';
        Din <= (others => '0');
        wait for CLK_PERIOD;

        CLR <= '1';
        wait for CLK_PERIOD / 4;
        assert (Dout = ZEROS)
            report "FAIL: async reset failed"
            severity error;
        CLR <= '0';

        EN <= '1';
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        assert (Dout /= ZEROS)
            report "FAIL: mode 00 counter not incrementing"
            severity error;

        EN <= '0';
        wait for CLK_PERIOD / 4;
        assert (Dout /= ZEROS)
            report "FAIL: EN=0 hold failed"
            severity error;
        wait for CLK_PERIOD * 3;
        assert (Dout /= ZEROS)
            report "FAIL: EN=0 counter changed"
            severity error;
        EN <= '1';

        CLR <= '1';
        wait for CLK_PERIOD / 4;
        assert (Dout = ZEROS)
            report "FAIL: async reset before mode 01 failed"
            severity error;
        CLR <= '0';

        MODE <= "01";
        for i in 1 to N-1 loop
            wait until rising_edge(CLK);
        end loop;
        wait for CLK_PERIOD / 4;
        assert (Dout = ZEROS)
            report "FAIL: mode 01 reset at N-2 failed"
            severity error;

        CLR <= '1';
        wait for CLK_PERIOD / 4;
        CLR <= '0';

        MODE <= "10";
        Din  <= (0 => '1', 2 => '1', 5 => '1', others => '0');
        LOAD <= '1';
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        assert (Dout = Din)
            report "FAIL: mode 10 parallel load failed"
            severity error;

        LOAD <= '0';
        Din  <= (others => '1');
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        assert (Dout = "00100101")
            report "FAIL: mode 10 hold when LOAD=0 failed"
            severity error;

        report "testbench finished";
        wait;
    end process;
end rtl;