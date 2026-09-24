library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file_2r1w_tb is
end reg_file_2r1w_tb;

architecture rtl of reg_file_2r1w_tb is
    component reg_file_2r1w is
        Generic (
            ADDR_WIDTH : natural := 5;
            DATA_WIDTH : natural := 16
        );
        Port (
            CLK      : in  std_logic;
            CLR      : in  std_logic;
            W_EN     : in  std_logic;
            W_ADDR   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            W_DATA   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            R_ADDR_0 : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            R_DATA_0 : out std_logic_vector(DATA_WIDTH-1 downto 0);
            R_ADDR_1 : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            R_DATA_1 : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    constant ADDR_WIDTH : natural := 5;
    constant DATA_WIDTH : natural := 16;
    constant CLK_PERIOD : time    := 20 ns;
    constant ZEROS      : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

    signal CLK      : std_logic := '0';
    signal CLR      : std_logic := '0';
    signal W_EN     : std_logic := '0';
    signal W_ADDR   : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal W_DATA   : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal R_ADDR_0 : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal R_DATA_0 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal R_ADDR_1 : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal R_DATA_1 : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
    UUT: reg_file_2r1w
        generic map ( ADDR_WIDTH => ADDR_WIDTH, DATA_WIDTH => DATA_WIDTH )
        port map (
            CLK      => CLK,
            CLR      => CLR,
            W_EN     => W_EN,
            W_ADDR   => W_ADDR,
            W_DATA   => W_DATA,
            R_ADDR_0 => R_ADDR_0,
            R_DATA_0 => R_DATA_0,
            R_ADDR_1 => R_ADDR_1,
            R_DATA_1 => R_DATA_1
        );

    CLK_proc: process
    begin
        while now < 2000 ns loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    STIM: process
        constant VAL_0 : std_logic_vector(DATA_WIDTH-1 downto 0) := x"AAAA";
        constant VAL_1 : std_logic_vector(DATA_WIDTH-1 downto 0) := x"BBBB";
        constant VAL_2 : std_logic_vector(DATA_WIDTH-1 downto 0) := x"CCCC";
        constant VAL_3 : std_logic_vector(DATA_WIDTH-1 downto 0) := x"DDDD";
    begin
        CLR <= '0'; W_EN <= '0';
        wait for CLK_PERIOD;

        W_EN <= '1';

        W_ADDR <= "00000"; W_DATA <= VAL_0;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;

        W_ADDR <= "00001"; W_DATA <= VAL_1;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;

        W_ADDR <= "00010"; W_DATA <= VAL_2;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;

        W_ADDR <= "00011"; W_DATA <= VAL_3;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        W_EN <= '0';

        R_ADDR_0 <= "00000";
        wait for CLK_PERIOD / 2;
        assert (R_DATA_0 = VAL_0)
            report "FAIL: read reg 0 failed"
            severity error;

        R_ADDR_0 <= "00001";
        wait for CLK_PERIOD / 2;
        assert (R_DATA_0 = VAL_1)
            report "FAIL: read reg 1 failed"
            severity error;

        R_ADDR_0 <= "00010";
        wait for CLK_PERIOD / 2;
        assert (R_DATA_0 = VAL_2)
            report "FAIL: read reg 2 failed"
            severity error;

        R_ADDR_0 <= "00011";
        wait for CLK_PERIOD / 2;
        assert (R_DATA_0 = VAL_3)
            report "FAIL: read reg 3 failed"
            severity error;

        W_EN   <= '1';
        W_ADDR <= "00000";
        W_DATA <= x"1234";
        R_ADDR_0 <= "00000";
        wait for CLK_PERIOD / 4;
        assert (R_DATA_0 = x"1234")
            report "FAIL: forwarding port 0 failed"
            severity error;
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        W_EN <= '0';

        W_EN     <= '1';
        W_ADDR   <= "00101";
        W_DATA   <= x"EEEE";
        R_ADDR_0 <= "00001";
        R_ADDR_1 <= "00010";
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        W_EN <= '0';
        assert (R_DATA_0 = VAL_1)
            report "FAIL: simultaneous read port 0 failed"
            severity error;
        assert (R_DATA_1 = VAL_2)
            report "FAIL: simultaneous read port 1 failed"
            severity error;

        R_ADDR_0 <= "00101";
        wait for CLK_PERIOD / 2;
        assert (R_DATA_0 = x"EEEE")
            report "FAIL: simultaneous write reg 5 failed"
            severity error;

        W_EN   <= '0';
        W_ADDR <= "00000";
        W_DATA <= x"FFFF";
        wait until rising_edge(CLK);
        wait for CLK_PERIOD / 4;
        R_ADDR_0 <= "00000";
        wait for CLK_PERIOD / 2;
        assert (R_DATA_0 = x"1234")
            report "FAIL: write with W_EN=0 changed data"
            severity error;

        CLR <= '1';
        wait for CLK_PERIOD / 4;
        R_ADDR_0 <= "00000";
        wait for CLK_PERIOD / 4;
        assert (R_DATA_0 = ZEROS)
            report "FAIL: async reset reg 0 failed"
            severity error;
        R_ADDR_0 <= "00001";
        wait for CLK_PERIOD / 4;
        assert (R_DATA_0 = ZEROS)
            report "FAIL: async reset reg 1 failed"
            severity error;
        R_ADDR_1 <= "00011";
        wait for CLK_PERIOD / 4;
        assert (R_DATA_1 = ZEROS)
            report "FAIL: async reset reg 3 failed"
            severity error;
        CLR <= '0';

        report "testbench finished";
        wait;
    end process;
end rtl;