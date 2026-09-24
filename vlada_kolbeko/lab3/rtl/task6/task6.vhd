library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task6 is
    generic (
        K           :   natural := 1000;
        CNT_WIDTH   :   natural := 8
    );
    port (
        clk         : in    std_logic;
        sw_i        : in    std_logic_vector(15 downto 0);
        led_o       : out   std_logic_vector(15 downto 0)
    );
end task6;

architecture Structural of task6 is
    signal Q    :   std_logic;
    
    component freq_div_behav is
        generic (
            K   : natural   := 10
        );
        port (
            CLK : in    std_logic;  -- clk
            RST : in    std_logic;  -- sw_i[0]
            EN  : in    std_logic;  -- sw_i[1]
            Q   : out   std_logic
        );
    end component;
    
    component pwm_controller is
        generic (
            CNT_WIDTH   : natural   := 8        
        );
        port (
            CLK         : in    std_logic;                                  -- Q
            CLR         : in    std_logic;                                  -- sw_i[2]
            EN          : in    std_logic;                                  -- sw_i[3]
            FILL        : in    std_logic_vector(CNT_WIDTH - 1 downto 0);   -- sw_i[11:4]
            Q           : out   std_logic                                   -- led_o[0]
        );
    end component;
begin
    led_o(15 downto 12) <= (others => '0');
    
    freq_div_behav_0: freq_div_behav
    generic map (
        K => K
    )
    port map (
        CLK => clk,
        RST => sw_i(0),
        EN  => sw_i(1),
        Q   => Q
    );
    
    pwm_controller_0: pwm_controller
    generic map (
        CNT_WIDTH => CNT_WIDTH
    )
    port map (
        CLK     => Q,
        CLR     => sw_i(2),
        EN      => sw_i(3),
        FILL    => sw_i(11 downto 4),
        Q       => led_o(0)
    );
end Structural;