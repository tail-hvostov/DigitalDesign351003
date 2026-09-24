library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity reg_file is
    generic (
        M: integer := 2;
        N: integer := 8
    );
    port (
        CLK: in std_logic;
        RST: in std_logic;
        WE: in std_logic; 
        AddrW: in std_logic_vector(1 downto 0);
        AddrR: in std_logic_vector(1 downto 0);
        DataW: in std_logic_vector(N-1 downto 0);
        DataR: out std_logic_vector(N-1 downto 0)
    );
end reg_file;

architecture Behavioral of reg_file is
    component reg_unit_N is
        generic (N : natural := 8);
        port (
            CLK  : in std_logic;
            RST  : in std_logic;
            EN   : in std_logic;
            Din  : in std_logic_vector (N-1 downto 0);
            Dout : out std_logic_vector (N-1 downto 0)
        );
    end component;
       
    type reg_array_type is array (0 to M-1) of std_logic_vector(N-1 downto 0);
    signal reg_outs : reg_array_type;
    signal EN_W : std_logic_vector(M-1 downto 0);
    signal addr_w_int, addr_r_int : integer range 0 to M-1;
begin
       addr_w_int <= to_integer(unsigned(AddrW));
       addr_r_int <= to_integer(unsigned(AddrR));
    EN_SIGNALS: for i in 0 to M-1 generate
        EN_W(i) <= '1' when (addr_w_int = i and WE = '1') else '0';
    end generate EN_SIGNALS;

    GEN_FILE: for i in 0 to M-1 generate 
        UC_REG: reg_unit_N 
            generic map (N => N)
            port map(
                CLK  => CLK,
                RST  => RST,
                EN   => EN_W(i),
                Din  => DataW,
                Dout => reg_outs(i)
            );
    end generate GEN_FILE;

    DataR <= reg_outs(addr_r_int);
end Behavioral;