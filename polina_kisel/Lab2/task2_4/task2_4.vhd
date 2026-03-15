library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inv is
    generic ( 
        delay : time := 2 ns 
    );
    port(
        i1 : in  std_logic;
        y : out std_logic 
    );
end inv;

architecture arch of inv is begin
    y <= (not i1) after delay;
end arch;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and2 is
    generic ( 
        delay : time := 2 ns 
    );
    port(
        i1, i2 : in  std_logic;
        y : out std_logic
    );
end and2;

architecture arch of and2 is begin
    y <= (i1 and i2) after delay;
end arch;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or2 is
    generic ( 
        delay : time := 2 ns 
    );
    port(
        i1, i2 : in  std_logic;
        y : out std_logic
    );
end or2;

architecture arch of or2 is begin
    y <= (i1 or i2) after delay;
end arch;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor2 is
    generic ( 
         delay : time := 2 ns 
    );
    port(
        i1, i2 : in  std_logic;
        y : out std_logic
    );
end xor2;

architecture arch of xor2 is begin
    y <= (i1 xor i2) after delay;
end arch;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity wire_delay is
    generic ( 
        delay : time := 1 ns 
    );
    port ( 
        i1 : in std_logic;
        y : out std_logic 
    );
end wire_delay;

architecture arch of wire_delay is begin
    y <= transport i1 after delay;
end arch;

------------------ÎÄÍÎÐÀÇÐßÄÍÛÉ ÊÎÌÏÀÐÀÒÎÐ-------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp_1_bit is
    Port(
        x_in, y_in    : in  std_logic;
        E_prev     : in  std_logic;
        G_prev     : in  std_logic;
        L_prev     : in  std_logic;
        E_out, G_out, L_out : out std_logic
    );
end comp_1_bit;

architecture structural of comp_1_bit is

    component inv is
        generic (delay : time);
        port(
            i1 : in std_logic;
            y  : out std_logic
        );
    end component;

    component and2 is
        generic (delay : time);
        port(
            i1, i2 : in std_logic;
            y      : out std_logic
        );
    end component;

    component xor2 is
        generic (delay : time);
        port(
            i1, i2 : in std_logic;
            y      : out std_logic
        );
    end component;

    component or2 is
        generic (delay : time);
        port(
            i1, i2 : in std_logic;
            y      : out std_logic
        );
    end component;

    component wire_delay is
        generic (delay : time);
        port(
            i1 : in std_logic;
            y  : out std_logic
        );
    end component;

    signal nx, ny, x_xor_y : std_logic;
    signal E_cur, G_cur, L_cur : std_logic;
    signal G_prev_m, L_prev_l : std_logic;
    signal w_G_cur, w_L_cur : std_logic;

begin

    Y_X1 : xor2
        generic map (delay => 0.5 ns)
        port map(
            i1 => x_in,
            i2 => y_in,
            y  => x_xor_y
        );

    Y_I2 : inv
        generic map (delay => 0.5 ns)
        port map(
            i1 => x_xor_y,
            y  => E_cur
        );

    Y_I0 : inv
        generic map (delay => 0.5 ns)
        port map(
            i1 => y_in,
            y  => ny
        );

    Y_A0 : and2
        generic map (delay => 0.5 ns)
        port map(
            i1 => x_in,
            i2 => ny,
            y  => G_cur
        );

    Y_I1 : inv
        generic map (delay => 0.5 ns)
        port map(
            i1 => x_in,
            y  => nx
        );

    Y_A1 : and2
        generic map (delay => 0.5 ns)
        port map(
            i1 => nx,
            i2 => y_in,
            y  => L_cur
        );

    Y_A2 : and2
        generic map (delay => 0.5 ns)
        port map(
            i1 => E_cur,
            i2 => E_prev,
            y  => E_out
        );

    Y_A3 : and2
        generic map (delay => 0.5 ns)
        port map(
            i1 => E_cur,
            i2 => G_prev,
            y  => G_prev_m
        );

    W_1 : wire_delay
        generic map (delay => 0.5 ns)
        port map(
            i1 => G_cur,
            y  => w_G_cur
        );

    Y_O1 : or2
        generic map (delay => 0.5 ns)
        port map(
            i1 => w_G_cur,
            i2 => G_prev_m,
            y  => G_out
        );

    Y_A4 : and2
        generic map (delay => 0.5 ns)
        port map(
            i1 => E_cur,
            i2 => L_prev,
            y  => L_prev_l
        );

    W_2 : wire_delay
        generic map (delay => 0.5 ns)
        port map(
            i1 => L_cur,
            y  => w_L_cur
        );

    Y_O2 : or2
        generic map (delay => 0.5 ns)
        port map(
            i1 => w_L_cur,
            i2 => L_prev_l,
            y  => L_out
        );

end structural;


-------------------3õáèòíûé êîìïîðàòîð---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp_3bit is
    Port(
        X0, X1, X2 : in std_logic;
        Y0, Y1, Y2 : in std_logic;
        Eq_out, Gt_out, Lt_out : out std_logic
    );
end comp_3bit;

architecture structural of comp_3bit is

    component comp_1_bit is
        Port(
            x_in, y_in : in std_logic;
            E_prev, G_prev, L_prev : in std_logic;
            E_out, G_out, L_out : out std_logic
        );
    end component;

    signal e0, g0, l0 : std_logic;
    signal e1, g1, l1 : std_logic;

begin

    BIT_0: comp_1_bit
        port map(
            x_in => X0,
            y_in => Y0,
            E_prev => '1',
            G_prev => '0',
            L_prev => '0',
            E_out => e0,
            G_out => g0,
            L_out => l0
        );

    BIT_1: comp_1_bit
        port map(
            x_in => X1,
            y_in => Y1,
            E_prev => e0,
            G_prev => g0,
            L_prev => l0,
            E_out => e1,
            G_out => g1,
            L_out => l1
        );

    BIT_2: comp_1_bit
        port map(
            x_in => X2,
            y_in => Y2,
            E_prev => e1,
            G_prev => g1,
            L_prev => l1,
            E_out => Eq_out,
            G_out => Gt_out,
            L_out => Lt_out
        );

end structural;