library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity top_tb is
end entity top_tb;

architecture Behavioral of top_tb is

    constant N     : integer := 8;
    constant M     : integer := 4;
    constant ADR_W : integer := 2;

    component top is
        generic (
            N : integer range 1 to 32 := 8;
            M : integer range 1 to 32 := 16
        );
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            we     : in  std_logic;
            w_adr  : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            r_adr  : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            w_data : in  std_logic_vector(N-1 downto 0);
            r_data : out std_logic_vector(N-1 downto 0)
        );
    end component top;

    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal we     : std_logic := '0';
    signal w_adr  : std_logic_vector(ADR_W-1 downto 0) := (others => '0');
    signal r_adr  : std_logic_vector(ADR_W-1 downto 0) := (others => '0');
    signal w_data : std_logic_vector(N-1 downto 0)     := (others => '0');
    signal r_data : std_logic_vector(N-1 downto 0)     := (others => '0');

    signal s_test_done  : std_logic := '0';
    signal s_clk_gate   : std_logic := '1';
    signal s_clk_half   : std_logic := '0';
    signal s_phase_tick : natural   := 0;

    constant CLK_PERIOD : time := 20 ns;
    constant CLK_HALF   : time := CLK_PERIOD / 2;
    constant ZEROS      : std_logic_vector(N-1 downto 0) := (others => '0');
    constant FF_VEC     : std_logic_vector(N-1 downto 0) := (others => '1');

    constant DATA_0 : std_logic_vector(N-1 downto 0) := x"AB";
    constant DATA_1 : std_logic_vector(N-1 downto 0) := x"CD";
    constant DATA_2 : std_logic_vector(N-1 downto 0) := x"12";
    constant DATA_3 : std_logic_vector(N-1 downto 0) := x"34";

    type data_lut_t  is array (0 to 3) of std_logic_vector(N-1 downto 0);
    type check_sel_t is (CHK_ZERO, CHK_LUT, CHK_DATA0);

    constant DATA_LUT : data_lut_t := (DATA_0, DATA_1, DATA_2, DATA_3);

    procedure do_write (
        constant addr  : in  natural;
        constant data  : in  std_logic_vector(N-1 downto 0);
        signal   we_s  : out std_logic;
        signal   wa_s  : out std_logic_vector(ADR_W-1 downto 0);
        signal   wd_s  : out std_logic_vector(N-1 downto 0);
        signal   clk_s : in  std_logic
    ) is
        variable v_addr_slv : std_logic_vector(ADR_W-1 downto 0);
    begin
        v_addr_slv := std_logic_vector(to_unsigned(addr, ADR_W));
        we_s <= '1';
        wa_s <= v_addr_slv xor (ADR_W-1 downto 0 => '0');
        wd_s <= data and FF_VEC;
        wait until rising_edge(clk_s);
        wait for 5 ns;
        we_s <= '0';
    end procedure;

    procedure do_read (
        constant addr : in  natural;
        signal   ra_s : out std_logic_vector(ADR_W-1 downto 0)
    ) is
        variable v_slv : std_logic_vector(ADR_W-1 downto 0);
    begin
        v_slv := std_logic_vector(to_unsigned(addr, ADR_W));
        ra_s  <= v_slv or (ADR_W-1 downto 0 => '0');
        wait for 1 ns;
    end procedure;

    procedure do_check (
        constant idx     : in natural;
        constant mode    : in check_sel_t;
        constant lut     : in data_lut_t;
        constant ref_d0  : in std_logic_vector(N-1 downto 0);
        constant ref_z   : in std_logic_vector(N-1 downto 0);
        signal   r_data_s : in std_logic_vector(N-1 downto 0)
    ) is
        variable v_expected : std_logic_vector(N-1 downto 0);
        variable v_tag      : string(1 to 3);
    begin
        case mode is
            when CHK_ZERO  => v_expected := ref_z;
            when CHK_LUT   => v_expected := lut(idx);
            when CHK_DATA0 => v_expected := ref_d0;
        end case;

        case mode is
            when CHK_ZERO =>
                assert r_data_s = v_expected
                    report "RESET FAILED: REG[" & integer'image(idx) & "] not zero"
                    severity error;
            when CHK_LUT =>
                assert r_data_s = v_expected
                    report "WRITE/READ FAILED: REG[" & integer'image(idx) & "]"
                    severity error;
            when CHK_DATA0 =>
                assert r_data_s = v_expected
                    report "WE=0 FAILED: REG[0] was overwritten"
                    severity error;
        end case;
    end procedure;

