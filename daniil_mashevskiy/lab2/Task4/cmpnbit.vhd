library ieee;
use ieee.std_logic_1164.all;

entity cmpnbit is
    generic (
        NUM_BITS : integer range 1 to 16 := 4
    );
    port (
        num_a, num_b : in  std_logic_vector(NUM_BITS-1 downto 0);
        a_greater, a_equal, a_less : out std_logic
    );
end entity;

architecture cascade of cmpnbit is
    component cmp1bit
        port (
            x, y       : in  std_logic;
            x_gt_prev, x_eq_prev, x_lt_prev : in  std_logic;
            x_gt_next, x_eq_next, x_lt_next : out std_logic
        );
    end component;
    
    type link_array is array (0 to NUM_BITS) of std_logic;
    signal gt_link, eq_link, lt_link : link_array;
    
begin
    gt_link(NUM_BITS) <= '0';
    eq_link(NUM_BITS) <= '1';
    lt_link(NUM_BITS) <= '0';
    
    bit_loop : for idx in NUM_BITS-1 downto 0 generate
        bit_cmp : cmp1bit
            port map (
                x          => num_a(idx),
                y          => num_b(idx),
                x_gt_prev  => gt_link(idx+1),
                x_eq_prev  => eq_link(idx+1),
                x_lt_prev  => lt_link(idx+1),
                x_gt_next  => gt_link(idx),
                x_eq_next  => eq_link(idx),
                x_lt_next  => lt_link(idx)
            );
    end generate;
    
    a_greater <= gt_link(0);
    a_equal   <= eq_link(0);
    a_less    <= lt_link(0);
end architecture;