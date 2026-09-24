library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_unit_N is
    generic (N : natural := 8);
    port (
        CLK  : in std_logic;
        RST  : in std_logic;
        EN   : in std_logic;
        Din  : in std_logic_vector (N-1 downto 0);
        Dout : out std_logic_vector (N-1 downto 0)
    );
end reg_unit_N;

architecture Behavioral of reg_unit_N is
    signal CLR : std_logic := '1';
    signal DFF_input : std_logic_vector(N-1 downto 0);
    signal reg_output : std_logic_vector(N-1 downto 0);
begin

    UP_CLR: process (CLK)
    begin
        if rising_edge(CLK) then
            if (RST = '1') then
                CLR <= '0';
            else 
                CLR <= '1';
            end if;
        end if;
    end process UP_CLR;
    
    DFF_input <= Din when EN = '1' else reg_output;
    
    gen_reg: for i in 0 to N-1 generate
        U_DFF: entity work.DFF port map (
            CLK => CLK,
            D   => DFF_input(i),
            CLR => CLR,
            Q   => reg_output(i)
        );
    end generate;

    Dout <= reg_output;
end Behavioral;