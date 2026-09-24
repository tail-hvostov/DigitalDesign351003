library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Task7 is
    Generic (
        ADDR_WIDTH : natural := 5;
        DATA_WIDTH : natural := 16
    );
    Port (
        CLK      : in  std_logic;
        CLR      : in  std_logic;
        W_EN     : in  std_logic;
        W_ADDR   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        W_DATA   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        R_ADDR_0 : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        R_DATA_0 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        R_ADDR_1 : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        R_DATA_1 : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end Task7;

architecture Behavioral of Task7 is

    constant DEPTH : natural := 2**ADDR_WIDTH;
    
    type reg_array_t is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal regs : reg_array_t := (others => (others => '0'));
    
    attribute RAM_STYLE : string;
    attribute RAM_STYLE of regs : signal is "distributed";

begin

    process(CLK, CLR)
    begin
        if CLR = '1' then
            regs <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            if W_EN = '1' then
                regs(to_integer(unsigned(W_ADDR))) <= W_DATA;
            end if;
        end if;
    end process;

    process(R_ADDR_0, R_ADDR_1, W_ADDR, W_DATA, W_EN, regs)
    begin
        if W_EN = '1' and R_ADDR_0 = W_ADDR then
            R_DATA_0 <= W_DATA;
        else
            R_DATA_0 <= regs(to_integer(unsigned(R_ADDR_0)));
        end if;
        
        if W_EN = '1' and R_ADDR_1 = W_ADDR then
            R_DATA_1 <= W_DATA;
        else
            R_DATA_1 <= regs(to_integer(unsigned(R_ADDR_1)));
        end if;
    end process;

end Behavioral;