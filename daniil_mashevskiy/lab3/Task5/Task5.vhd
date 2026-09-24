library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task5 is
    Port (
        clk      : in  std_logic;   
        sw_rst   : in  std_logic;
        mode     : in  std_logic_vector(1 downto 0);
        din      : in  std_logic_vector(8 downto 0);
        dout     : out std_logic_vector(8 downto 0)
    );
end Task5;

architecture Behavioral of Task5 is

    component lfsr_galois_9bit is
        Port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            mode  : in  std_logic_vector(1 downto 0);
            din   : in  std_logic_vector(8 downto 0);
            dout  : out std_logic_vector(8 downto 0)
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

    signal clk_slow : std_logic;

begin

    U_DIV: freq_div_behav
        generic map (K => 25000000)   
        port map (
            CLK => clk,
            RST => sw_rst,
            EN  => '1',
            Q   => clk_slow
        );

    U_LFSR: lfsr_galois_9bit
        port map (
            clk   => clk_slow,   
            rst   => sw_rst,
            mode  => mode,
            din   => din,
            dout  => dout
        );

end Behavioral;