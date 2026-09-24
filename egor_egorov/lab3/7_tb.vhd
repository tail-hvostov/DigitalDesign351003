library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_tb is
end top_tb;

architecture rtl of top_tb is

    constant ADDR_W: natural := 5;
    constant DATA_W: natural := 16;

    component reg_file_2r1w
        generic (
            ADDR_WIDTH: integer := 5;
            DATA_WIDTH: integer := 16
        );
        port (
            CLK: in  std_logic;
            CLR: in  std_logic;
            W_EN: in  std_logic;
            W_ADDR: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            W_DATA: in  std_logic_vector (DATA_WIDTH-1 downto 0);
            R_ADDR_0: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            R_DATA_0: out std_logic_vector (DATA_WIDTH-1 downto 0);
            R_ADDR_1: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            R_DATA_1: out std_logic_vector (DATA_WIDTH-1 downto 0)
         );
    end component;

    signal CLK_tb, s_clk_half, s_clk_gate : std_logic := '0';

    signal CLR_tb_s0, CLR_tb_s1, CLR_tb : std_logic := '0';
    signal W_EN_tb_s0, W_EN_tb_s1, W_EN_tb : std_logic := '0';

    signal W_ADDR_tb, R_ADDR_0_tb, R_ADDR_1_tb : std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
    signal W_DATA_tb : std_logic_vector(DATA_W-1 downto 0) := (others => '0');

    signal R_DATA_0_tb, R_DATA_1_tb : std_logic_vector(DATA_W-1 downto 0);

    constant CLK_HALF: time := 10 ns;

    signal ZERO_VEC : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
    signal FF_VEC   : std_logic_vector(DATA_W-1 downto 0) := (others => '1');

    type check_sel_t is (CHK_ZERO, CHK_RW, CHK_FWD, CHK_FINAL);

begin

    UUT: reg_file_2r1w
        generic map ( ADDR_WIDTH => ADDR_W, DATA_WIDTH => DATA_W )
        port map (
            CLK => CLK_tb,
            CLR => CLR_tb,
            W_EN => W_EN_tb,
            W_ADDR => W_ADDR_tb,
            W_DATA => W_DATA_tb,
            R_ADDR_0 => R_ADDR_0_tb,
            R_DATA_0 => R_DATA_0_tb,
            R_ADDR_1 => R_ADDR_1_tb,
            R_DATA_1 => R_DATA_1_tb
        );

    CLK_PHASE : process
    begin
        loop
            s_clk_half <= '0'; wait for CLK_HALF;
            s_clk_half <= '1'; wait for CLK_HALF;
        end loop;
    end process;

    CLK_GEN : process(s_clk_half, s_clk_gate)
    begin
        case s_clk_gate is
            when '1'    => CLK_tb <= s_clk_half;
            when others => CLK_tb <= '0';
        end case;
    end process;

    s_clk_gate <= '1';

    process
        variable v_passed : natural := 0;
        variable mode : check_sel_t := CHK_ZERO;
    begin

        CLR_tb_s0 <= '1';
        CLR_tb_s1 <= CLR_tb_s0 or '0';
        CLR_tb    <= CLR_tb_s1 and '1';

        wait until rising_edge(CLK_tb);
        CLR_tb <= '0';

        R_ADDR_0_tb <= std_logic_vector(to_unsigned(5, ADDR_W)) xor (ADDR_W-1 downto 0 => '0');
        R_ADDR_1_tb <= std_logic_vector(to_unsigned(25, ADDR_W)) and (ADDR_W-1 downto 0 => '1');

        wait for 1 ns;

        case mode is
            when CHK_ZERO =>
                assert (R_DATA_0_tb = ZERO_VEC and R_DATA_1_tb = ZERO_VEC)
                report "FAILED ZERO" severity error;
                v_passed := v_passed + 1;
                mode := CHK_RW;

            when CHK_RW =>
                null;

            when others =>
                null;
        end case;

        wait;

    end process;

end rtl;