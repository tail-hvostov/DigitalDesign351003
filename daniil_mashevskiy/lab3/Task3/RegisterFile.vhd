library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity RegisterFile is
    generic (
        N : integer range 1 to 32 := 8;
        M : integer range 1 to 32 := 16
    );
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        we     : in  std_logic;
        w_adr  : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
        r_adr  : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
        w_data : in  std_logic_vector(N-1 downto 0);
        r_data : out std_logic_vector(N-1 downto 0)
    );
end entity RegisterFile;

architecture Behavioral of RegisterFile is

    component RegNBit is
        generic (N : integer);
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            en       : in  std_logic;
            in_data  : in  std_logic_vector(N-1 downto 0);
            out_data : out std_logic_vector(N-1 downto 0)
        );
    end component;

    type ARR is array (0 to M-1) of std_logic_vector(N-1 downto 0);
    signal R_OUT : ARR;
    signal W_EN  : std_logic_vector(M-1 downto 0);

begin

    P_DEC: process(w_adr, we)
    begin
        W_EN <= (others => '0');
        if we = '1' then
            W_EN(to_integer(unsigned(w_adr))) <= '1';
        end if;
    end process;

    G_ARR: for i in 0 to M-1 generate
    begin
        U_REG: RegNBit
            generic map (N => N)
            port map (
                clk      => clk,
                rst      => rst,
                en       => W_EN(i),
                in_data  => w_data,
                out_data => R_OUT(i)
            );
    end generate;

    r_data <= R_OUT(to_integer(unsigned(r_adr)));

end architecture Behavioral;