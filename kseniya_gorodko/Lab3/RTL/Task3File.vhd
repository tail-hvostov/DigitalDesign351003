library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task3File is
    generic(m, n: natural := 4);
    port(
        clk, en_clk, rst: in std_logic;
        ra, wa: in std_logic_vector(integer(ceil(log2(real(m)))) - 1 downto 0);
        w: in std_logic_vector(n - 1 downto 0);
        r: out std_logic_vector(n - 1 downto 0)
    );
end Task3File;

architecture Behavioral of Task3File is
component Task3 is
    generic(n: natural := 34);
    port(
        clk, rst, en_clk: in std_logic;
        din: in std_logic_vector(n - 1 downto 0);
        dout: out std_logic_vector(n - 1 downto 0)
    );
end component Task3;
type t_reg_file is array(0 to m - 1) of std_logic_vector(n - 1 downto 0);
signal output: t_reg_file;
signal reg_en: std_logic_vector(n - 1 downto 0);
begin
    f: for i in 0 to m - 1 generate
        u: Task3 generic map(n => n) port map(clk => clk, en_clk => reg_en(i), rst => rst, din => w, dout => output(i));
    end generate f;
    
    p: process(wa, en_clk)
    begin
        reg_en <= (others => '0');
        if en_clk = '1' then
            reg_en(to_integer(unsigned(wa))) <= '1';
        end if;
    end process p;
     
    r <= output(to_integer(unsigned(ra)));
end Behavioral;
