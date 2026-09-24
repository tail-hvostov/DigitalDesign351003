library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_unit is
    generic (N: natural := 34);
    port(
        CLK: in  std_logic;
        RST: in  std_logic;
        EN: in  std_logic;
        Din: in  std_logic_vector(N-1 downto 0);
        Dout: out std_logic_vector(N-1 downto 0)
    );
end reg_unit;

architecture Structural of reg_unit is
    component myFDCE is
        Port (
            CLR_N: in  std_logic;
            CLK: in  std_logic;
            D: in  std_logic;
            Q: out std_logic
        );
    end component;

    signal D_int: std_logic_vector(N-1 downto 0);
    signal Q_int: std_logic_vector(N-1 downto 0);
    signal CLR_N: std_logic;

begin
    CLR_N <= '1';
    D_int <= (others => '0') when RST = '1' else
             Din when EN  = '1' else Q_int;

    GEN_REG: for i in 0 to N-1 generate
        FF: myFDCE
            port map (
                CLR_N => CLR_N,
                CLK => CLK,
                D => D_int(i),
                Q => Q_int(i)
            );
    end generate GEN_REG;

    Dout <= Q_int;

end Structural;