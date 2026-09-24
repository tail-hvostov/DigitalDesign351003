library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file_tb2 is
end reg_file_tb2;

architecture Behavioural of reg_file_tb2 is
    constant ADDR_W: natural := 5; 
    constant DATA_W: natural := 16;
    component reg_file_2r1w
        generic (
            ADDR_WIDTH: integer := 5;
            DATA_WIDTH: integer := 16
        );
        port ( 
            CLK: in  std_logic;
            CLR: in  std_logic;
            W_EN: in  std_logic;
            W_ADDR: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            W_DATA: in  std_logic_vector (DATA_WIDTH-1 downto 0);
            R_ADDR_0: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            R_DATA_0: out std_logic_vector (DATA_WIDTH-1 downto 0);
            R_ADDR_1: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
            R_DATA_1: out std_logic_vector (DATA_WIDTH-1 downto 0)
         );
    end component;
    signal CLK_tb: std_logic := '0';
    signal CLR_tb: std_logic := '0';
    signal W_EN_tb: std_logic := '0';
    signal W_ADDR_tb: std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
    signal W_DATA_tb: std_logic_vector(DATA_W-1 downto 0) := (others => '0');
    signal R_ADDR_0_tb: std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
    signal R_DATA_0_tb: std_logic_vector(DATA_W-1 downto 0);
    signal R_ADDR_1_tb: std_logic_vector(ADDR_W-1 downto 0) := (others => '0');
    signal R_DATA_1_tb: std_logic_vector(DATA_W-1 downto 0);
    constant CLK_PERIOD: time := 20 ns;
    constant ZEROS: std_logic_vector(DATA_W-1 downto 0) := (others => '0');
    constant TEST_DATA_1: std_logic_vector(DATA_W-1 downto 0) := x"CAFE";
    constant TEST_DATA_2: std_logic_vector(DATA_W-1 downto 0) := x"BEEF";
    constant FORWARD_DATA: std_logic_vector(DATA_W-1 downto 0) := x"1234";
begin
    UUT: reg_file_2r1w
        generic map ( ADDR_WIDTH => ADDR_W, DATA_WIDTH => DATA_W )
        port map (
            CLK => CLK_tb,
            CLR => CLR_tb,
            W_EN => W_EN_tb,
            W_ADDR => W_ADDR_tb,
            W_DATA => W_DATA_tb,
            R_ADDR_0 => R_ADDR_0_tb,
            R_DATA_0 => R_DATA_0_tb,
            R_ADDR_1 => R_ADDR_1_tb,
            R_DATA_1 => R_DATA_1_tb
        );
    CLK_tb <= not CLK_tb after CLK_PERIOD / 2;
    
    process
    begin
        CLR_tb <= '1';
        wait until rising_edge(CLK_tb); 
        wait for 5 ns; 
        CLR_tb <= '0';
        R_ADDR_0_tb <= std_logic_vector(to_unsigned(5, ADDR_W));
        R_ADDR_1_tb <= std_logic_vector(to_unsigned(25, ADDR_W));
        wait for 1 ns;
        
        assert (R_DATA_0_tb = ZEROS and R_DATA_1_tb = ZEROS)
            report "FAILED: registers are not zero" severity error;

        W_EN_tb <= '1';
        W_ADDR_tb <= std_logic_vector(to_unsigned(1, ADDR_W));
        W_DATA_tb <= TEST_DATA_1;
        wait until rising_edge(CLK_tb);
        W_ADDR_tb <= std_logic_vector(to_unsigned(2, ADDR_W));
        W_DATA_tb <= TEST_DATA_2;
        wait until rising_edge(CLK_tb);
        W_EN_tb <= '0';

        R_ADDR_0_tb <= std_logic_vector(to_unsigned(1, ADDR_W));
        R_ADDR_1_tb <= std_logic_vector(to_unsigned(2, ADDR_W));
        wait for 1 ns; 
        assert (R_DATA_0_tb = TEST_DATA_1) report "FAILED: read port 0" severity error;
        assert (R_DATA_1_tb = TEST_DATA_2) report "FAILED: read port 1" severity error;

        W_EN_tb <= '1';
        W_ADDR_tb <= std_logic_vector(to_unsigned(10, ADDR_W));
        W_DATA_tb <= FORWARD_DATA;
        R_ADDR_0_tb <= std_logic_vector(to_unsigned(10, ADDR_W)); 
        wait for 1 ns; 
        assert (R_DATA_0_tb = FORWARD_DATA) 
            report "FAILED: data not immediately on R_DATA_0" severity error;      
        wait until rising_edge(CLK_tb);
        W_EN_tb <= '0';

        W_EN_tb <= '1';
        W_ADDR_tb <= std_logic_vector(to_unsigned(15, ADDR_W));
        W_DATA_tb <= x"AAAA";
        R_ADDR_0_tb <= std_logic_vector(to_unsigned(1, ADDR_W));
        R_ADDR_1_tb <= std_logic_vector(to_unsigned(2, ADDR_W));
        
        wait until rising_edge(CLK_tb);
        W_EN_tb <= '0';
        
        assert (R_DATA_0_tb = TEST_DATA_1 and R_DATA_1_tb = TEST_DATA_2)
            report "FAILED: r/w" severity error;

        W_EN_tb <= '0';
        W_ADDR_tb <= std_logic_vector(to_unsigned(1, ADDR_W));
        W_DATA_tb <= x"FFFF"; 
        wait until rising_edge(CLK_tb);
        
        R_ADDR_0_tb <= std_logic_vector(to_unsigned(1, ADDR_W));
        wait for 1 ns;
        assert (R_DATA_0_tb = TEST_DATA_1)
            report "FAILED: register was overwritten with en=0" severity error;
        wait;
    end process;
end Behavioural;