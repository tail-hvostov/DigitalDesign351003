library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity interconnect is
    generic(
        WIDTH : integer := 1;
        DELAY : time := 1 ns
    );
    port(
        bus_i : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        bus_o : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end interconnect;

architecture rtl of interconnect is
begin
    GEN_WIRE: for i in 0 to WIDTH-1 generate
        bus_o(i) <= transport bus_i(i) after DELAY;
    end generate;
end rtl;