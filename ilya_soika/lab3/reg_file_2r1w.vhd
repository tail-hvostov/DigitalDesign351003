library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reg_file_2r1w is
    generic (
        ADDR_WIDTH: integer := 5;
        DATA_WIDTH: integer := 16
    );
    port ( 
        CLK: in  std_logic; 
        CLR: in std_logic; 
        W_EN: in  std_logic; 
        W_ADDR: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
        W_DATA: in  std_logic_vector (DATA_WIDTH-1 downto 0); 
        R_ADDR_0: in  std_logic_vector (ADDR_WIDTH-1 downto 0); 
        R_DATA_0: out std_logic_vector (DATA_WIDTH-1 downto 0); 
        R_ADDR_1: in  std_logic_vector (ADDR_WIDTH-1 downto 0); 
        R_DATA_1: out std_logic_vector (DATA_WIDTH-1 downto 0)
     );
end reg_file_2r1w;

architecture Behavioral of reg_file_2r1w is
    constant M: integer := 2**ADDR_WIDTH;
    constant ZEROS: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    subtype t_reg_word is std_logic_vector(DATA_WIDTH-1 downto 0);
    type t_reg_file is array (0 to M-1) of t_reg_word;
    signal REG_FILE: t_reg_file;
    signal read_addr0: integer range 0 to M-1;
    signal read_addr1: integer range 0 to M-1;
    signal write_addr: integer range 0 to M-1;
begin
    read_addr0 <= conv_integer(R_ADDR_0);
    read_addr1 <= conv_integer(R_ADDR_1);
    write_addr <= conv_integer(W_ADDR);
    process(CLK, CLR)
    begin
        if CLR = '1' then
            for i in 0 to M-1 loop
                REG_FILE(i) <= ZEROS;
            end loop;
        elsif rising_edge(CLK) then
            if W_EN = '1' then
                REG_FILE(write_addr) <= W_DATA;
            end if;
        end if;
    end process;
    R_DATA_0 <= W_DATA when (W_EN = '1' and R_ADDR_0 = W_ADDR) else 
                REG_FILE(read_addr0);              
    R_DATA_1 <= W_DATA when (W_EN = '1' and R_ADDR_1 = W_ADDR) else 
                REG_FILE(read_addr1);
end Behavioral;
