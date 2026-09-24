library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task3 is
    port (
        led_o: out std_logic_vector(3 downto 0);
        sw_i: in std_logic_vector(3 downto 0)
    );
end Task3;

architecture Structural of Task3 is
component DINV
    generic(d: time := 10ns);
    port(
        a: in std_logic;
        z: out std_logic
    );
end component DINV;
component DOR2
    generic(d: time := 10ns);
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end component DOR2;
component DAND2
    generic(d: time := 10ns);
    port(
        a, b: in std_logic;
        z: out std_logic
    );
end component DAND2;
component INTERCONNECT
    generic(
        delay: time := 5ns
    );
    port(
        x: in std_logic;
        z: out std_logic
    );
end component INTERCONNECT;
--y0 = x0;
--y1 = Nx3Nx2x1 + x3x2Nx1
--y2 = x2Nx1Nx0 + x3Nx2x1x0 + x3x2Nx1
--y3 = x3x2x1
constant delay: time := 20ns;
constant connect_delay: time := 5ns;
signal nsw_i, nsw_i_delay, sw_i_delay, result: std_logic_vector(3 downto 0);
signal Nx2x1, Nx3Nx2x1, x3x2, x3x2Nx1, x2Nx1, x2Nx1Nx0, x3Nx2, x3Nx2x1, x3Nx2x1x0, x2Nx1Nx0_x3Nx2x1x0,
Nx2x1_delay, Nx3Nx2x1_delay, x3x2_delay, x3x2Nx1_delay, x2Nx1_delay, x2Nx1Nx0_delay, x3Nx2_delay,
x3Nx2x1_delay, x3Nx2x1x0_delay, x2Nx1Nx0_x3Nx2x1x0_delay: std_logic;
begin
    u0: INTERCONNECT generic map(connect_delay) port map (sw_i(0), led_o(0));
    
    u1: INTERCONNECT generic map(connect_delay) port map (sw_i(0), sw_i_delay(0));
    u2: INTERCONNECT generic map(connect_delay) port map (sw_i(1), sw_i_delay(1));
    u3: INTERCONNECT generic map(connect_delay) port map (sw_i(2), sw_i_delay(2));
    u4: INTERCONNECT generic map(connect_delay) port map (sw_i(3), sw_i_delay(3));
    
    u5: DINV generic map(delay) port map(sw_i_delay(0), nsw_i(0));
    u6: DINV generic map(delay) port map(sw_i_delay(1), nsw_i(1));
    u7: DINV generic map(delay) port map(sw_i_delay(2), nsw_i(2));
    u8: DINV generic map(delay) port map(sw_i_delay(3), nsw_i(3));
    
    u9: INTERCONNECT generic map(connect_delay) port map (nsw_i(0), nsw_i_delay(0));
    u10: INTERCONNECT generic map(connect_delay) port map (nsw_i(1), nsw_i_delay(1));
    u11: INTERCONNECT generic map(connect_delay) port map (nsw_i(2), nsw_i_delay(2));
    u12: INTERCONNECT generic map(connect_delay) port map (nsw_i(3), nsw_i_delay(3));
    
    u13: DAND2 generic map(delay) port map(nsw_i_delay(2), sw_i_delay(1), Nx2x1);
    u14: INTERCONNECT generic map(connect_delay) port map (Nx2x1, Nx2x1_delay);
    u15: DAND2 generic map(delay) port map(nsw_i_delay(3), Nx2x1_delay, Nx3Nx2x1);
    u16: INTERCONNECT generic map(connect_delay) port map (Nx3Nx2x1, Nx3Nx2x1_delay);
    u17: DAND2 generic map(delay) port map(sw_i_delay(3), sw_i_delay(2), x3x2);
    u18: INTERCONNECT generic map(connect_delay) port map (x3x2, x3x2_delay);
    u19: DAND2 generic map(delay) port map(x3x2_delay, nsw_i_delay(1), x3x2Nx1);
    u20: INTERCONNECT generic map(connect_delay) port map (x3x2Nx1, x3x2Nx1_delay);
    u21: DOR2 generic map(delay) port map(Nx3Nx2x1_delay, x3x2Nx1_delay, result(1));
    u22: INTERCONNECT generic map(connect_delay) port map (result(1), led_o(1));

    u23: DAND2 generic map(delay) port map(sw_i_delay(2), nsw_i_delay(1), x2Nx1);
    u24: INTERCONNECT generic map(connect_delay) port map (x2Nx1, x2Nx1_delay);
    u25: DAND2 generic map(delay) port map(x2Nx1_delay, nsw_i_delay(0), x2Nx1Nx0);
    u26: INTERCONNECT generic map(connect_delay) port map (x2Nx1Nx0, x2Nx1Nx0_delay);
    u27: DAND2 generic map(delay) port map(sw_i_delay(3), Nx2x1_delay, x3Nx2x1);
    u28: INTERCONNECT generic map(connect_delay) port map (x3Nx2x1, x3Nx2x1_delay);
    u29: DAND2 generic map(delay) port map(x3Nx2x1_delay, sw_i_delay(0), x3Nx2x1x0);
    u30: INTERCONNECT generic map(connect_delay) port map (x3Nx2x1x0, x3Nx2x1x0_delay);
    u32: DOR2 generic map(delay) port map(x2Nx1Nx0_delay, x3Nx2x1x0_delay, x2Nx1Nx0_x3Nx2x1x0);
    u33: INTERCONNECT generic map(connect_delay) port map (x2Nx1Nx0_x3Nx2x1x0, x2Nx1Nx0_x3Nx2x1x0_delay);
    u34: DOR2 generic map(delay) port map(x2Nx1Nx0_x3Nx2x1x0_delay, x3x2Nx1_delay, result(2));
    u35: INTERCONNECT generic map(connect_delay) port map (result(2), led_o(2));
    
    u36: DAND2 generic map(delay) port map(x3x2_delay, sw_i_delay(1), result(3));
    u37: INTERCONNECT generic map(connect_delay) port map (result(3), led_o(3));

end Structural;
