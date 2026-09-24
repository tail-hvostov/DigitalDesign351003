library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task1 is
    port (
        led_o: out std_logic_vector(3 downto 0);
        sw_i: in std_logic_vector(3 downto 0)
    );
end Task1;

architecture Structural of Task1 is
component INV
    port(
        a: in std_logic;
        z: out std_logic
    );
end component INV;
component OR2
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end component OR2;
component AND2
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end component AND2;
--y0 = x0;
--y1 = Nx3Nx2x1 + x3x2Nx1
--y2 = x2Nx1Nx0 + x3Nx2x1x0 + x3x2Nx1
--y3 = x3x2x1
signal nsw_i: std_logic_vector(3 downto 0);
signal Nx2x1, Nx3Nx2x1, x3x2, x3x2Nx1, x2Nx1, x2Nx1Nx0, x3Nx2, x3Nx2x1, x3Nx2x1x0, x2Nx1Nx0_x3Nx2x1x0: std_logic;
begin
    led_o(0) <= sw_i(0);
    
    u1: INV port map(sw_i(0), nsw_i(0));
    u2: INV port map(sw_i(1), nsw_i(1));
    u3: INV port map(sw_i(2), nsw_i(2));
    u4: INV port map(sw_i(3), nsw_i(3));
    
    u5: AND2 port map(nsw_i(2), sw_i(1), Nx2x1);
    u6: AND2 port map(nsw_i(3), Nx2x1, Nx3Nx2x1);
    u7: AND2 port map(sw_i(3), sw_i(2), x3x2);
    u8: AND2 port map(x3x2, nsw_i(1), x3x2Nx1);
    u9: OR2 port map(Nx3Nx2x1, x3x2Nx1, led_o(1));

    u10: AND2 port map(sw_i(2), nsw_i(1), x2Nx1);
    u11: AND2 port map(x2Nx1, nsw_i(0), x2Nx1Nx0);
    u12: AND2 port map(sw_i(3), Nx2x1, x3Nx2x1);
    u13: AND2 port map(x3Nx2x1, sw_i(0), x3Nx2x1x0);
    u14: OR2 port map(x2Nx1Nx0, x3Nx2x1x0, x2Nx1Nx0_x3Nx2x1x0);
    u15: OR2 port map(x2Nx1Nx0_x3Nx2x1x0, x3x2Nx1, led_o(2));
    
    u16: AND2 port map(x3x2, sw_i(1), led_o(3));

end Structural;
