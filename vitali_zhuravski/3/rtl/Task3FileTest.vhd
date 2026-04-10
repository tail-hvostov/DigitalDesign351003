----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 02:12:12
-- Design Name: 
-- Module Name: Task3FileTest - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Task3FileTest is
--  Port ( );
end Task3FileTest;

architecture Behavioral of Task3FileTest is
    component RegFile
        generic(
            N : natural := 12;
            M : natural := 7
        );
        port(
            CLK     : in  std_logic;
            RST     : in  std_logic;
            WE      : in  std_logic;
            WD      : in  std_logic_vector(N-1 downto 0);
            WAddr   : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            RD      : out std_logic_vector(N-1 downto 0);
            RAddr   : in  std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0)
        );
    end component;
    
    constant N : natural := 12;
    constant M : natural := 7;
    constant ADDR_WIDTH : natural := integer(ceil(log2(real(M))));
    
    signal CLK     : std_logic := '0';
    signal RST     : std_logic;
    signal WE      : std_logic;
    signal WD      : std_logic_vector(N-1 downto 0);
    signal WAddr   : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal RD      : std_logic_vector(N-1 downto 0);
    signal RAddr   : std_logic_vector(ADDR_WIDTH-1 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;

begin
    U0: RegFile
        generic map(
            N => N,
            M => M
        )
        port map(
            CLK   => CLK,
            RST   => RST,
            WE    => WE,
            WD    => WD,
            WAddr => WAddr,
            RD    => RD,
            RAddr => RAddr
        );
    
    -- ????????? ?????
    CLK <= not CLK after CLK_PERIOD/2;
        
    -- ???????? ???????????
    process
        variable test_count : integer := 0;
        variable pass_count : integer := 0;
    begin
        test_count := test_count + 1;
        RST <= '1';
        wait for CLK_PERIOD;
        RST <= '0';
        wait for CLK_PERIOD;
        
        RAddr <= std_logic_vector(to_unsigned(0, ADDR_WIDTH));
        wait for CLK_PERIOD;
        if unsigned(RD) = 0 then
            pass_count := pass_count + 1;
            report "Test 1: Reset - PASSED";
        else
            report "Test 1: Reset - FAILED";
        end if;
        
        test_count := test_count + 1;
        WE <= '1';
        WAddr <= std_logic_vector(to_unsigned(0, ADDR_WIDTH));
        WD <= x"ABC";
        wait for CLK_PERIOD;
        WE <= '0';
        
        RAddr <= std_logic_vector(to_unsigned(0, ADDR_WIDTH));
        wait for CLK_PERIOD;
        
        if RD = x"ABC" then
            pass_count := pass_count + 1;
            report "Test 2: Write to reg0 = 2748, Read = " & integer'image(to_integer(unsigned(RD))) & " - PASSED";
        else
            report "Test 2: Write to reg0 = 2748, Read = " & integer'image(to_integer(unsigned(RD))) & " - FAILED";
        end if;
        
        test_count := test_count + 1;
        WE <= '1';
        WAddr <= std_logic_vector(to_unsigned(3, ADDR_WIDTH));
        WD <= x"123";
        wait for CLK_PERIOD;
        WE <= '0';
        
        RAddr <= std_logic_vector(to_unsigned(3, ADDR_WIDTH));
        wait for CLK_PERIOD;
        
        if RD = x"123" then
            pass_count := pass_count + 1;
            report "Test 3: Write to reg3 = 291, Read = " & integer'image(to_integer(unsigned(RD))) & " - PASSED";
        else
            report "Test 3: Write to reg3 = 291, Read = " & integer'image(to_integer(unsigned(RD))) & " - FAILED";
        end if;
        
        test_count := test_count + 1;
        RST <= '1';
        wait for CLK_PERIOD;
        RST <= '0';
        wait for CLK_PERIOD;
        
        RAddr <= std_logic_vector(to_unsigned(0, ADDR_WIDTH));
        wait for CLK_PERIOD;
        
        if unsigned(RD) = 0 then
            pass_count := pass_count + 1;
            report "Test 4: Reset after write - PASSED";
        else
            report "Test 4: Reset after write - FAILED";
        end if;
        
        report integer'image(pass_count) & " tests of " & integer'image(test_count) & " passed.";
        
        wait;
    end process;
end Behavioral;