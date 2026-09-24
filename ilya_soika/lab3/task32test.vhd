library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity reg_file_tb is
end reg_file_tb;

architecture Behavioural of reg_file_tb is

    constant M: natural := 8;
    constant N: natural := 34;
    constant ADDR_W: natural := 3; 

    component reg_file
        generic (
            M: natural := 8;
            N: natural := 34
        );
        port(
            CLK: in  std_logic;
            RST: in  std_logic;
            WEN: in  std_logic;
            WADDR : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            WDATA : in  std_logic_vector(N-1 downto 0);
            RADDR : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            RDATA : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal CLK_tb: std_logic := '0';
    signal RST_tb: std_logic := '0';
    signal WEN_tb: std_logic := '0';
    signal WADDR_tb: std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
    signal WDATA_tb: std_logic_vector(N-1 downto 0)      := (others => '0');
    signal RADDR_tb: std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
    signal RDATA_tb: std_logic_vector(N-1 downto 0);

    constant CLK_PERIOD: time := 20 ns;
    constant ZEROS: std_logic_vector(N-1 downto 0) := (others => '0');

    constant DATA_0: std_logic_vector(N-1 downto 0) := "01" & x"ABCDEF01";
    constant DATA_3: std_logic_vector(N-1 downto 0) := "10" & x"12345678";
    constant DATA_7: std_logic_vector(N-1 downto 0) := "11" & x"DEADBEEF";

begin
    UUT: reg_file
        generic map ( M => M, N => N )
        port map (
            CLK   => CLK_tb,
            RST   => RST_tb,
            WEN   => WEN_tb,
            WADDR => WADDR_tb,
            WDATA => WDATA_tb,
            RADDR => RADDR_tb,
            RDATA => RDATA_tb
        );

    CLK_tb <= not CLK_tb after CLK_PERIOD / 2;

    process
    begin
        RST_tb <= '1'; WEN_tb <= '0';
        wait until rising_edge(CLK_tb); wait for 5 ns;

        RADDR_tb <= std_logic_vector(to_unsigned(0, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = ZEROS
            report "RESET FAILED: REG[0] is not zero" severity error;

        RADDR_tb <= std_logic_vector(to_unsigned(3, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = ZEROS
            report "RESET FAILED: REG[3] is not zero" severity error;

        RADDR_tb <= std_logic_vector(to_unsigned(7, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = ZEROS
            report "RESET FAILED: REG[7] is not zero" severity error;

        report "Synchronous reset all registers: PASSED" severity note;
        RST_tb <= '0';

        WEN_tb   <= '1';
        WADDR_tb <= std_logic_vector(to_unsigned(0, ADDR_W));
        WDATA_tb <= DATA_0;
        wait until rising_edge(CLK_tb); wait for 5 ns;
        WEN_tb <= '0';

        RADDR_tb <= std_logic_vector(to_unsigned(0, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = DATA_0
            report "WRITE/READ FAILED: REG[0] /= DATA_0" severity error;
        report "Write/Read REG[0]: PASSED" severity note;

        WEN_tb   <= '1';
        WADDR_tb <= std_logic_vector(to_unsigned(3, ADDR_W));
        WDATA_tb <= DATA_3;
        wait until rising_edge(CLK_tb); wait for 5 ns;
        WEN_tb <= '0';

        RADDR_tb <= std_logic_vector(to_unsigned(3, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = DATA_3
            report "WRITE/READ FAILED: REG[3] /= DATA_3" severity error;
        report "Write/Read REG[3]: PASSED" severity note;

        WEN_tb   <= '1';
        WADDR_tb <= std_logic_vector(to_unsigned(7, ADDR_W));
        WDATA_tb <= DATA_7;
        wait until rising_edge(CLK_tb); wait for 5 ns;
        WEN_tb <= '0';

        RADDR_tb <= std_logic_vector(to_unsigned(7, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = DATA_7
            report "WRITE/READ FAILED: REG[7] /= DATA_7" severity error;
        report "Write/Read REG[7]: PASSED" severity note;

        RADDR_tb <= std_logic_vector(to_unsigned(0, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = DATA_0
            report "ISOLATION FAILED: REG[0] changed after write to REG[7]" severity error;

        RADDR_tb <= std_logic_vector(to_unsigned(3, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = DATA_3
            report "ISOLATION FAILED: REG[3] changed after write to REG[7]" severity error;
        report "Register isolation: PASSED" severity note;

        WEN_tb   <= '0';
        WADDR_tb <= std_logic_vector(to_unsigned(0, ADDR_W));
        WDATA_tb <= DATA_7;
        wait until rising_edge(CLK_tb); wait for 5 ns;

        RADDR_tb <= std_logic_vector(to_unsigned(0, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = DATA_0
            report "WEN=0 FAILED: REG[0] was overwritten while WEN=0" severity error;
        report "Write disabled (WEN=0): PASSED" severity note;

        RST_tb <= '1';
        wait until rising_edge(CLK_tb); wait for 5 ns;

        RADDR_tb <= std_logic_vector(to_unsigned(0, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = ZEROS
            report "RESET FAILED: REG[0] not zero after second reset" severity error;

        RADDR_tb <= std_logic_vector(to_unsigned(3, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = ZEROS
            report "RESET FAILED: REG[3] not zero after second reset" severity error;

        RADDR_tb <= std_logic_vector(to_unsigned(7, ADDR_W));
        wait for 1 ns;
        assert RDATA_tb = ZEROS
            report "RESET FAILED: REG[7] not zero after second reset" severity error;

        report "Reset all registers with data: PASSED" severity note;

        RST_tb <= '0';
        wait for 50 ns;
        report "Testbench complete" severity note;
        wait;

    end process;

end Behavioural;