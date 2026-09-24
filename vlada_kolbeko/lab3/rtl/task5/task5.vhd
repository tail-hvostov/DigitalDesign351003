library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task5 is
    generic (
        K       :   natural := 50000000;
        N       :   natural := 8
    );
    port (
        clk     : in    std_logic;
        sw_i    : in    std_logic_vector(15 downto 0);
        led_o   : out   std_logic_vector(15 downto 0)
    );
end task5;

architecture Structural of task5 is
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
    
    component universal_counter is
        generic (
            N       : natural   := 8
        );
        port (
            CLK     : in    std_logic;                          -- Q
            CLR     : in    std_logic;                          -- sw_i[2]
            EN      : in    std_logic;                          -- sw_i[3]
            MODE    : in    std_logic_vector(1 downto 0);       -- sw_i[5:4]
            LOAD    : in    std_logic;                          -- sw_i[6]
            D_IN    : in    std_logic_vector(N - 1 downto 0);   -- sw_i[14:7]
            D_OUT   : out   std_logic_vector(N - 1 downto 0)    -- led_o[7:0]
        ); 
    end component;
begin
    led_o(15 downto 8) <= (others => '0');
    
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
    
    universal_counter_0: universal_counter
    generic map (
        N => N
    )
    port map (
        CLK     => Q,
        CLR     => sw_i(2),
        EN      => sw_i(3),
        MODE    => sw_i(5 downto 4),
        LOAD    => sw_i(6),
        D_IN    => sw_i(14 downto 7),
        D_OUT   => led_o(7 downto 0)
    );
end Structural;