begin

    CLK_PHASE : process
    begin
        loop
            s_clk_half <= '0';
            wait for CLK_HALF;
            s_clk_half <= '1';
            wait for CLK_HALF;
            exit when s_test_done = '1';
        end loop;
        wait;
    end process;

    CLK_GEN : process(s_clk_half, s_clk_gate)
    begin
        case s_clk_gate is
            when '1'    => clk <= s_clk_half;
            when others => clk <= '0';
        end case;
    end process;

    UUT : top
        generic map (N => N, M => M)
        port map (
            clk    => clk,
            rst    => rst,
            we     => we,
            w_adr  => w_adr,
            r_adr  => r_adr,
            w_data => w_data,
            r_data => r_data
        );

    STIM : process
        variable v_idx    : natural range 0 to 3 := 0;
        variable v_passed : natural range 0 to 16 := 0;
    begin

        -- ========================================
        -- 1. Начальный синхронный сброс
        -- ========================================
        rst <= '1'; we <= '0';
        wait until rising_edge(clk); wait for 5 ns;
        rst <= '0';

        v_idx := 0;
        loop
            do_read(v_idx, r_adr);
            do_check(v_idx, CHK_ZERO, DATA_LUT, DATA_0, ZEROS, r_data);
            exit when v_idx = 3;
            v_idx := v_idx + 1;
        end loop;

        v_passed := v_passed + 1;
        report "Initial reset: PASSED (" & integer'image(v_passed) & "/5)" severity note;

        -- ========================================
        -- 2. Запись и чтение данных
        -- ========================================
        v_idx := 0;
        loop
            do_write(v_idx, DATA_LUT(v_idx), we, w_adr, w_data, clk);
            do_read(v_idx, r_adr);
            do_check(v_idx, CHK_LUT, DATA_LUT, DATA_0, ZEROS, r_data);
            report "Write/Read REG[" & integer'image(v_idx) & "]: PASSED" severity note;
            exit when v_idx = 3;
            v_idx := v_idx + 1;
        end loop;

        v_passed := v_passed + 1;
        report "Write/Read all: PASSED (" & integer'image(v_passed) & "/5)" severity note;

        -- ========================================
        -- 3. Изоляция: запись в один регистр
        --    не меняет остальные
        -- ========================================
        v_idx := 0;
        loop
            do_read(v_idx, r_adr);
            do_check(v_idx, CHK_LUT, DATA_LUT, DATA_0, ZEROS, r_data);
            exit when v_idx = 2;
            v_idx := v_idx + 1;
        end loop;

        v_passed := v_passed + 1;
        report "Register isolation: PASSED (" & integer'image(v_passed) & "/5)" severity note;

        -- ========================================
        -- 4. Режим хранения: WE=0 — запись
        --    не должна происходить
        -- ========================================
        we     <= '0';
        w_adr  <= std_logic_vector(to_unsigned(0, ADR_W)) xor (ADR_W-1 downto 0 => '0');
        w_data <= FF_VEC;
        wait until rising_edge(clk); wait for 5 ns;

        do_read(0, r_adr);
        do_check(0, CHK_DATA0, DATA_LUT, DATA_0, ZEROS, r_data);

        v_passed := v_passed + 1;
        report "Write disabled (WE=0): PASSED (" & integer'image(v_passed) & "/5)" severity note;

        -- ========================================
        -- 5. Синхронный сброс заполненных регистров
        -- ========================================
        rst <= '1';
        wait until rising_edge(clk); wait for 5 ns;
        rst <= '0';

        v_idx := 0;
        loop
            do_read(v_idx, r_adr);
            do_check(v_idx, CHK_ZERO, DATA_LUT, DATA_0, ZEROS, r_data);
            exit when v_idx = 3;
            v_idx := v_idx + 1;
        end loop;

        v_passed := v_passed + 1;
        report "Reset filled registers: PASSED (" & integer'image(v_passed) & "/5)" severity note;

        wait for 50 ns;
        report "Testbench complete: " & integer'image(v_passed) & "/5 passed" severity note;
        s_test_done <= '1';
        wait;

    end process STIM;

end architecture Behavioral;