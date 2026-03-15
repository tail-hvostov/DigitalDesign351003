library ieee;
use ieee.std_logic_1164.all;

entity bit_comparator is
    port (
        A, B       : in  std_logic;
        greater_in, equal_in, less_in : in  std_logic;
        greater_out, equal_out, less_out : out std_logic
    );
end entity;

architecture behavior of bit_comparator is
begin
    process (A, B, greater_in, equal_in, less_in)
    begin
        greater_out <= greater_in;
        less_out <= less_in;
        
        if equal_in = '1' then
            if A = '1' and B = '0' then
                greater_out <= '1';
                less_out <= '0';
                equal_out <= '0';
            elsif A = '0' and B = '1' then
                greater_out <= '0';
                less_out <= '1';
                equal_out <= '0';
            else
                equal_out <= '1';
            end if;
        else
            equal_out <= '0';
        end if;
    end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity nbit_comparator is
    generic (N : integer range 1 to 8 := 8);
    port (
        a, b : in  std_logic_vector(N-1 downto 0);
        a_greater, equal_out, b_greater : out std_logic
    );
end entity;

architecture structural of nbit_comparator is
    signal gt_chain, eq_chain, lt_chain : std_logic_vector(N downto 0);
    
    component bit_comparator is
        port (
            A, B : in std_logic;
            greater_in, equal_in, less_in : in std_logic;
            greater_out, equal_out, less_out : out std_logic
        );
    end component;
begin
    gt_chain(N) <= '0';
    eq_chain(N) <= '1';
    lt_chain(N) <= '0';
    
    gen_cmp : for i in N-1 downto 0 generate
        cmp_i : bit_comparator
            port map (
                A => a(i),
                B => b(i),
                greater_in => gt_chain(i+1),
                equal_in => eq_chain(i+1),
                less_in => lt_chain(i+1),
                greater_out => gt_chain(i),
                equal_out => eq_chain(i),
                less_out => lt_chain(i)
            );
    end generate;
    
    a_greater <= gt_chain(0);
    equal_out <= eq_chain(0);
    b_greater <= lt_chain(0);
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity top is
    port ( 
        sw : in std_logic_vector(15 downto 0);
        led_o : out std_logic_vector(2 downto 0)
    );
end top;

architecture Behavioral of top is
    component nbit_comparator is
        generic (N : integer range 1 to 8 := 8);
        port(
            a, b : in std_logic_vector(N-1 downto 0);
            a_greater, equal_out, b_greater : out std_logic
        );
    end component;
begin
    U1 : nbit_comparator 
    generic map (N => 3)
    port map(
        a => sw(2 downto 0),
        b => sw(5 downto 3),
        a_greater => led_o(2),
        equal_out => led_o(1),
        b_greater => led_o(0)
    );
end Behavioral;