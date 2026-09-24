library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity LUT_NAND2 is
    port (
        X1, X2  : in    std_logic;
        Y       : out   std_logic
    );
end LUT_NAND2;

architecture Netlist of LUT_NAND2 is
    constant NAND2_INIT :   bit_vector := X"7";
begin
    LUT2_inst : LUT2 
    generic map (
        INIT => NAND2_INIT
    )
    port map (
        I0 => X1,
        I1 => X2,
        O => Y
    );
end Netlist;