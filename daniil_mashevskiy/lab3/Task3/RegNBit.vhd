library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegNBit is
    generic (N : integer range 1 to 32 := 13);
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        en       : in  std_logic;
        in_data  : in  std_logic_vector(N-1 downto 0);
        out_data : out std_logic_vector(N-1 downto 0)
    );
end entity RegNBit;

architecture Behavioral of RegNBit is

    component Triggger is
        port (
            D   : in  std_logic;
            CLK : in  std_logic;
            RST : in  std_logic;
            Q   : out std_logic
        );
    end component;

    signal Q_BUF : std_logic_vector(N-1 downto 0);
    signal D_BUF : std_logic_vector(N-1 downto 0);

begin

    P_MUX: process(rst, en, Q_BUF, in_data)
    begin
        if rst = '1' then
            D_BUF <= (others => '0');
        elsif en = '1' then
            D_BUF <= in_data;
        else 
            D_BUF <= Q_BUF;
        end if;
    end process;

    G_LOOP: for i in 0 to N-1 generate
    begin
        U_FF: Triggger
            port map (
                D   => D_BUF(i),
                CLK => clk,
                RST => '0',
                Q   => Q_BUF(i)
            );
    end generate;

    out_data <= Q_BUF;

end architecture Behavioral;