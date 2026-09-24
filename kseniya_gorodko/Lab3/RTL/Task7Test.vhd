library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity Task7Test is
end Task7Test;

architecture Behavioral of Task7Test is
component Task7 is
    generic(
        addr_width: natural := 2;
        data_width: natural := 2
    );
    port(
        clk: in std_logic;
        clr: in std_logic;  -- async reset active high
        w_en: in std_logic;
        w_addr: in std_logic_vector(addr_width - 1 downto 0);
        w_data: in std_logic_vector(data_width - 1 downto 0);
        r_addr_0: in std_logic_vector(addr_width - 1 downto 0);
        r_data_0: out std_logic_vector(data_width - 1 downto 0);
        r_addr_1: in std_logic_vector(addr_width - 1 downto 0);
        r_data_1: out std_logic_vector(data_width - 1 downto 0)
    );
end component Task7;
constant a_width: natural := 2;
constant d_width: natural := 2;
signal clk, clr, w_en: std_logic;
signal w_addr, r_addr_0, r_addr_1: std_logic_vector(a_width - 1 downto 0);
signal w_data, r_data_0, r_data_1: std_logic_vector(d_width - 1 downto 0);
constant t: time := 10ns;
begin
--ѕоследовательна€ запись значений в несколько регистров;
--ѕоследовательное чтение из разных регистров;
--„тение и запись по одному и тому же адресу в одном такте (проверка forwarding);
--ќдновременна€ запись в регистр и чтение из двух других регистров, при различных адресах дл€ портов записи и чтени€.
--ѕопытка записи при выключенном W_EN;
--—брос и проверка обнулени€ всех регистров.
    u: Task7 generic map(addr_width => a_width, data_width => d_width)
    port map(clk => clk, clr => clr, w_en => w_en, w_addr => w_addr, r_addr_0 => r_addr_0,
    r_addr_1 => r_addr_1, w_data => w_data, r_data_0 => r_data_0, r_data_1 => r_data_1);

    pclk: process is
    begin
        clk <= '0'; wait for t / 2;
        clk <= '1'; wait for t / 2;
    end process pclk;

    p: process is
    begin
        w_en <= '1';
        w_addr <= "00";
        r_addr_0 <= "00";
        w_data <= "11";
        wait for t;
        
        w_addr <= "11";
        r_addr_0 <= "11";
        w_data <= "10";
        wait for t;
        
        w_data <= "11";
        wait for t;
                
        w_data <= "00";
        wait for t;
                        
        w_data <= "01";
        wait for t;
        
        r_addr_0 <= "00";
        r_addr_1 <= "01";
        wait for t;
        
        clr <= '1';
        wait for t;
        r_addr_0 <= "10";
        r_addr_1 <= "11";
        wait for t;
        
        w_en <= '0';
        w_addr <= "10";
        w_data <= "01";
        wait for t;
        
        w_en <= '1';
        wait for t;
        
        report "End of simulation" severity failure;
    end process p;
end Behavioral;
