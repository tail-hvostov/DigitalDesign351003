library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_unit is
    generic (
        N   : natural := 34
    );
    port (
        CLK     : in    std_logic;                          -- System Clock, Rising Edge
        RST     : in    std_logic;                          -- Syncronous Reset, Active High
        EN      : in    std_logic;                          -- Enable, Active High
        D_IN    : in    std_logic_vector(N - 1 downto 0);   -- Input Data
        D_OUT   : out   std_logic_vector(N - 1 downto 0)    -- Output Data
    );
end reg_unit;

architecture Mixed of reg_unit is
    signal d_in_DFF, d_out_DFF  :   std_logic_vector(N - 1 downto 0);
    signal d_next               :   std_logic_vector(N - 1 downto 0);
    signal store                :   std_logic;
    
    component DFF is
        port (
            D       : in    std_logic;
            CLK     : in    std_logic;
            CLR_N   : in    std_logic; 
            Q       : out   std_logic
        );
    end component;
begin
    d_in_DFF <= D_IN;
    D_OUT <= d_out_DFF;
    
    REG_U: for i in 0 to N - 1 generate
        d_next(i) <= '0'            when RST = '1'  else
                     d_in_DFF(i)    when EN = '1'   else
                     d_out_DFF(i);
    
        DFF_i: DFF port map (
            D => d_next(i),
            CLK => CLK,
            CLR_N => '1',
            Q => d_out_DFF(i)
        );
    end generate REG_U;
end Mixed;