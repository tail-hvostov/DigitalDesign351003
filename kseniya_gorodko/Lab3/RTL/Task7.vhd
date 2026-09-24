library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task7 is
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
end Task7;

architecture Behavioral of Task7 is
type t_reg_file is array(0 to 2 ** addr_width - 1) of std_logic_vector(data_width - 1 downto 0);
signal reg_file: t_reg_file;
begin
    p: process(clk, clr, w_en, w_addr) is
    begin
        if clr = '1' then
            reg_file <= (others => (others => '0'));
        elsif rising_edge(clk) and w_en = '1' then
            reg_file(to_integer(unsigned(w_addr))) <= w_data;
        end if;
    end process p;
    
    r_data_0 <= reg_file(to_integer(unsigned(r_addr_0)));
    r_data_1 <= reg_file(to_integer(unsigned(r_addr_1)));
end Behavioral;
