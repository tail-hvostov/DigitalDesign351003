library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file_2r1w_TB is
end reg_file_2r1w_TB;

architecture Behavioral of reg_file_2r1w_TB is
    constant ADDR_W     :   natural := 5;
    constant DATA_W     :   natural := 16;
    constant T          :   time := 20 ns;

    signal CLK, CLR, W_EN   : std_logic;
    signal W_ADDR           : std_logic_vector(ADDR_W - 1 downto 0);
    signal W_DATA           : std_logic_vector(DATA_W - 1 downto 0);
    
    signal R_ADDR_0     : std_logic_vector(ADDR_W - 1 downto 0);
    signal R_DATA_0     : std_logic_vector(DATA_W - 1 downto 0);
    
    signal R_ADDR_1     : std_logic_vector(ADDR_W - 1 downto 0);
    signal R_DATA_1     : std_logic_vector(DATA_W - 1 downto 0);

    component reg_file_2r1w is
        generic (
            ADDR_WIDTH : natural := 5;
            DATA_WIDTH : natural := 16
        );
        port (
            CLK      : in  std_logic;
            CLR      : in  std_logic;
            W_EN     : in  std_logic;
            W_ADDR   : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
            W_DATA   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
            R_ADDR_0 : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
            R_DATA_0 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
            R_ADDR_1 : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
            R_DATA_1 : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
    end component;

begin
    UUT: reg_file_2r1w
        generic map (
            ADDR_WIDTH => ADDR_W,
            DATA_WIDTH => DATA_W
        )
        port map (
            CLK      => CLK,
            CLR      => CLR,
            W_EN     => W_EN,
            W_ADDR   => W_ADDR,
            W_DATA   => W_DATA,
            R_ADDR_0 => R_ADDR_0,
            R_DATA_0 => R_DATA_0,
            R_ADDR_1 => R_ADDR_1,
            R_DATA_1 => R_DATA_1
        );

    ClkGen: process
    begin
        CLK <= '0'; 
        wait for (T / 2);
        
        CLK <= '1'; 
        wait for (T / 2);
    end process ClkGen;

    Sim: process
    begin
        report "reg_file_2r1w simulation started" 
        severity note;

        CLR <= '1';
        W_EN <= '0';
        W_ADDR <= (others => '0');
        W_DATA <= (others => '0');
        R_ADDR_0 <= "00101"; 
        R_ADDR_1 <= "11111"; 
        wait for T;
        
        CLR <= '0';
        wait for 1 ns;
        assert (R_DATA_0 = X"0000" and R_DATA_1 = X"0000")
            report "Initial reset failed" 
            severity error;

        W_EN   <= '1';
        W_ADDR <= std_logic_vector(to_unsigned(1, ADDR_W));
        W_DATA <= X"AAAA";
        wait for T;
        
        W_ADDR <= std_logic_vector(to_unsigned(2, ADDR_W));
        W_DATA <= X"BBBB";
        wait for T;
        W_EN   <= '0';

        R_ADDR_0 <= std_logic_vector(to_unsigned(1, ADDR_W));
        R_ADDR_1 <= std_logic_vector(to_unsigned(2, ADDR_W));
        wait for 1 ns;
        assert (R_DATA_0 = X"AAAA" and R_DATA_1 = X"BBBB")
            report "sequential read failed" 
            severity error;
 
        W_EN   <= '1';
        W_ADDR <= std_logic_vector(to_unsigned(10, ADDR_W));
        W_DATA <= X"1234";
        R_ADDR_0 <= std_logic_vector(to_unsigned(10, ADDR_W));
        wait for 5 ns;
        assert (R_DATA_0 = X"1234")
            report "forwarding failed: data not available immediately on read port" 
            severity error;
        wait for T;
        W_EN <= '0';

        W_EN   <= '1';
        W_ADDR <= std_logic_vector(to_unsigned(20, ADDR_W));
        W_DATA <= X"CCCC";
        R_ADDR_0 <= std_logic_vector(to_unsigned(1, ADDR_W));
        R_ADDR_1 <= std_logic_vector(to_unsigned(2, ADDR_W));
        wait for T;
        assert (R_DATA_0 = X"AAAA" and R_DATA_1 = X"BBBB")
            report "concurrent R/W to different addresses failed" 
            severity error;

        W_EN   <= '0';
        W_ADDR <= std_logic_vector(to_unsigned(1, ADDR_W));
        W_DATA <= X"FFFF";
        wait for T;
        R_ADDR_0 <= std_logic_vector(to_unsigned(1, ADDR_W));
        wait for 1 ns;
        assert (R_DATA_0 = X"AAAA")
            report "write without W_EN failed (data corrupted)" 
            severity error;

        report "reg_file_2r1w simulation finished" 
        severity note;
        
        wait;
    end process Sim;
end Behavioral;