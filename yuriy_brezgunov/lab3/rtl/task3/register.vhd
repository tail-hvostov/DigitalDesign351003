library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_unit is
    Generic( N : natural := 34 ); 
    port (
        CLK   : in  std_logic; -- System clock, rising edge
        RST   : in  std_logic; -- Synchronous reset, active high
        EN    : in  std_logic; -- Enable, Active high
        Din   : in  std_logic_vector(N - 1 downto 0); -- Input data
        Dout  : out std_logic_vector(N - 1 downto 0) -- Output data
    );
end reg_unit;

architecture rtl of reg_unit is
    component d_trigger_comp is
        port (
            D     : in  std_logic;
            CLR_N : in  std_logic;
            CLK   : in  std_logic;
            Q     : out std_logic
        );
    end component;
    
    signal comp_data: std_logic_vector (N - 1 downto 0);
    signal curr: std_logic_vector(N-1 downto 0);
begin
    comp_data <= (others => '0') when (RST = '1') else
        Din when (EN  = '1') else
        curr;

    GEN_FFS: for i in 0 to N - 1 generate
        FF: d_trigger_comp
            port map (
                D     => comp_data(i),
                CLR_N => '1',
                CLK   => CLK,
                Q     => curr(i)
            );
    end generate;
    
    Dout <= curr;
end rtl;
