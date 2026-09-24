library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file_2r1w is
    generic (
        ADDR_WIDTH : natural := 5;  
        DATA_WIDTH : natural := 16  
    );
    port (
        CLK      : in  std_logic;
        CLR      : in  std_logic; 
        W_EN     : in  std_logic; 
        W_ADDR   : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
        W_DATA   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        R_ADDR_0 : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
        R_DATA_0 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        R_ADDR_1 : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
        R_DATA_1 : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end reg_file_2r1w;

architecture Behavioral of reg_file_2r1w is
    constant M     : integer := 2**ADDR_WIDTH;
    
    subtype t_reg_word is std_logic_vector(DATA_WIDTH - 1 downto 0);
    type t_reg_file is array (0 to M - 1) of t_reg_word;
    
    signal REG_FILE : t_reg_file;
    
    signal w_idx, r0_idx, r1_idx : integer range 0 to M - 1;

begin
    w_idx  <= to_integer(unsigned(W_ADDR));
    r0_idx <= to_integer(unsigned(R_ADDR_0));
    r1_idx <= to_integer(unsigned(R_ADDR_1));

    P0: process (CLK, CLR)
    begin
        if CLR = '1' then
            for i in 0 to M - 1 loop
                REG_FILE(i) <= (others => '0');
            end loop;
        elsif rising_edge(CLK) then
            if W_EN = '1' then
                REG_FILE(w_idx) <= W_DATA;
            end if;
        end if;
    end process P0;

    R_DATA_0 <= W_DATA when (W_EN = '1' and W_ADDR = R_ADDR_0) else 
                REG_FILE(r0_idx);

    R_DATA_1 <= W_DATA when (W_EN = '1' and W_ADDR = R_ADDR_1) else 
                REG_FILE(r1_idx);
end Behavioral;