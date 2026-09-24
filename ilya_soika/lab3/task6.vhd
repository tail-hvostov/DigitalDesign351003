library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity task6 is
    port (
        clk: in  std_logic;
        sw: in  std_logic_vector(7 downto 0); 
        led: out std_logic_vector(15 downto 0)
    );
end task6;

architecture behavioral of task6 is
    component freq_div_behav is
        generic (K : natural := 10);
        port (
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;
    component pwm_controller is
        generic (CNT_WIDTH : natural := 8);
        port (
            CLK  : in  std_logic;
            CLR  : in  std_logic;
            EN   : in  std_logic;
            FILL : in  std_logic_vector(CNT_WIDTH-1 downto 0);
            Q    : out std_logic
        );
    end component;
    constant K_DIV: integer := 1952;
    signal clk_pwm : std_logic;
    signal fill_8 : std_logic_vector(7 downto 0);
    signal pwm_out : std_logic;
begin
    u_div : freq_div_behav
        generic map (K => K_DIV)
        port map (
            CLK => clk,
            RST => '0',
            EN  => '1',
            Q   => clk_pwm
        );
    fill_8 <= sw;
    u_pwm : pwm_controller
            generic map (CNT_WIDTH => 8)
            port map (
                CLK  => clk_pwm,
                CLR  => '0',
                EN   => '1',
                FILL => fill_8,
                Q    => pwm_out
            );
    led(15 downto 0) <= (others => pwm_out);
end behavioral;