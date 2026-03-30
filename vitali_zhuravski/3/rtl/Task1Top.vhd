library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Task1Top is
    port (
        led_out : out std_logic_vector(15 downto 0);
        sw_in : in std_logic_vector(15 downto 0)
    );
end Task1Top;

architecture Structural of Task1Top is
    signal R : std_logic;
    signal S : std_logic;
    signal Q : std_logic;
    signal nQ : std_logic;
    signal Qf : std_logic;
    signal nQf : std_logic;
begin
    R <= sw_in(1);
    S <= sw_in(0);
    
    Qf <= transport Q after 5ns;
    nQf <= transport nQ after 5ns;

    U0 : LUT2
        generic map(INIT => "0111")
        port map(I0 => R, I1 => nQf, O => Q);
    U1 : LUT2
        generic map(INIT => "0111")
        port map(I0 => Qf, I1 => S, O => nQ);

    led_out(15 downto 2) <= (others => '0');
    led_out(1) <= Q;
    led_out(0) <= nQ;
end Structural;
