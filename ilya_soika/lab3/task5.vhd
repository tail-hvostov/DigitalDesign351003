library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task5 is
    port (
        clk: in  std_logic;
        sw: in  std_logic_vector(15 downto 0);
        led: out std_logic_vector(15 downto 0);
        btnC: in  std_logic;
        btnU: in  std_logic;
        btnR: in  std_logic
    );
end task5;

architecture Behavioural of task5 is
    constant K_DIV: natural := 25_000_000;
    signal clk_slow: std_logic;
    component freq_div_behav is
        generic (K : natural := 10);
        port (
            CLK: in  std_logic;
            RST: in  std_logic;
            EN: in  std_logic;
            Q: out std_logic
        );
    end component;
    component universal_counter is
        generic (N : natural := 16);
        port (
            CLK: in  std_logic;
            CLR: in  std_logic;
            EN: in  std_logic;
            MODE: in  std_logic_vector(2 downto 0);
            LOAD: in  std_logic;
            Din: in  std_logic_vector(N-1 downto 0);
            Dout: out std_logic_vector(N-1 downto 0)
        );
    end component;
begin
    u_div : freq_div_behav
        generic map (K => K_DIV)
        port map (
            CLK => clk,
            RST => btnC, 
            EN => '1',
            Q => clk_slow
        );
    u_lfsr : universal_counter
        generic map (N => 16)
        port map (
            CLK => clk_slow,
            CLR => btnC,       
            EN => btnU,     
            MODE => "000",     
            LOAD => btnR,       
            Din => sw,         
            Dout => led        
        );
end Behavioural;