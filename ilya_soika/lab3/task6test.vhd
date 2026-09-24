library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_controller_tb is
end pwm_controller_tb;

architecture Behavioural of pwm_controller_tb is
    constant CNT_W : natural := 8;
    component pwm_controller
        generic ( CNT_WIDTH : natural := 8 );
        port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            FILL : in  std_logic_vector(CNT_WIDTH-1 downto 0);
            Q    : out std_logic
        );
    end component;
    signal CLK_tb  : std_logic := '0';
    signal CLR_tb  : std_logic := '0';
    signal EN_tb   : std_logic := '0';
    signal FILL_tb : std_logic_vector(CNT_W-1 downto 0) := (others => '0');
    signal Q_tb    : std_logic;
    constant CLK_PERIOD : time := 0.1 ns;
    constant PWM_PERIOD : time := CLK_PERIOD * 256;

begin
    UUT: pwm_controller
        generic map ( CNT_WIDTH => CNT_W )
        port map (
            CLK  => CLK_tb,
            CLR  => CLR_tb,
            EN   => EN_tb,
            FILL => FILL_tb,
            Q    => Q_tb
        );
    CLK_tb <= not CLK_tb after CLK_PERIOD / 2;
    
    process
    begin
        EN_tb   <= '1';
        FILL_tb <= x"00";
        CLR_tb  <= '1';
        wait for CLK_PERIOD * 4;
        assert Q_tb = '0'
            report "RESET FAILED: Q is not 0 during CLR=1" severity error;

        CLR_tb <= '0';
        wait for CLK_PERIOD * 2;

        FILL_tb <= x"00";
        wait for PWM_PERIOD;
        assert Q_tb = '0'
            report "FILL=0% FAILED: Q is not 0" severity error;

        FILL_tb <= x"40";
        wait for PWM_PERIOD * 2;
        report "25% running" severity note;

        FILL_tb <= x"80";
        wait for PWM_PERIOD * 2;
        report "50% running" severity note;

        FILL_tb <= x"C0";
        wait for PWM_PERIOD * 2;
        report "75% running" severity note;

        FILL_tb <= x"FF";
        wait for PWM_PERIOD * 2;
        wait until rising_edge(CLK_tb);
        wait for CLK_PERIOD / 4;
        assert Q_tb = '1'
            report "FILL=100% FAILED: Q is not '1' at period start" severity error;

        FILL_tb <= x"40";
        wait for PWM_PERIOD;
        report "Dynamic change: FILL=25%" severity note;

        FILL_tb <= x"C0";
        wait for PWM_PERIOD;
        report "Dynamic change: FILL=75%" severity note;

        FILL_tb <= x"80";
        wait for PWM_PERIOD;
        report "Dynamic change: FILL=50% - PASSED" severity note;

        FILL_tb <= x"80";
        EN_tb   <= '0';
        wait until rising_edge(CLK_tb);
        wait for CLK_PERIOD / 4;
        assert Q_tb = Q_tb
            report "EN=0 FAILED: Q is undefined"
            severity error;
        wait for CLK_PERIOD * 20;

        EN_tb <= '1';
        wait for CLK_PERIOD * 4;


        EN_tb   <= '0';
        CLR_tb  <= '0';
        FILL_tb <= x"00";
        wait for CLK_PERIOD * 10;
        report "Testbench complete" severity note;
        wait;

    end process;

end Behavioural;