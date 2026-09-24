library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task4 is
    generic (
        GATE_DELAY : time := 2 ns;
        AMOUNT_BITS : integer := 64
    );
    Port ( 
        sw_i: in std_logic_vector(5 downto 0);
        led_o: out std_logic_vector(2 downto 0)
    );
end task4;

architecture Behavioral of task4 is

    component comp_bit
        generic ( GATE_DELAY : time );
        port ( a, b, g_in, l_in, e_in : in std_logic; g_out, l_out, e_out : out std_logic );
    end component;

    signal g_chain, l_chain, e_chain : std_logic_vector(3 downto 0);
    signal A, B : std_logic_vector(2 downto 0);   

begin
    A <= sw_i(AMOUNT_BITS * 2 - 1 downto AMOUNT_BITS); --(5 downto 3);
    B <= sw_i(AMOUNT_BITS - 1 downto 0);--(2 downto 0);

    g_chain(3) <= '0';
    l_chain(3) <= '0';
    e_chain(3) <= '1';

    GEN_COMP: for i in AMOUNT_BITS downto 0 generate
            COMP_INST: comp_bit 
                generic map(GATE_DELAY => GATE_DELAY)
                port map(a => A(i), b => B(i), g_in => g_chain(i+1), l_in => l_chain(i+1), e_in => e_chain(i+1), 
                    g_out => g_chain(i), l_out => l_chain(i), e_out => e_chain(i));
     end generate GEN_COMP;
    
    
    --COMP2: comp_bit 
    --    generic map(GATE_DELAY)
    --    port map(a => A(2), b => B(2), g_in => g_chain(3), l_in => l_chain(3), e_in => e_chain(3), 
    --            g_out => g_chain(2), l_out => l_chain(2), e_out => e_chain(2));

    --COMP1: comp_bit 
    --    generic map(GATE_DELAY)
    --    port map(a => A(1), b => B(1), g_in => g_chain(2), l_in => l_chain(2), e_in => e_chain(2), 
     --            g_out => g_chain(1), l_out => l_chain(1), e_out => e_chain(1));

    --COMP0: comp_bit 
    --    generic map(GATE_DELAY)
    --    port map(a => A(0), b => B(0), g_in => g_chain(1), l_in => l_chain(1), e_in => e_chain(1), 
    --    g_out => g_chain(0), l_out => l_chain(0), e_out => e_chain(0));

    led_o(2) <= g_chain(0); -- A > B
    led_o(1) <= l_chain(0); -- A < B
    led_o(0) <= e_chain(0); -- A = B
end Behavioral;
