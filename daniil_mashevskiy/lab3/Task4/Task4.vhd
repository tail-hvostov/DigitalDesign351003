library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task4 is
    Generic (K : natural := 67108864);
    Port (
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic
    );
end Task4;

architecture Behavioral of Task4 is

    component freq_div_behav is
        Generic (K : natural := 10);
        Port (
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;

begin

    U0: freq_div_behav
        generic map (K => K)
        port map (
            CLK => clk,
            RST => rst,
            EN  => en,
            Q   => q
        );

end Behavioral;