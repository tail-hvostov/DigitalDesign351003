library ieee;
use ieee.std_logic_1164.all;
use work.Delay.all;

entity INV is
    generic (
        gate_delay : time := INV_DELAY
    );
    port (
        I : in std_logic;
        O : out std_logic
    );
end INV;

architecture Behavioral of INV is
begin
    O <= not I after gate_delay;
end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use work.Delay.all;

entity AND2 is
    generic (
        gate_delay : time := AND2_DELAY
    );
    port (
        A, B : in std_logic;
        F : out std_logic
    );
end AND2;

architecture Behavioral of AND2 is
begin
    F <= A and B after gate_delay;
end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use work.Delay.all;

entity OR2 is
    generic (
        gate_delay : time := OR2_DELAY
    );
    port (
        A, B : in std_logic;
        F : out std_logic
    );
end OR2;

architecture Behavioral of OR2 is
begin
    F <= A or B after gate_delay;
end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use work.Delay.all;

entity wire_delay is
    generic (
        DELAY : time := 0.2 ns
    );
    port (
        input : in std_logic;
        output : out std_logic
    );
end wire_delay;

architecture Behavioral of wire_delay is
begin
    output <= input after DELAY;
end Behavioral;