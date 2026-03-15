library ieee;
use ieee.std_logic_1164.all;

entity cmp1bit is
    port (
        x, y       : in  std_logic;
        x_gt_prev, x_eq_prev, x_lt_prev : in  std_logic;
        x_gt_next, x_eq_next, x_lt_next : out std_logic
    );
end entity;

architecture dataflow of cmp1bit is
    signal x_gt_cur, x_eq_cur, x_lt_cur : std_logic;
    signal not_x, not_y : std_logic;
begin
    not_x <= not x;
    not_y <= not y;
    
    x_gt_cur <= x and not_y;
    x_eq_cur <= not (x xor y);
    x_lt_cur <= not_x and y;
    
    x_gt_next <= (x_gt_cur and x_eq_prev) or x_gt_prev;
    x_eq_next <= x_eq_cur and x_eq_prev;
    x_lt_next <= (x_lt_cur and x_eq_prev) or x_lt_prev;
end architecture;