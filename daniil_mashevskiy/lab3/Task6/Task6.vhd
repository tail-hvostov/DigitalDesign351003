library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task6 is
    Generic (
        CNT_WIDTH : natural := 8
    );
    Port (
        CLK   : in  std_logic;
        CLR   : in  std_logic;
        EN    : in  std_logic;
        FILL  : in  std_logic_vector(CNT_WIDTH-1 downto 0);
        Q     : out std_logic
    );
end Task6;

architecture Behavioral of Task6 is

    component pwm_controller is
        Generic (CNT_WIDTH : natural := 8);
        Port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            FILL : in  std_logic_vector(CNT_WIDTH-1 downto 0);
            Q    : out std_logic
        );
    end component;

    component freq_div_behav is
        Generic (K : natural := 10);
        Port (
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;

    signal clk_div : std_logic;

begin

    U_DIV: freq_div_behav
        generic map (K => 10000)
        port map (
            CLK => CLK,
            RST => CLR,
            EN  => '1',
            Q   => clk_div
        );

    U_PWM: pwm_controller
        generic map (CNT_WIDTH => CNT_WIDTH)
        port map (
            CLK  => clk_div,
            CLR  => CLR,
            EN   => EN,
            FILL => FILL,
            Q    => Q
        );

end Behavioral;