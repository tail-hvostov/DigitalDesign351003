library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file is
    generic (
        M   : natural   := 4;
        N   : natural   := 4;
        A   : natural   := 2
    );
    port (
        INIT    : in    std_logic;                           -- Initialization, Active High
        WE      : in    std_logic;                           -- Write Enable, Active High
        CLK     : in    std_logic;                           -- System Clock, Rising Edge
        OE_N    : in    std_logic;                           -- Output Enable, Active Low
        WA      : in    std_logic_vector(A - 1 downto 0);    -- Write Address
        WDP     : in    std_logic_vector(N - 1 downto 0);    -- Write Data Port
        RA      : in    std_logic_vector(A - 1 downto 0);    -- Read Address
        RDP     : out   std_logic_vector(N - 1 downto 0)     -- Read Data Port
    );
end entity reg_file;

architecture Mixed of reg_file is
    subtype t_reg_word is std_logic_vector(N - 1 downto 0);
    type t_reg_file is array(0 to M - 1) of t_reg_word;
    
    constant ZEROS  : t_reg_word  := (others => '0');
    constant ALLZ   : t_reg_word  := (others => 'Z');
    
    signal s_reg_file               : t_reg_file;
    signal write_addr, read_addr    : integer range 0 to M - 1;
    
    signal reg_we   : std_logic_vector(M - 1 downto 0);
    
    component reg_unit is
        generic (
            N   : natural := 34
        );
        port (
            CLK     : in    std_logic;                          
            RST     : in    std_logic;                          
            EN      : in    std_logic;                          
            D_IN    : in    std_logic_vector(N - 1 downto 0);   
            D_OUT   : out   std_logic_vector(N - 1 downto 0)    
        );
    end component;
begin
    write_addr <= to_integer(unsigned(WA));
    read_addr <= to_integer(unsigned(RA));
    
    REG_FILE_U: for i in 0 to M - 1 generate
        reg_we(i) <= '1' when (WE = '1' and write_addr = i) else '0';
              
        REG_i: Reg_Unit
        generic map (
            N => N
        )
        port map (
            CLK => CLK,
            RST => INIT,
            EN => reg_we(i),
            D_IN => WDP,
            D_OUT => s_reg_file(i)
        );
    end generate REG_FILE_U;
    
    RDP <= s_reg_file(read_addr) when OE_N = '0' else ALLZ;
end Mixed;