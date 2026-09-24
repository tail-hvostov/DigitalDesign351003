library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file_2r1w is
    Generic (
        ADDR_WIDTH : natural := 5; --след 32 €чейки пам€ти
        DATA_WIDTH : natural := 16
    );
    Port (
        CLK : in std_logic;
        CLR : in std_logic;
        W_EN : in std_logic;
        W_ADDR : in std_logic_vector (ADDR_WIDTH-1 downto 0);
        W_DATA : in std_logic_vector (DATA_WIDTH-1 downto 0);
        R_ADDR_0 : in std_logic_vector (ADDR_WIDTH-1 downto 0);
        R_DATA_0 : out std_logic_vector (DATA_WIDTH-1 downto 0);
        R_ADDR_1 : in std_logic_vector (ADDR_WIDTH-1 downto 0);
        R_DATA_1 : out std_logic_vector (DATA_WIDTH-1 downto 0)
    );
end reg_file_2r1w;

architecture Behavioral of reg_file_2r1w is
-- массив из 32 €чеек по 16 бит 
    type reg_array is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal registers : reg_array := (others => (others => '0')); --все в ноль
begin
    -- —инхронна€ запись
    Main: process(CLK, CLR)
    begin
        if CLR = '1' then
            registers <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            if W_EN = '1' then
                registers(to_integer(unsigned(W_ADDR))) <= W_DATA;
            end if;
        end if;
    end process Main;

    -- јсинх чтение с механизмом Forwarding
    R_DATA_0 <= W_DATA when (W_EN = '1' and W_ADDR = R_ADDR_0) else 
                registers(to_integer(unsigned(R_ADDR_0)));
                
    R_DATA_1 <= W_DATA when (W_EN = '1' and W_ADDR = R_ADDR_1) else 
                registers(to_integer(unsigned(R_ADDR_1)));
end Behavioral;