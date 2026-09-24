library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Task1 is
Port(
        sw  : in  std_logic_vector(1 downto 0);
        led : out std_logic_vector(1 downto 0)
    );
end entity Task1;

architecture rtl of Task1 is

    component NAND2
        port(
            A,B : in std_logic;
            F : out std_logic
        );
    end component;

    signal r_s0, r_s1, r_s2 : std_logic;
    signal s_s0, s_s1, s_s2 : std_logic;

    signal r_out_raw, r_out_mid, r_out_final : std_logic;
    signal s_out_raw, s_out_mid, s_out_final : std_logic;

    signal led0_s0, led0_s1, led0_s2 : std_logic;
    signal led1_s0, led1_s1, led1_s2 : std_logic;

    attribute keep : string;

    attribute keep of r_out_raw   : signal is "true";
    attribute keep of r_out_mid   : signal is "true";
    attribute keep of r_out_final : signal is "true";
    attribute keep of s_out_raw   : signal is "true";
    attribute keep of s_out_mid   : signal is "true";
    attribute keep of s_out_final : signal is "true";

begin

    r_s0 <= sw(0) xor '0';
    r_s1 <= r_s0 or  '0';
    r_s2 <= r_s1 and '1';

    s_s0 <= sw(1) xor '0';
    s_s1 <= s_s0 or  '0';
    s_s2 <= s_s1 and '1';

    LUT20: NAND2 PORT MAP(A => r_s2, B => s_out_final, F => r_out_raw);
    LUT21: NAND2 PORT MAP(A => s_s2, B => r_out_final, F => s_out_raw);

    r_out_mid   <= r_out_raw xor '0';
    r_out_final <= r_out_mid and '1';

    s_out_mid   <= s_out_raw xor '0';
    s_out_final <= s_out_mid and '1';

    led0_s0 <= r_out_final xor '0';
    led0_s1 <= led0_s0 or  '0';
    led0_s2 <= led0_s1 and '1';

    led1_s0 <= s_out_final xor '0';
    led1_s1 <= led1_s0 or  '0';
    led1_s2 <= led1_s1 and '1';

    led(0) <= led0_s2;
    led(1) <= led1_s2;

end rtl;