library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity freq_div_behav_example is
    Port (
        sw: in std_logic_vector (15 downto 14);
        led : out std_logic_vector (15 downto 15);
        clk:  in std_logic
    );
end freq_div_behav_example;

architecture Behavioral of freq_div_behav_example is
    component freq_div_behav is
        Generic (K : positive := 10);
        Port (
            CLK : in std_logic;
            RST : in std_logic;
            EN  : in std_logic;
            Q   : out std_logic
        );
    end component;

    signal EN, RST, Q: std_logic;
begin
    EN <= sw(15);
    RST <= sw(14);

    FREQ_DIV: freq_div_behav
        Generic map (K => 50_000_000)
        Port map (CLK => CLK, RST => RST, EN => EN, Q => Q);

    led(15) <= Q;
end Behavioral;
