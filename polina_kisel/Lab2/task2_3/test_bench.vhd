library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is
end test_bench;

architecture behavioral of test_bench is

    component task2_1
        Port(
            G3, G2, G1, G0 : in  std_logic;
            L3, L2, L1, L0 : out std_logic
        );
    end component;

    signal G3_W, G2_W, G1_W, G0_W : std_logic;
    signal L3_W, L2_W, L1_W, L0_W : std_logic;
    signal L_vec : std_logic_vector(3 downto 0);

begin
    L_vec <= L3_W & L2_W & L1_W & L0_W;

    UUT: task2_1
        port map(
            G3 => G3_W,
            G2 => G2_W,
            G1 => G1_W,
            G0 => G0_W,
            L3 => L3_W,
            L2 => L2_W,
            L1 => L1_W,
            L0 => L0_W
        );

    sim: process
    begin

        report "Start simulation";

        -- 0
        G3_W <= '0'; G2_W <= '0'; G1_W <= '0'; G0_W <= '0';
        wait for 20 ns;
        assert L_vec = "0000"
        report "Error for input 0000"
        severity error;

        -- 1
        G3_W <= '0'; G2_W <= '0'; G1_W <= '0'; G0_W <= '1';
        wait for 20 ns;
        assert L_vec = "0001"
        report "Error for input 0001"
        severity error;

        -- 2
        G3_W <= '0'; G2_W <= '0'; G1_W <= '1'; G0_W <= '0';
        wait for 20 ns;
        assert L_vec = "0010"
        report "Error for input 0010"
        severity error;

        -- 3
        G3_W <= '0'; G2_W <= '0'; G1_W <= '1'; G0_W <= '1';
        wait for 20 ns;
        assert L_vec = "0100"
        report "Error for input 0011"
        severity error;

        -- 4
        G3_W <= '0'; G2_W <= '1'; G1_W <= '0'; G0_W <= '0';
        wait for 20 ns;
        assert L_vec = "0101"
        report "Error for input 0100"
        severity error;

        -- 5
        G3_W <= '1'; G2_W <= '0'; G1_W <= '1'; G0_W <= '1';
        wait for 20 ns;
        assert L_vec = "0110"
        report "Error for input 1011"
        severity error;

        -- 6
        G3_W <= '1'; G2_W <= '1'; G1_W <= '0'; G0_W <= '0';
        wait for 20 ns;
        assert L_vec = "1000"
        report "Error for input 1100"
        severity error;

        -- 7
        G3_W <= '1'; G2_W <= '1'; G1_W <= '0'; G0_W <= '1';
        wait for 20 ns;
        assert L_vec = "1001"
        report "Error for input 1101"
        severity error;

        -- 8
        G3_W <= '1'; G2_W <= '1'; G1_W <= '1'; G0_W <= '0';
        wait for 20 ns;
        assert L_vec = "1010"
        report "Error for input 1110"
        severity error;

        -- 9
        G3_W <= '1'; G2_W <= '1'; G1_W <= '1'; G0_W <= '1';
        wait for 20 ns;
        assert L_vec = "1100"
        report "Error for input 1111"
        severity error;

        report "Simulation finished successfully";

        wait;

    end process;

end behavioral;