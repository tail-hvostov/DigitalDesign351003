library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file_2r1w is
    generic (
        ADDR_WIDTH : natural := 5;
        DATA_WIDTH : natural := 16
    );
    port(
        CLK: in std_logic; -- System Clock, Rising Edge
        CLR: in std_logic; --Asyncronous reset, Active High
        W_EN: in std_logic; --Write enable, Active High
        W_ADDR: in std_logic_vector (ADDR_WIDTH-1 downto 0); -- Write address
        W_DATA: in std_logic_vector (DATA_WIDTH-1 downto 0); -- Write data
        R_ADDR_0: in std_logic_vector (ADDR_WIDTH-1 downto 0); -- Read address port 0
        R_DATA_0: out std_logic_vector (DATA_WIDTH-1 downto 0); -- Read data port 0
        R_ADDR_1: in std_logic_vector (ADDR_WIDTH-1 downto 0); -- Read address port 1
        R_DATA_1: out std_logic_vector (DATA_WIDTH-1 downto 0) -- Read data port 0
    );
end reg_file_2r1w;

architecture rtl of reg_file_2r1w is
    constant M : integer := 2**ADDR_WIDTH;
    subtype t_reg_word is std_logic_vector(DATA_WIDTH-1 downto 0);
    type t_reg_file is array (0 to M-1) of t_reg_word;
    signal REG_FILE : t_reg_file;
    signal write_adr : integer range 0 to M-1;
    signal read_adr0 : integer range 0 to M-1;
    signal read_adr1 : integer range 0 to M-1;
Begin
    write_adr <= to_integer(unsigned(W_ADDR));
    read_adr0 <= to_integer(unsigned(R_ADDR_0));
    read_adr1 <= to_integer(unsigned(R_ADDR_1));
      
    PWRITE: process (CLR, CLK, W_DATA, W_EN)
    begin
        if CLR = '1' then
           REG_FILE <= (others => (others => '0'));
        elsif rising_edge(CLK) then
           if W_EN = '1' then
               REG_FILE(write_adr) <= W_DATA;
           end if;
        end if;
    end process PWRITE;
    
    R_DATA_0 <= W_DATA when (W_EN = '1' and R_ADDR_0 = W_ADDR) else REG_FILE(read_adr0);
    R_DATA_1 <= W_DATA when (W_EN = '1' and R_ADDR_1 = W_ADDR) else REG_FILE(read_adr1);
end rtl;