library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_counter_tb is
end universal_counter_tb;

architecture Behavioural of universal_counter_tb is
    component universal_counter
        generic (N: natural := 16);
        port (
            CLK: in  std_logic;
            CLR: in  std_logic;
            EN: in  std_logic;
            MODE: in  std_logic_vector(2 downto 0);
            LOAD: in  std_logic;
            Din: in  std_logic_vector(N-1 downto 0);
            Dout: out std_logic_vector(N-1 downto 0)
        );
    end component;
    constant N_tb: natural := 16;
    constant CLK_PERIOD: time    := 2 ns;
    signal CLK_tb: std_logic := '0';
    signal CLR_tb: std_logic := '0';
    signal EN_tb: std_logic := '0';
    signal MODE_tb: std_logic_vector(2 downto 0) := "000";
    signal LOAD_tb: std_logic := '0';
    signal Din_tb: std_logic_vector(N_tb-1 downto 0) := (others => '0');
    signal Dout_tb: std_logic_vector(N_tb-1 downto 0);
    signal signature: std_logic_vector(N_tb-1 downto 0) := (others => '0');
    -- 0x1A2B3C4D5E6F7A8B9CADBECFD1E2F3A4B5C6
    type byte_array is array (0 to 35) of std_logic_vector(7 downto 0);
    constant TEST_VECTOR: byte_array := (
        x"1A", x"2B", x"3C", x"4D", x"5E", x"6F",
        x"7A", x"8B", x"9C", x"AD", x"BE", x"CF",
        x"D1", x"E2", x"F3", x"A4", x"B5", x"C6",
        x"1A", x"2B", x"3C", x"4D", x"5E", x"6F",
        x"7A", x"8B", x"9C", x"AD", x"BE", x"CF",
        x"D1", x"E2", x"F3", x"A4", x"B5", x"C6"
    );

begin
    UUT: universal_counter
        generic map (N => N_tb)
        port map (
            CLK => CLK_tb,
            CLR => CLR_tb,
            EN => EN_tb,
            MODE => MODE_tb,
            LOAD => LOAD_tb,
            Din => Din_tb,
            Dout => Dout_tb
        );
    CLK_tb <= not CLK_tb after CLK_PERIOD / 2;

    process
    begin
        Din_tb <= x"ABCD"; LOAD_tb <= '1'; EN_tb <= '1';
        wait for CLK_PERIOD;
        LOAD_tb <= '0';
        wait for CLK_PERIOD / 4;
        CLR_tb <= '1';
        wait for CLK_PERIOD / 4;
        assert Dout_tb = x"0000"
            report "FAILED: CLR did not reset immediately" severity error;
        CLR_tb <= '0';
        wait for CLK_PERIOD / 2;

        Din_tb <= x"1234"; LOAD_tb <= '1'; EN_tb <= '1';
        wait for CLK_PERIOD;
        LOAD_tb <= '0';
        wait for 1 ns; 
        assert Dout_tb = x"1234"
            report "FAILED: parallel load incorrect" severity error;

        EN_tb <= '0'; MODE_tb <= "000"; Din_tb <= x"FFFF";
        wait for CLK_PERIOD * 4;
        assert Dout_tb = x"1234"
            report "FAILED: register changed while EN=0" severity error;

        CLR_tb <= '1'; Din_tb <= x"0000";
        wait for CLK_PERIOD / 2;
        CLR_tb <= '0'; 
        wait for CLK_PERIOD / 2;
        EN_tb <= '1'; MODE_tb <= "000";
        for i in 0 to 35 loop
            for b in 0 to 7 loop
                Din_tb(0) <= TEST_VECTOR(i)(b);
                wait for CLK_PERIOD;
            end loop;
        end loop;
        signature <= Dout_tb;
        
        CLR_tb <= '1';
        wait for CLK_PERIOD / 3;
        assert Dout_tb = x"0000"
            report "FAILED: CLR during compression did not reset" severity error;
        CLR_tb <= '0';

        report "All tests complete" severity note;
        wait;

    end process;

end Behavioural;