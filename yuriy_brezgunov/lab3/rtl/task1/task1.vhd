library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;


entity task1 is
    port (
        sw  : in  std_logic_vector(15 downto 14); -- sw(15)=R, sw(14)=
        led : out std_logic_vector(15 downto 14)  
    );
end task1;

architecture rtl of task1 is
    signal q, nq : std_logic;
begin
    lut_q : LUT2
        generic map (INIT => "0111") -- NAND
        port map (
            I0 => sw(15), -- R
            I1 => nq,
            O  => q
        );

    lut_qn : LUT2
        generic map (INIT => "0111")
        port map (
            I0 => sw(14), -- S
            I1 => q,
            O  => nq
        );
        
        led(15) <= q;
        led(14) <= nq;
end rtl;
