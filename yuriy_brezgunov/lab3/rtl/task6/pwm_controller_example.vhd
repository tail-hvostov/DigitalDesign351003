library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pwm_controller_example is
    Port (
        clk       : in  std_logic;
        sw        : in  std_logic_vector(15 downto 6);
        led       : out std_logic_vector(15 downto 15)
    );
end pwm_controller_example;

architecture rtl of pwm_controller_example is
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

begin

    UUT: pwm_controller
        generic map ( CNT_WIDTH => 8 )
        port map (
            CLK  => CLK,
            CLR  => SW(6),
            EN   => SW(7),
            FILL => SW(15 downto 8),
            Q    => LED(15)
        );

end rtl;