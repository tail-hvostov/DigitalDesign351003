library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task5Top is
    Port (
        clk   : in  std_logic;
        sw_i  : in  std_logic_vector (15 downto 0);
        led_o : out std_logic_vector (15 downto 0)
    );
end Task5Top;

architecture rtl of Task5Top is
    component universal_counter
        generic ( N : integer range 1 to 64 := 8 );
        port (
            CLK  : in std_logic;
            CLR  : in std_logic;
            EN   : in std_logic;
            MODE : in std_logic_vector (1 downto 0);
            LOAD : in std_logic;
            Din  : in std_logic_vector (N-1 downto 0);
            Dout : out std_logic_vector (N-1 downto 0)
        );
    end component;
    constant N : integer := 8;
    signal clk_div : unsigned(23 downto 0) := (others => '0');
    signal slow_clk : std_logic;
    signal dout_s : std_logic_vector(N-1 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            clk_div <= clk_div + 1;
        end if;
    end process;

    slow_clk <= std_logic(clk_div(23));

    COUNTER_INST: universal_counter
        generic map (N => N)
        port map (
            CLK  => slow_clk,
            CLR  => sw_i(15),         
            EN   => sw_i(14),            
            MODE => sw_i(13 downto 12),  
            LOAD => sw_i(11),              
            Din  => sw_i(7 downto 0),    
            Dout => dout_s
        );

    led_o(7 downto 0) <= dout_s;
end rtl;