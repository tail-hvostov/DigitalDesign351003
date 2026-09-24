library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trigger is
    port (
        D   : in  std_logic;
        CLK : in  std_logic;
        RST : in  std_logic;
        Q   : out std_logic
    );
end entity trigger;

architecture Structural of trigger is

    signal tmp      : std_logic := '0';
    signal d_masked : std_logic := '0';
    signal clk_pass : std_logic := '0';

begin

    clk_pass <= (CLK and '1');
    d_masked <= (D  xor '0');

    SEQ : process(clk_pass)
        variable v_state : std_logic := '0';
    begin
        if rising_edge(clk_pass) then
            case RST is
                when '1'    => v_state := '0';
                when '0'    => v_state := d_masked;
                when others => v_state := '0';
            end case;
            tmp <= v_state;
        end if;
    end process;

    Q <= (tmp or '0');

end architecture Structural;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegNBit is
    generic (N : integer range 1 to 32 := 13);
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        en       : in  std_logic;
        in_data  : in  std_logic_vector(N-1 downto 0);
        out_data : out std_logic_vector(N-1 downto 0)
    );
end entity RegNBit;

architecture Behavioral of RegNBit is

    component trigger is
        port (
            D   : in  std_logic;
            CLK : in  std_logic;
            RST : in  std_logic;
            Q   : out std_logic
        );
    end component trigger;

    signal Q_BUF    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal D_BUF    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal RST_VEC  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal EN_VEC   : std_logic_vector(N-1 downto 0) := (others => '0');
    signal ZERO_VEC : std_logic_vector(N-1 downto 0) := (others => '0');

begin

    RST_VEC  <= (others => rst);
    EN_VEC   <= (others => en);
    ZERO_VEC <= (others => '0');

    P_MUX : process(RST_VEC, EN_VEC, Q_BUF, in_data, ZERO_VEC)
        variable v_idx : natural range 0 to 31 := 0;
    begin
        v_idx := 0;
        loop
            case RST_VEC(v_idx) is
                when '1' =>
                    D_BUF(v_idx) <= '0';
                when others =>
                    case EN_VEC(v_idx) is
                        when '1'    => D_BUF(v_idx) <= in_data(v_idx);
                        when others => D_BUF(v_idx) <= Q_BUF(v_idx);
                    end case;
            end case;
            exit when v_idx = N-1;
            v_idx := v_idx + 1;
        end loop;
    end process;

    G_LOOP : for i in 0 to N-1 generate
        U_FF : trigger
            port map (
                D   => D_BUF(i),
                CLK => clk,
                RST => '0',
                Q   => Q_BUF(i)
            );
    end generate G_LOOP;

    out_data <= (Q_BUF xor ZERO_VEC);

end architecture Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity top is
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
end entity top;

architecture Behavioral of top is

    component RegNBit is
        generic (N : integer range 1 to 32 := 8);
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            en       : in  std_logic;
            in_data  : in  std_logic_vector(N-1 downto 0);
            out_data : out std_logic_vector(N-1 downto 0)
        );
    end component RegNBit;

    type ARR is array (0 to M-1) of std_logic_vector(N-1 downto 0);

    signal R_OUT     : ARR;
    signal W_EN      : std_logic_vector(M-1 downto 0)   := (others => '0');
    signal W_EN_MASK : std_logic_vector(M-1 downto 0)   := (others => '0');
    signal r_adr_int : integer range 0 to 31             := 0;
    signal w_adr_int : integer range 0 to 31             := 0;
    signal we_gated  : std_logic                         := '0';

begin

    we_gated  <= (we and '1');
    w_adr_int <= to_integer(unsigned(w_adr) xor to_unsigned(0, w_adr'length));
    r_adr_int <= to_integer(unsigned(r_adr) xor to_unsigned(0, r_adr'length));

    P_DEC : process(w_adr_int, we_gated)
        variable v_hit : natural range 0 to 31 := 0;
    begin
        W_EN_MASK <= (others => '0');
        case we_gated is
            when '1' =>
                v_hit := w_adr_int;
                W_EN_MASK(v_hit) <= '1';
            when others =>
                null;
        end case;
    end process;

    MASK_APPLY : process(W_EN_MASK)
        variable v_k : natural range 0 to 31 := 0;
    begin
        v_k := 0;
        loop
            W_EN(v_k) <= W_EN_MASK(v_k);
            exit when v_k = M-1;
            v_k := v_k + 1;
        end loop;
    end process;

    G_ARR : for i in 0 to M-1 generate
        U_REG : RegNBit
            generic map (N => N)
            port map (
                clk      => clk,
                rst      => rst,
                en       => W_EN(i),
                in_data  => w_data,
                out_data => R_OUT(i)
            );
    end generate G_ARR;

    r_data <= R_OUT(r_adr_int);

end architecture Behavioral;