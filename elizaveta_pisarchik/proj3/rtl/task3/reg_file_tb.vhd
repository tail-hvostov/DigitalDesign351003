library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file_tb is
end reg_file_tb;

architecture sim of reg_file_tb is
    constant M : integer := 4;
    constant N : integer := 8;
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal WE  : std_logic := '0';
    signal WA  : integer range 0 to M-1 := 0;
    signal RA  : integer range 0 to M-1 := 0;
    signal Din  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal Dout : std_logic_vector(N-1 downto 0);
    constant ZERO_VEC : std_logic_vector(N-1 downto 0) := (others => '0');
begin
DUT: entity work.reg_file
    generic map (M => M, N => N)
    port map (
        CLK => CLK,
        RST => RST,
        WE  => WE,
        WA  => WA,
        RA  => RA,
        Din => Din,
        Dout => Dout
    );

CLK_PROCESS: process
begin
    while true loop
        CLK <= '0'; wait for 10 ns;
        CLK <= '1'; wait for 10 ns;
    end loop;
end process;

TESTING: process
begin
    RST <= '1';
    WE  <= '0';
    wait until rising_edge(CLK);
    wait until rising_edge(CLK);

    RST <= '0';
    WE  <= '1';
    WA  <= 2;
    Din <= "10101010";
    wait until rising_edge(CLK);

    WE <= '0';
    RA <= 2;
    wait until rising_edge(CLK);
    assert (Dout = "10101010")
        report "READ FAIL"
        severity error;

    RST <= '1';

    wait until rising_edge(CLK);
    wait until rising_edge(CLK);

    RA <= 2;
    wait until rising_edge(CLK);
    assert (Dout = ZERO_VEC)
        report "RESET FAIL"
        severity error;

    report "REG FILE OK" severity note;
    wait;
end process;
end sim;