library ieee;
use ieee.std_logic_1164.all;

library work;
use work.delayed_components.all;


entity tsk4_top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end tsk4_top;

architecture structure of tsk4_top is

    component COMPARATOR is
        port (
            greater_in : in std_logic;
            smaller_in : in std_logic;
            first : in std_logic;
            second : in std_logic;
            greater_out : out std_logic;
            smaller_out : out std_logic
        );
    end component;
    
    signal input_r : std_logic_vector(7 downto 0);
    
    signal input : std_logic_vector(7 downto 0);
    signal num1 : std_logic_vector(2 downto 0);
    signal num2 : std_logic_vector(2 downto 0);
    signal greater_in : std_logic;
    signal smaller_in : std_logic;
    
    signal greater_cache_r : std_logic_vector(2 downto 0);
    signal smaller_cache_r : std_logic_vector(2 downto 0);
    signal greater_cache : std_logic_vector(2 downto 0);
    signal smaller_cache : std_logic_vector(2 downto 0);
begin
    input_r <= sw_in(7 downto 0);
    num1 <= input(5 downto 3);
    num2 <= input(2 downto 0);
    greater_in <= input(7);
    smaller_in <= input(6);

    W1 : for I in input_r'low to input_r'high generate
        U : DEL_WIRE port map(I => input_r(I), O => input(I));
    end generate;
    
    W2 : for I in greater_cache'low to greater_cache'high generate
        U1 : DEL_WIRE port map(I => greater_cache_r(I), O => greater_cache(I));
        U2 : DEL_WIRE port map(I => smaller_cache_r(I), O => smaller_cache(I));
    end generate;
    
    U1 : COMPARATOR port map(
            greater_in => greater_in,
            smaller_in => smaller_in,
            first => num1(2),
            second => num2(2),
            greater_out => greater_cache_r(2),
            smaller_out => smaller_cache_r(2)
    );
    
    U2 : COMPARATOR port map (
            greater_in => greater_cache(2),
            smaller_in => smaller_cache(2),
            first => num1(1),
            second => num2(1),
            greater_out => greater_cache_r(1),
            smaller_out => smaller_cache_r(1)
    );
    
    U3 : COMPARATOR port map (
            greater_in => greater_cache(1),
            smaller_in => smaller_cache(1),
            first => num1(0),
            second => num2(0),
            greater_out => greater_cache_r(0),
            smaller_out => smaller_cache_r(0)
    );
    
    led_out(15 downto 2) <= "00000000000000";
    led_out(1) <= greater_cache(0);
    led_out(0) <= smaller_cache(0);
end structure;