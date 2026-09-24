library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_unit_tb is
end reg_unit_tb;

architecture sim of reg_unit_tb is
    constant N : integer := 8;
    signal CLK  : std_logic := '0';
    signal RST  : std_logic := '0';
    signal EN   : std_logic := '0';
    signal Din  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal Dout : std_logic_vector(N-1 downto 0);
    constant ZERO_VEC : std_logic_vector(N-1 downto 0) := (others => '0');
begin
DUT: entity work.reg_unit
    generic map (N => N)
    port map (
        CLK  => CLK,
        RST  => RST,
        EN   => EN,
        Din  => Din,
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
    EN  <= '0';
    Din <= (others => '1');
    wait until rising_edge(CLK);
    wait until rising_edge(CLK);
    assert (Dout = ZERO_VEC)
        report "RESET FAIL"
        severity error;

    RST <= '0';
    EN  <= '1';
    Din <= "10101010";
    wait until rising_edge(CLK);
    wait until rising_edge(CLK);
    assert (Dout = "10101010")
        report "WRITE FAIL"
        severity error;

    EN  <= '0';
    Din <= "11111111";
    wait until rising_edge(CLK);
    assert (Dout = "10101010")
        report "STORE FAIL"
        severity error;

    report "REG UNIT OK" severity note;
    wait;
end process;

end sim;