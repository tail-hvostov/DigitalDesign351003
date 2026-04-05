----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2026 15:32:10
-- Design Name: 
-- Module Name: FreqDivBehavTest - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FreqDivBehavTest is
--  Port ( );
end FreqDivBehavTest;

architecture Behavioral of FreqDivBehavTest is
    component FreqDivBehav is
        generic (
            K : natural := 10
        );
        port (
            CLK : in  std_logic;
            RST : in  std_logic;
            EN  : in  std_logic;
            Q   : out std_logic
        );
    end component;
    
    type K_array is array (1 to 3) of natural;

    constant Ks : K_array := (1 => 4, 2 => 10, 3 => 100);
    signal CLK : std_logic_vector(Ks'range);
    signal RST : std_logic_vector(Ks'range);
    signal EN : std_logic_vector(Ks'range);
    signal Q : std_logic_vector(Ks'range);
begin
    U0 : for i in Ks'low to Ks'high generate
        Ui : FreqDivBehav
        generic map(K => Ks(i))
        port map(CLK => CLK(i), RST => RST(i), EN => EN(i), Q => Q(i));
    end generate;
   
    P0 : process
        variable succeded_tests : natural;
        variable test_counter : natural;
        
        variable clock_count : natural;
        variable prev_state : std_logic;
        variable state_changes : natural;
        variable good_timing : boolean;
    begin
        succeded_tests := 0;
        test_counter := 0;
        CLK <= (others => '0');
        wait for 10 ns;
        
        for i in Ks'low to Ks'high loop
            report "Resetting divider with K = " & natural'image(Ks(i)) & ".";
            RST(i) <= '1';
            CLK(i) <= '1';
            EN(i) <= '1';
            wait for 10 ns;
            RST(i) <= '0';
            CLK(i) <= '0';
            wait for 10 ns;
            test_counter := test_counter + 1;
            if Q(i) = '0' then
                succeded_tests := succeded_tests + 1;
            else
                report "Initial reset failed with K = " & natural'image(Ks(i)) & ".";
            end if;
            
            report "Dividing test with K = " & natural'image(Ks(i)) & ".";
            clock_count := 2 * (Ks(i) / 2);
            prev_state := Q(i);
            state_changes := 0;
            good_timing := true;
            for cur_clock in 1 to clock_count loop
                CLK(i) <= '1';
                wait for 10 ns;
                CLK(i) <= '0';
                wait for 10 ns;
                if prev_state /= Q(i) then
                    prev_state := Q(i);
                    state_changes := state_changes + 1;
                    if clock_count mod cur_clock /= 0 then
                        good_timing := false;
                    end if;
                end if;
            end loop;
            test_counter := test_counter + 2;
            if good_timing then
                succeded_tests := succeded_tests + 1;
            else
                report "Bad timings detected with K = " & natural'image(Ks(i)) & ".";
            end if;
            if 2 = state_changes then
                succeded_tests := succeded_tests + 1;
            else
                report "Frequency is not normal with K = " & natural'image(Ks(i)) & ". Expected " &
                        natural'image(2 * (Ks(i) / 2) * clock_count) & " changes instead of " &
                        natural'image(state_changes) & ".";
            end if;
        end loop;
       
        report natural'image(succeded_tests) & " tests of " & natural'image(test_counter) & " successfully passed.";
        wait;
    end process;

end Behavioral;
