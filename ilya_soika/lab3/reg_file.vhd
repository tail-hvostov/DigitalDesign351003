library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity reg_file is
    generic (
        M: natural := 8;   
        N: natural := 34  
    );
    port(
        CLK: in  std_logic;
        RST: in  std_logic;
        WEN: in  std_logic;
        WADDR: in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
        WDATA: in  std_logic_vector(N-1 downto 0);
        RADDR: in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
        RDATA: out std_logic_vector(N-1 downto 0)
    );
end reg_file;

architecture behavioural of reg_file is
    component reg_unit is
        generic (N: natural := 34 );
        port(
            CLK: in  std_logic;
            RST: in  std_logic;
            EN: in  std_logic;
            Din: in  std_logic_vector(N-1 downto 0);
            Dout: out std_logic_vector(N-1 downto 0)
        );
    end component;
    subtype t_reg_word is std_logic_vector(N-1 downto 0);
    type t_reg_file is array (0 to M-1) of t_reg_word;
    signal REGFILE : t_reg_file;
    signal EN_vector : std_logic_vector(M-1 downto 0);
begin
    WRITE_ENABLE_PROCESS: process(WADDR, WEN)
    begin
        EN_vector <= (others => '0');
        if WEN = '1' then
            EN_vector(to_integer(unsigned(WADDR))) <= '1';
        end if;
    end process WRITE_ENABLE_PROCESS;

    GEN_REG: for i in 0 to M-1 generate
        REG: reg_unit
            generic map ( N => N )
            port map (
                CLK => CLK,
                RST => RST,
                EN => EN_vector(i),
                Din => WDATA,
                Dout => REGFILE(i)
            );
    end generate GEN_REG;
    RDATA <= REGFILE(to_integer(unsigned(RADDR)));
end behavioural;