library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench2_4 is
end test_bench2_4;

architecture behavioral of test_bench2_4 is

    component comp_3bit
        Port(
            X0, X1, X2 : in std_logic;
            Y0, Y1, Y2 : in std_logic;
            Eq_out, Gt_out, Lt_out : out std_logic
        );
    end component;

    signal X0_W, X1_W, X2_W : std_logic;
    signal Y0_W, Y1_W, Y2_W : std_logic;

    signal Eq_out_W : std_logic;
    signal Gt_out_W : std_logic;
    signal Lt_out_W : std_logic;

begin

    UUT: comp_3bit
        port map(
            X0 => X0_W,
            X1 => X1_W,
            X2 => X2_W,
            Y0 => Y0_W,
            Y1 => Y1_W,
            Y2 => Y2_W,
            Eq_out => Eq_out_W,
            Gt_out => Gt_out_W,
            Lt_out => Lt_out_W
        );

    stim_proc: process
    begin

        report "START TEST";

        ------------------------------------------------
        -- TEST 1  (0 = 0)
        ------------------------------------------------
        X2_W <= '0'; X1_W <= '0'; X0_W <= '0';
        Y2_W <= '0'; Y1_W <= '0'; Y0_W <= '0';
        wait for 20 ns;

        assert (Eq_out_W='1' and Gt_out_W='0' and Lt_out_W='0')
        report "ERROR TEST1"
        severity error;

--1 > 0
        X2_W <= '0'; X1_W <= '0'; X0_W <= '1';
        Y2_W <= '0'; Y1_W <= '0'; Y0_W <= '0';
        wait for 20 ns;

        assert (Eq_out_W='0' and Gt_out_W='1' and Lt_out_W='0')
        report "ERROR TEST2"
        severity error;

-- 2 < 3
        X2_W <= '0'; X1_W <= '1'; X0_W <= '0';
        Y2_W <= '0'; Y1_W <= '1'; Y0_W <= '1';
        wait for 20 ns;

        assert (Eq_out_W='0' and Gt_out_W='0' and Lt_out_W='1')
        report "ERROR TEST3"
        severity error;

--3 > 2
        X2_W <= '0'; X1_W <= '1'; X0_W <= '1';
        Y2_W <= '0'; Y1_W <= '1'; Y0_W <= '0';
        wait for 20 ns;

        assert (Eq_out_W='0' and Gt_out_W='1' and Lt_out_W='0')
        report "ERROR TEST4"
        severity error;

-- 4 = 4

        X2_W <= '1'; X1_W <= '0'; X0_W <= '0';
        Y2_W <= '1'; Y1_W <= '0'; Y0_W <= '0';
        wait for 20 ns;

        assert (Eq_out_W='1' and Gt_out_W='0' and Lt_out_W='0')
        report "ERROR TEST5"
        severity error;

        report "ALL TESTS PASSED";

        wait;

    end process;

end behavioral;