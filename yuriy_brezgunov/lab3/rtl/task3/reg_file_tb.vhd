library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_file_tb is
end reg_file_tb;

architecture rtl of reg_file_tb is
    component reg_file is
        generic (
            M : natural := 4;
            N : natural := 8
        );
        port (
            CLK     : in  std_logic;
            RST     : in  std_logic;
            WE      : in  std_logic;
            W_ADDRS : in  natural range 0 to M-1;
            W_DATA  : in  std_logic_vector(N-1 downto 0);
            R_ADDRS : in  natural range 0 to M-1;
            R_DATA  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    constant M          : natural := 4;
    constant N          : natural := 8;
    constant CLK_PERIOD : time := 20 ns;
    constant ZEROS      : std_logic_vector(N-1 downto 0) := (others => '0');

    signal CLK   : std_logic := '0';
    signal RST   : std_logic := '0';
    signal WE    : std_logic := '0';
    signal WADDR : natural range 0 to M-1 := 0;
    signal WDATA : std_logic_vector(N-1 downto 0) := (others => '0');
    signal RADDR : natural range 0 to M-1 := 0;
    signal RDATA : std_logic_vector(N-1 downto 0);

begin
    UUT: reg_file
        generic map ( M => M, N => N )
        port map (
            CLK     => CLK,
            RST     => RST,
            WE      => WE,
            W_ADDRS => WADDR,
            W_DATA  => WDATA,
            R_ADDRS => RADDR,
            R_DATA  => RDATA
        );

    CLK_proc: process
    begin
        while now < 500 ns loop
            CLK <= '0';
            wait for CLK_PERIOD/2;
            CLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    STIM: process
        variable test_val1 : std_logic_vector(N-1 downto 0);
        variable test_val2 : std_logic_vector(N-1 downto 0);
    begin
        test_val1 := (0 => '1', 2 => '1', 5 => '1', others => '0');
        test_val2 := (1 => '1', 3 => '1', others => '0');

        RST <= '0'; WE <= '0';
        WDATA <= (others => '0');
        wait for CLK_PERIOD;

        WE    <= '1';
        WADDR <= 0;
        WDATA <= test_val1;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;

        WADDR <= 1;
        WDATA <= test_val2;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        WE <= '0';

        RADDR <= 0;
        wait for CLK_PERIOD / 2;
        assert (RDATA = test_val1)
            report "FAIL: read reg 0 failed"
            severity error;

        RADDR <= 1;
        wait for CLK_PERIOD / 2;
        assert (RDATA = test_val2)
            report "FAIL: read reg 1 failed"
            severity error;

        WDATA <= (others => '1');
        wait for CLK_PERIOD * 2;
        RADDR <= 0;
        wait for CLK_PERIOD / 2;
        assert (RDATA = test_val1)
            report "FAIL: data hold failed"
            severity error;

        WE    <= '1';
        WADDR <= 2;
        WDATA <= test_val2;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        WE <= '0';

        RADDR <= 0;
        wait for CLK_PERIOD / 2;
        assert (RDATA = test_val1)
            report "FAIL: write to reg 2 affected reg 0"
            severity error;

        RADDR <= 2;
        wait for CLK_PERIOD / 2;
        assert (RDATA = test_val2)
            report "FAIL: read reg 2 failed"
            severity error;

        RST <= '1';
        wait for CLK_PERIOD / 4;
        RADDR <= 0;
        wait for CLK_PERIOD / 2;
        assert (RDATA = test_val1)
            report "FAIL: reset is not synchronous"
            severity error;

        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;

        RADDR <= 0;
        wait for CLK_PERIOD / 2;
        assert (RDATA = ZEROS)
            report "FAIL: synchronous reset reg 0 failed"
            severity error;

        RADDR <= 1;
        wait for CLK_PERIOD / 2;
        assert (RDATA = ZEROS)
            report "FAIL: synchronous reset reg 1 failed"
            severity error;

        RADDR <= 2;
        wait for CLK_PERIOD / 2;
        assert (RDATA = ZEROS)
            report "FAIL: synchronous reset reg 2 failed"
            severity error;
        RST <= '0';

        WE    <= '1';
        WADDR <= 0;
        WDATA <= test_val1;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        WE <= '0';

        RADDR <= 0;
        wait for CLK_PERIOD / 2;
        assert (RDATA = test_val1)
            report "FAIL: write after reset failed"
            severity error;

        report "testbench finished";
        wait;
    end process;
end rtl;