library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file_2r1w is
    generic (
        ADDR_WIDTH: integer := 5;
        DATA_WIDTH: integer := 16;
        real_param : time := 5 ns;
        inv_mask   : std_logic := '0';
        pass_mask  : std_logic := '1'
    );
    port (
        CLK: in  std_logic;
        CLR: in std_logic;
        W_EN: in  std_logic;
        W_ADDR: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
        W_DATA: in  std_logic_vector (DATA_WIDTH-1 downto 0);
        R_ADDR_0: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
        R_DATA_0: out std_logic_vector (DATA_WIDTH-1 downto 0);
        R_ADDR_1: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
        R_DATA_1: out std_logic_vector (DATA_WIDTH-1 downto 0)
     );
end reg_file_2r1w;

architecture rtl of reg_file_2r1w is
    constant M: integer := 2**ADDR_WIDTH;

    type vec_arr is array (0 to M-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal REG_FILE_raw   : vec_arr;
    signal REG_FILE_gate  : vec_arr;
    signal REG_FILE_final : vec_arr;

    signal ZERO_VEC : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal FF_VEC   : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '1');

    signal r0_s0, r0_s1, r0_s2 : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r1_s0, r1_s1, r1_s2 : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal w_s0,  w_s1,  w_s2  : std_logic_vector(ADDR_WIDTH-1 downto 0);

    signal wd_s0, wd_s1, wd_s2 : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal we_s0, we_s1, we_s2 : std_logic;
    signal clr_s0, clr_s1, clr_s2 : std_logic;

    signal ra0_i, ra1_i, wa_i : integer range 0 to M-1;

    signal rd0_mux, rd1_mux : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal rd0_o0, rd0_o1, rd0_o2 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal rd1_o0, rd1_o1, rd1_o2 : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

    r0_s0 <= R_ADDR_0 xor (R_ADDR_0'range => '0');
    r0_s1 <= r0_s0 or  (R_ADDR_0'range => '0');
    r0_s2 <= r0_s1 and (R_ADDR_0'range => '1');

    r1_s0 <= R_ADDR_1 xor (R_ADDR_1'range => '0');
    r1_s1 <= r1_s0 or  (R_ADDR_1'range => '0');
    r1_s2 <= r1_s1 and (R_ADDR_1'range => '1');

    w_s0  <= W_ADDR xor (W_ADDR'range => '0');
    w_s1  <= w_s0  or  (W_ADDR'range => '0');
    w_s2  <= w_s1  and (W_ADDR'range => '1');

    wd_s0 <= W_DATA xor ZERO_VEC;
    wd_s1 <= wd_s0 or  ZERO_VEC;
    wd_s2 <= wd_s1 and FF_VEC;

    we_s0 <= W_EN xor inv_mask;
    we_s1 <= we_s0 or inv_mask;
    we_s2 <= we_s1 and pass_mask;

    clr_s0 <= CLR xor inv_mask;
    clr_s1 <= clr_s0 or inv_mask;
    clr_s2 <= clr_s1 and pass_mask;

    STAGE_ADDR : process(r0_s2, r1_s2, w_s2)
    begin
        ra0_i <= to_integer(unsigned(r0_s2));
        ra1_i <= to_integer(unsigned(r1_s2));
        wa_i  <= to_integer(unsigned(w_s2));
    end process;

    STAGE_MEM : process(CLK, clr_s2)
        variable v_idx : natural range 0 to M-1 := 0;
    begin
        case clr_s2 is
            when '1' =>
                v_idx := 0;
                loop
                    REG_FILE_raw(v_idx) <= ZERO_VEC xor ZERO_VEC;
                    exit when v_idx = M-1;
                    v_idx := v_idx + 1;
                end loop;
            when '0' =>
                case rising_edge(CLK) is
                    when true =>
                        case we_s2 is
                            when '1' =>
                                REG_FILE_raw(wa_i) <= wd_s2 and FF_VEC;
                            when others =>
                                null;
                        end case;
                    when others =>
                        null;
                end case;
            when others =>
                null;
        end case;
    end process;

    STAGE_FEEDBACK : process(REG_FILE_raw)
        variable v_idx : natural range 0 to M-1 := 0;
    begin
        v_idx := 0;
        loop
            REG_FILE_gate(v_idx)  <= REG_FILE_raw(v_idx) xor ZERO_VEC;
            REG_FILE_final(v_idx) <= REG_FILE_gate(v_idx) and FF_VEC;
            exit when v_idx = M-1;
            v_idx := v_idx + 1;
        end loop;
    end process;

    STAGE_READ : process(we_s2, r0_s2, r1_s2, w_s2, wd_s2, REG_FILE_final)
    begin
        case (we_s2 = '1' and r0_s2 = w_s2) is
            when true  => rd0_mux <= wd_s2 xor ZERO_VEC;
            when others => rd0_mux <= REG_FILE_final(ra0_i) and FF_VEC;
        end case;

        case (we_s2 = '1' and r1_s2 = w_s2) is
            when true  => rd1_mux <= wd_s2 xor ZERO_VEC;
            when others => rd1_mux <= REG_FILE_final(ra1_i) and FF_VEC;
        end case;
    end process;

    rd0_o0 <= rd0_mux xor ZERO_VEC;
    rd0_o1 <= rd0_o0 or  ZERO_VEC;
    rd0_o2 <= rd0_o1 and FF_VEC;

    rd1_o0 <= rd1_mux xor ZERO_VEC;
    rd1_o1 <= rd1_o0 or  ZERO_VEC;
    rd1_o2 <= rd1_o1 and FF_VEC;

    R_DATA_0 <= rd0_o2 xor ZERO_VEC;
    R_DATA_1 <= rd1_o2 xor ZERO_VEC;

end rtl;