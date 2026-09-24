library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_unit_tb is
end reg_unit_tb;

architecture Behavioural of reg_unit_tb is
    constant N : natural := 34;
    component reg_unit
        generic ( N: natural := 34 );
        port(
            CLK : in  std_logic;
            RST : in  std_logic;
            EN : in  std_logic;
            Din : in  std_logic_vector(N-1 downto 0);
            Dout : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal CLK_tb : std_logic := '0';
    signal RST_tb : std_logic := '0';
    signal EN_tb : std_logic := '0';
    signal Din_tb : std_logic_vector(N-1 downto 0) := (others => '0');
    signal Dout_tb : std_logic_vector(N-1 downto 0);

    constant CLK_PERIOD : time := 20 ns;

    constant DATA_A : std_logic_vector(N-1 downto 0) :=
        "01" & x"ABCDEF01"; 
    constant DATA_B : std_logic_vector(N-1 downto 0) :=
        "11" & x"12345678";
    constant ZEROS : std_logic_vector(N-1 downto 0) := (others => '0');

begin

    UUT: reg_unit
        generic map ( N => N )
        port map (
            CLK  => CLK_tb,
            RST  => RST_tb,
            EN   => EN_tb,
            Din  => Din_tb,
            Dout => Dout_tb
        );

    CLK_tb <= not CLK_tb after CLK_PERIOD / 2;

    process
    begin
        RST_tb <= '0'; EN_tb <= '0'; Din_tb <= DATA_A;
        wait for 50 ns;

        RST_tb <= '1'; Din_tb <= DATA_A;
        wait until rising_edge(CLK_tb);
        wait for 5 ns;
        assert Dout_tb = ZEROS
            report "RESET FAILED: Dout is not zero after synchronous reset" severity error;

        RST_tb <= '0'; EN_tb <= '0'; Din_tb <= DATA_A;
        wait until rising_edge(CLK_tb);
        wait for 5 ns;
        assert Dout_tb = ZEROS
            report "HOLD FAILED: Dout changed while EN=0" severity error;

        Din_tb <= DATA_B;
        wait until rising_edge(CLK_tb);
        wait for 5 ns;
        assert Dout_tb = ZEROS
            report "HOLD FAILED: Dout changed while EN=0 (DATA_B on input)" severity error;
        report "Hold mode (EN=0): PASSED" severity note;

        Din_tb <= DATA_A;
        EN_tb  <= '1';
        wait until rising_edge(CLK_tb);
        wait for 5 ns;
        assert Dout_tb = DATA_A
            report "WRITE FAILED: Dout /= DATA_A after load" severity error;
        report "Write DATA_A (EN=1): PASSED" severity note;

        Din_tb <= DATA_B;
        wait until rising_edge(CLK_tb);
        wait for 5 ns;
        assert Dout_tb = DATA_B
            report "WRITE FAILED: Dout /= DATA_B after second load" severity error;
        report "Write DATA_B (EN=1): PASSED" severity note;

        EN_tb  <= '0';
        Din_tb <= DATA_A;
        wait until rising_edge(CLK_tb);
        wait for 5 ns;
        assert Dout_tb = DATA_B
            report "HOLD FAILED: Dout changed after EN went low" severity error;
        report "Return to hold mode (EN=0): PASSED" severity note;

        RST_tb <= '1'; EN_tb <= '1'; Din_tb <= DATA_A;
        wait until rising_edge(CLK_tb);
        wait for 5 ns;
        assert Dout_tb = ZEROS
            report "RESET PRIORITY FAILED: RST did not override EN" severity error;
        report "Reset priority over EN: PASSED" severity note;

        RST_tb <= '0'; EN_tb <= '0';
        wait for 50 ns;
        report "Testbench complete" severity note;
        wait;
    end process;

end Behavioural;