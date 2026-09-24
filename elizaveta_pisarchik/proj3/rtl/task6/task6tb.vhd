library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task6_TB is
end Task6_TB;

architecture sim of Task6_TB is
    component pwm_controller
        generic ( CNT_WIDTH : natural := 8 );
        port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            FILL : in  std_logic_vector (CNT_WIDTH-1 downto 0);
            Q    : out std_logic
        );
    end component;
    constant W : integer := 8;
    constant T : time := 1 ns;
    signal CLK  : std_logic := '0';
    signal CLR  : std_logic;
    signal EN   : std_logic;
    signal FILL : std_logic_vector(W-1 downto 0);
    signal Q    : std_logic;
begin
    DUT: pwm_controller
        generic map (CNT_WIDTH => W)
        port map (
            CLK  => CLK,
            CLR  => CLR,
            EN   => EN,
            FILL => FILL,
            Q    => Q
        );

    CLK_PROCESS: process
    begin
        while true loop
            CLK <= '0'; wait for T/2;
            CLK <= '1'; wait for T/2;
        end loop;
    end process;

    TESTING: process
    begin
        CLR <= '1'; EN <= '0'; FILL <= (others => '0');
        wait for T * 2;
        CLR <= '0';
        wait for T;

        EN <= '1';
        FILL <= std_logic_vector(to_unsigned(0, W));
        wait for T * 300;

        FILL <= std_logic_vector(to_unsigned(64, W));
        wait for T * 300;

        FILL <= std_logic_vector(to_unsigned(128, W));
        wait for T * 300;

        wait for T * 100;
        FILL <= std_logic_vector(to_unsigned(192, W)); 
        wait for T * 300;

        FILL <= (others => '1');
        wait for T * 300;

        EN <= '0';
        wait for T * 100;

        EN <= '1';
        FILL <= (others => '1');
        wait for T * 50;
        CLR <= '1';
        wait for T * 20;
        CLR <= '0';

        report "PWM CONTROLLER TEST DONE" severity note;
        wait;
    end process;
end sim;