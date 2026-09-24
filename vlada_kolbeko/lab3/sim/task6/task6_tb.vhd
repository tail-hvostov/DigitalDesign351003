library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_controller_TB is
end pwm_controller_TB;

architecture Behavioral of pwm_controller_TB is
    constant N_TB : natural := 8;
    constant T    : time    := 20 ns;

    signal CLK  : std_logic;
    signal CLR  : std_logic;
    signal EN   : std_logic;
    signal FILL : std_logic_vector(N_TB - 1 downto 0);
    signal Q    : std_logic;

    component pwm_controller is
        generic (
            CNT_WIDTH : natural := 8
        );
        port (
            CLK  : in std_logic;
            CLR  : in std_logic;
            EN   : in std_logic;
            FILL : in std_logic_vector(N_TB - 1 downto 0);
            Q    : out std_logic
        );
    end component;

begin
    UUT: pwm_controller
        generic map (
            CNT_WIDTH => N_TB
        )
        port map (
            CLK  => CLK,
            CLR  => CLR,
            EN   => EN,
            FILL => FILL,
            Q    => Q
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
        report "pwm_controller simulation started" 
        severity note;

        CLR  <= '1';
        EN   <= '0';
        FILL <= std_logic_vector(to_unsigned(128, N_TB)); -- 50%
        wait for 2*T;
        
        assert (Q = '0') 
            report "output must be '0' during reset" 
            severity error;
        
        CLR <= '0';
        EN  <= '1';
        report "testing PWM with 50% duty cycle (FILL=128)" 
        severity note;
        wait for 300*T;
        
        report "testing 0% duty cycle (FILL=0)" 
        severity note;
        FILL <= std_logic_vector(to_unsigned(0, N_TB));
        wait for 300*T;
        
        assert (Q = '0') 
            report "output must be constant '0' for FILL=0" 
            severity error;
        
        report "testing 25% duty cycle (FILL=64)" 
        severity note;
        FILL <= std_logic_vector(to_unsigned(64, N_TB));
        wait for 300*T;
        
        report "testing max duty cycle (FILL=255)" 
        severity note;
        FILL <= std_logic_vector(to_unsigned(255, N_TB));
        wait for 300*T;
        
        report "testing module disable (EN=0)" 
        severity note;
        EN <= '0';
        wait for 50*T;
        
        assert (Q = '0') 
            report "output must be '0' when EN=0" 
            severity error;
        
        CLR <= '1';
        wait for T;
        
        report "pwm_controller simulation finished" 
        severity note;
        
        wait;
    end process Sim;
end Behavioral;