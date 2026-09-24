----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 15:17:02
-- Design Name: 
-- Module Name: rs_trigger_tb - Behavioral
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

entity rs_trigger_tb is
--  Port ( );
end rs_trigger_tb;

architecture Behavioural of rs_trigger_tb is

    component rs_trigger
        generic (gate_delay : time);
        port (
            S:  in  std_logic;
            R:  in  std_logic;
            Q:  out std_logic;
            nQ: out std_logic
        );
    end component;

    signal S_tb  : std_logic := '0';
    signal R_tb  : std_logic := '0';
    signal Q_tb  : std_logic;
    signal nQ_tb : std_logic;

begin

    UUT: rs_trigger
        generic map (gate_delay => 5 ns)
        port map (
            S  => S_tb,
            R  => R_tb,
            Q  => Q_tb,
            nQ => nQ_tb
        );

    process
    begin
        S_tb <= '0'; R_tb <= '0';
        wait for 50 ns;

        S_tb <= '1'; R_tb <= '0';
        wait for 50 ns;
        assert Q_tb = '1' and nQ_tb = '0'
            report "failed" severity error;

        S_tb <= '0'; R_tb <= '0';
        wait for 50 ns;

        S_tb <= '0'; R_tb <= '1';
        wait for 50 ns;
        assert Q_tb = '0' and nQ_tb = '1'
            report "failed" severity error;

        S_tb <= '0'; R_tb <= '0';
        wait for 50 ns;

        S_tb <= '1'; R_tb <= '1';
        wait for 50 ns;
        assert Q_tb = '0' and nQ_tb = '0'
            report "Forbidden state outputs not both 0" severity warning;

        report "Releasing forbidden state -> oscillation expected" severity note;
        S_tb <= '0'; R_tb <= '0';
        wait for 200 ns;
        assert (Q_tb = '0' and nQ_tb = '1') or (Q_tb = '1' and nQ_tb = '0')
            report "After oscillation: metastable or still oscillating!" severity warning;

        report "Testbench complete" severity note;
        wait;
    end process;

end Behavioural;
