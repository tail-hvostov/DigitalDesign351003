library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_controller_tb is
end pwm_controller_tb;

architecture rtl of pwm_controller_tb is

    component pwm_controller is
        Generic ( CNT_WIDTH : natural := 8 );
        Port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            FILL : in  std_logic_vector(CNT_WIDTH-1 downto 0);
            Q    : out std_logic
        );
    end component;

    constant CNT_WIDTH  : natural := 8;
    constant CLK_PERIOD : time := 20 ns;
    constant PERIOD     : integer := 2**CNT_WIDTH;

    signal CLK  : std_logic := '0';
    signal CLR  : std_logic := '0';
    signal EN   : std_logic := '0';
    signal FILL : std_logic_vector(CNT_WIDTH-1 downto 0) := (others => '0');
    signal Q    : std_logic;

begin

    UUT: pwm_controller
        generic map ( CNT_WIDTH => CNT_WIDTH )
        port map (
            CLK  => CLK,
            CLR  => CLR,
            EN   => EN,
            FILL => FILL,
            Q    => Q
        );

    CLK_proc: process
    begin
        while now < 200000 ns loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    STIM: process
        variable cnt : integer;
    begin
        CLR  <= '0'; EN <= '0';
        FILL <= (others => '0');
        wait for CLK_PERIOD;

        EN  <= '1';
        FILL <= (others => '1');
        wait for CLK_PERIOD * 5;

        CLR <= '1';
        wait for 1 ns;
        assert (Q = '0') severity error;
        CLR <= '0';

        CLR <= '1'; wait for 1 ns; CLR <= '0';
        FILL <= (others => '0');

        wait for PERIOD * CLK_PERIOD;

        assert (Q = '0') severity error;

        CLR <= '1'; wait for 1 ns; CLR <= '0';
        FILL <= std_logic_vector(to_unsigned(64, CNT_WIDTH));

        cnt := 0;
        for i in 0 to PERIOD-1 loop
            wait until rising_edge(CLK);
            if Q = '1' then
                cnt := cnt + 1;
            end if;
        end loop;

        assert (cnt = 64) severity error;

        CLR <= '1'; wait for 1 ns; CLR <= '0';
        FILL <= std_logic_vector(to_unsigned(128, CNT_WIDTH));

        cnt := 0;
        for i in 0 to PERIOD-1 loop
            wait until rising_edge(CLK);
            if Q = '1' then
                cnt := cnt + 1;
            end if;
        end loop;

        assert (cnt = 128) severity error;

        CLR <= '1'; wait for 1 ns; CLR <= '0';
        FILL <= std_logic_vector(to_unsigned(192, CNT_WIDTH));

        cnt := 0;
        for i in 0 to PERIOD-1 loop
            wait until rising_edge(CLK);
            if Q = '1' then
                cnt := cnt + 1;
            end if;
        end loop;

        assert (cnt = 192) severity error;

        CLR <= '1'; wait for 1 ns; CLR <= '0';
        FILL <= std_logic_vector(to_unsigned(255, CNT_WIDTH));

        cnt := 0;
        for i in 0 to PERIOD-1 loop
            wait until rising_edge(CLK);
            if Q = '1' then
                cnt := cnt + 1;
            end if;
        end loop;

        assert (cnt = 255) severity error;

        EN <= '0';
        wait for CLK_PERIOD * 10;

        assert (Q = '0') severity error;

        EN <= '1';
        CLR <= '1'; wait for 1 ns; CLR <= '0';

        FILL <= std_logic_vector(to_unsigned(64, CNT_WIDTH));
        wait for PERIOD * CLK_PERIOD;

        FILL <= std_logic_vector(to_unsigned(192, CNT_WIDTH));

        cnt := 0;
        for i in 0 to PERIOD-1 loop
            wait until rising_edge(CLK);
            if Q = '1' then
                cnt := cnt + 1;
            end if;
        end loop;

        assert (cnt = 192) severity error;

        report "testbench finished";
        wait;
    end process;

end rtl;