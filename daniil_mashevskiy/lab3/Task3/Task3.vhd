library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task3 is
    Port(
        clk  : in  std_logic;
        sw   : in  std_logic_vector(15 downto 0);
        led  : out std_logic_vector(15 downto 0)
    );
end entity Task3;

architecture Behavioral of Task3 is

    component RegisterFile is
        generic (N : integer range 1 to 32 := 4; M : integer range 1 to 32 := 4);
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            we     : in  std_logic;
            w_adr  : in  std_logic_vector(1 downto 0);
            r_adr  : in  std_logic_vector(1 downto 0);
            w_data : in  std_logic_vector(N-1 downto 0);
            r_data : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal RST_S : std_logic;
    signal WE_S  : std_logic;
    signal WA_S  : std_logic_vector(1 downto 0);
    signal RA_S  : std_logic_vector(1 downto 0);
    signal WD_S  : std_logic_vector(3 downto 0);
    signal RD_S  : std_logic_vector(3 downto 0);

begin

    RST_S <= sw(0);
    WE_S  <= sw(1);
    WA_S  <= sw(3 downto 2);
    RA_S  <= sw(5 downto 4);
    WD_S  <= sw(9 downto 6);

    U_RF: RegisterFile
        generic map (N => 4, M => 4)
        port map (
            clk    => clk,
            rst    => RST_S,
            we     => WE_S,
            w_adr  => WA_S,
            r_adr  => RA_S,
            w_data => WD_S,
            r_data => RD_S
        );

    led(3 downto 0)  <= RD_S;
    led(15 downto 4) <= (others => '0');

end architecture Behavioral;