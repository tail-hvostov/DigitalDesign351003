library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    generic (
        N:  integer := 3  
    );
    port (
        A, B: in std_logic_vector(N-1 downto 0);
        result: out std_logic_vector(1 downto 0)
    );
end comparator;

architecture Behaviour of comparator is
    component bit_comparator
    port (
        bitA, bitB: in std_logic;
        prev_res: in std_logic_vector(1 downto 0);
        res: out std_logic_vector(1 downto 0)
    );
    end component;
    type res_array is array (0 to N) of std_logic_vector(1 downto 0);
    signal inter_res: res_array;
begin
    -- < - 10, = - 11, > - 01
    inter_res(0) <= "11";
    SCH: for i in 0 to N-1 generate
        Ui0: bit_comparator 
            port map (
                bitA => A(N-1-i),
                bitB => B(N-1-i),
                prev_res => inter_res(i),
                res => inter_res(i+1)
            );
    end generate;
    result <= inter_res(N);
end Behaviour;
