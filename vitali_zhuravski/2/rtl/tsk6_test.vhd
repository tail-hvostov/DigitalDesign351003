----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2026 17:31:19
-- Design Name: 
-- Module Name: tsk6_test - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tsk6_test is
--  Port ( );
end tsk6_test;

architecture Behavioral of tsk6_test is
    component tsk6_top
        port (
            led_out : out std_logic_vector(15 downto 0);
            sw_in : in std_logic_vector(15 downto 0)
        );
    end component;

    signal led_out : std_logic_vector(15 downto 0);
    signal sw_in : std_logic_vector(15 downto 0);
    signal W : std_logic;
    signal D : std_logic;
    signal Q2 : std_logic;
    signal nQ : std_logic;
begin
    U1 : tsk6_top port map(led_out => led_out, sw_in => sw_in);
    
    sw_in(1) <= W;
    sw_in(0) <= D;
    Q2 <= led_out(1);
    nQ <= led_out(0);
    
    process
    begin
        W <= '1';
        D <= '1';
        wait for 50 ns;
        W <= '0';
        wait for 50 ns;
        report "Inserted W=1, D=1. Q2=" & std_logic'image(Q2);
        
        D <= '0';
        W <= '1';
        wait for 8 ns;
        W <= '0';
        wait for 10ns;
        report "Inserted W=1, D=0 with special delays. Q2=" & std_logic'image(Q2);
        
        W <= '1';
        D <= '0';
        wait for 50 ns;
        W <= '0';
        wait for 50 ns;
        report "Inserted W=1, D=0. Q2=" & std_logic'image(Q2);
        
        D <= '1';
        W <= '1';
        wait for 8 ns;
        W <= '0';
        wait for 10ns;
        report "Inserted W=1, D=1 with special delays. Q2=" & std_logic'image(Q2);
        wait for 200ns;
        
        
        
        
        W <= '1';
        D <= '0';
        wait for 50 ns;
        W <= '0';
        D <= '1';
        wait for 50 ns;
--        report "Inserted W=1, D=0. Q2=" & std_logic'image(Q2);
        
--        W <= '1';
--        wait for 500 ps;
        
--        D <= '0';
--        wait for 15 ns;  -- (10 ns AND2 + 5 ns OR2) ?? T+15.5 ns
        
--        -- ?????? ????????? ? ?????? ???????
--        wait for 250 ps; -- ?? T+15.75 ns (???????? ????????)
--        report "During impulse (T+15.75): Q2=" & std_logic'image(Q2); -- ?????? ???? 1
        
--        wait for 500 ps; -- ?? T+16.25 ns (????? ????????)
--        report "After impulse (T+16.25): Q2=" & std_logic'image(Q2); -- ?????? ???? 0
        
--        -- ?????????, ??? ???????? ?? ????????
--        report "nQ=" & std_logic'image(nQ);
        wait;
    end process;
end Behavioral;
