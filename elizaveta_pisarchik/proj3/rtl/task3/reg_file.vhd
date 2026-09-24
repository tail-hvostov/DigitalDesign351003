library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file is
    generic (
        A : integer := 2;  
        N : integer := 34   
    );
    port (
        CLK : in std_logic;
        RST : in std_logic;
        WE  : in std_logic; 
        WA :  in std_logic_vector (A-1 downto 0);
        RA :  in std_logic_vector (A-1 downto 0);
        Din  : in std_logic_vector(N-1 downto 0);
        Dout : out std_logic_vector(N-1 downto 0)
    );
end reg_file;

architecture rtl of reg_file is
    constant M : integer := 2**A;
    type reg_array is array (0 to M-1) of std_logic_vector(N-1 downto 0);
    signal reg_out : reg_array;
    signal en_vec : std_logic_vector(M-1 downto 0);
begin
    gen_en: for i in 0 to M-1 generate
        en_vec(i) <= WE when (to_integer(unsigned(WA)) = i) else '0';
    end generate;
    
    gen_regs: for i in 0 to M-1 generate
            reg_inst: entity work.reg_unit
                generic map (N => N)
                port map (
                    CLK  => CLK,
                    RST  => RST,
                    EN   => en_vec(i),
                    Din  => Din,
                    Dout => reg_out(i)
                );
        end generate;
        
    Dout <= reg_out(to_integer(unsigned(RA)));
end rtl;