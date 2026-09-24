library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task6Top is
    Port (
        clk   : in  std_logic;
        sw_i  : in  std_logic_vector (15 downto 0);
        led_o : out std_logic_vector (15 downto 0)
    );
end Task6Top;

architecture rtl of Task6Top is
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
    signal clk_div_reg : unsigned(9 downto 0) := (others => '0');
    signal pwm_clk     : std_logic := '0';
    signal pwm_out_s   : std_logic;
begin
    PWM_INST: pwm_controller
        generic map (
            CNT_WIDTH => 8
        )
        port map (
            CLK  => pwm_clk,
            CLR  => sw_i(15), 
            EN   => sw_i(14),     
            FILL => sw_i(7 downto 0),
            Q    => pwm_out_s
        );    
        
    process(clk)
    begin
        if rising_edge(clk) then
            clk_div_reg <= clk_div_reg + 1;
        end if;
    end process;
    
    pwm_clk <= std_logic(clk_div_reg(9));

    led_o(0) <= pwm_out_s;
end rtl;