library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end entity top_tb;

architecture Behavioural of top_tb is

    component RSlatch is
        generic (
            gate_delay : time;
            keep_attr  : string
        );
        port (
            S  : in  std_logic;
            R  : in  std_logic;
            Q  : out std_logic;
            nQ : out std_logic
        );
    end component RSlatch;

    signal S_tb  : std_logic := '0';
    signal R_tb  : std_logic := '0';
    signal Q_tb  : std_logic := '0';
    signal nQ_tb : std_logic := '0';

    signal s_phase   : natural range 0 to 7  := 0;
    signal s_done    : std_logic             := '0';
    signal s_s_buf   : std_logic             := '0';
    signal s_r_buf   : std_logic             := '0';

    constant DELAY_SHORT : time := 50  ns;
    constant DELAY_LONG  : time := 200 ns;
    constant GATE_DLY    : time := 5   ns;

    type sr_pair_t is record
        s_val : std_logic;
        r_val : std_logic;
    end record;

    type phase_lut_t is array (0 to 6) of sr_pair_t;
    constant PHASE_LUT : phase_lut_t := (
        0 => (s_val => '0', r_val => '0'),
        1 => (s_val => '1', r_val => '0'),
        2 => (s_val => '0', r_val => '0'),
        3 => (s_val => '0', r_val => '1'),
        4 => (s_val => '0', r_val => '0'),
        5 => (s_val => '1', r_val => '1'),
        6 => (s_val => '0', r_val => '0')
    );

begin

    UUT : RSlatch
        generic map (
            gate_delay => GATE_DLY,
            keep_attr  => "TRUE"
        )
        port map (
            S  => S_tb,
            R  => R_tb,
            Q  => Q_tb,
            nQ => nQ_tb
        );

    s_s_buf <= S_tb xor '0';
    s_r_buf <= R_tb or  '0';

    STIM : process
        variable v_phase : natural range 0 to 7 := 0;
        variable v_s     : std_logic := '0';
        variable v_r     : std_logic := '0';
    begin

        v_phase := 0;
        loop
            v_s := PHASE_LUT(v_phase).s_val;
            v_r := PHASE_LUT(v_phase).r_val;

            S_tb <= v_s;
            R_tb <= v_r;

            case v_phase is
                when 6      => wait for DELAY_LONG;
                when others => wait for DELAY_SHORT;
            end case;

            case v_phase is
                when 1 =>
                    assert Q_tb = '1' and nQ_tb = '0'
                        report "SET FAILED: Q=" & std_logic'image(Q_tb) &
                               " nQ=" & std_logic'image(nQ_tb)
                        severity error;
                    s_phase <= v_phase;

                when 3 =>
                    assert Q_tb = '0' and nQ_tb = '1'
                        report "RESET FAILED: Q=" & std_logic'image(Q_tb) &
                               " nQ=" & std_logic'image(nQ_tb)
                        severity error;
                    s_phase <= v_phase;

                when 5 =>
                    assert Q_tb = '0' and nQ_tb = '0'
                        report "Forbidden state outputs not both 0" severity warning;
                    report "Releasing forbidden state -> oscillation expected" severity note;
                    s_phase <= v_phase;

                when 6 =>
                    assert (Q_tb = '0' and nQ_tb = '1') or
                           (Q_tb = '1' and nQ_tb = '0')
                        report "After oscillation: metastable or still oscillating!"
                        severity warning;
                    s_phase <= v_phase;

                when others =>
                    null;
            end case;

            exit when v_phase = 6;
            v_phase := v_phase + 1;
        end loop;

        report "Testbench complete" severity note;
        s_done <= '1';
        wait;

    end process STIM;

end architecture Behavioural;