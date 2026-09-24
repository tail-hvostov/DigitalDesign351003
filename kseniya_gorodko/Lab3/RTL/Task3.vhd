library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task3 is
    generic(n: natural := 34);
    port(
        clk, rst, en_clk: in std_logic;
        din: in std_logic_vector(n - 1 downto 0);
        dout: out std_logic_vector(n - 1 downto 0)
    );
end Task3;

architecture Behavioral of Task3 is
component Task2 is
-- sw_i(1) = d, sw_i(0) = clr_n
    port(
        sw_i: in std_logic_vector(1 downto 0);
        led_o: out std_logic_vector(0 to 0);
        clk: in std_logic
    );
end component Task2;
signal clr: std_logic := '1';
signal d: std_logic_vector(n - 1 downto 0);
begin
    f: for i in 0 to n - 1 generate
        u: Task2 port map(sw_i(1) => d(i), sw_i(0) => clr, led_o(0) => dout(i), clk => clk);
    end generate f;
    
    clr <= not rst when rising_edge(clk);
    
    d <= din when en_clk = '1';
end Behavioral;
