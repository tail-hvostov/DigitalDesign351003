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
        i1,i2 : in  std_logic;
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

architecture arch of wire_delay is
begin
    y <= transport i1 after delay;
end arch;

-------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity task2_1 is
    Port(
        G3, G2, G1, G0  : in  std_logic;
        L3, L2, L1, L0 : out std_logic
    );
end task2_1;

architecture structural of task2_1 is
     
       component inv is
            generic (delay : time);
            port(
                i1 : in  std_logic;
                y : out std_logic
            );
        end component;
        
        component and2 is
        generic (delay : time);
                    port(
                        i1,i2 : in  std_logic;
                        y : out std_logic
                    );
        end component;
                
        component or2 is
        generic (delay : time);
                    port(
                         i1,i2 : in  std_logic;
                         y : out std_logic
                    );
        end component;
    
        component xor2 is
        generic (delay : time);
                    port(
                          i1,i2 : in  std_logic;
                          y : out std_logic
                    );
        end component;
        
    
        component wire_delay is
        generic (delay : time);
                    port(
                          i1: in  std_logic;
                          y : out std_logic
                        );
        end component;
        
    signal nG3, nG2, nG1, nG0 : std_logic;

    signal a1, a2 : std_logic; -- для L0
    signal a3, a4 : std_logic; -- для L1
    signal a5, x1 : std_logic; -- для L2
    
    signal w1, w2, w3, w4, w5, wx1 : std_logic;
  
begin
--------------------------------------------------------INV---------------------------------------------------------
    Y_I0 : inv
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G0,
            y =>  nG0
         );
    Y_I1 : inv
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G1,
            y =>  nG1
         ); 
    Y_I2 : inv
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G2,
            y =>  nG2
         );  
    Y_I3 : inv
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G3,
            y =>  nG3
         );
--------------------------------------------------------AND@2---------------------------------------------------------                
    Y_A0 : and2
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  nG3,
            i2 =>  G2,
            y => a1
         );
    Y_A1 : and2
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  nG1,
            i2 =>  G0,
            y =>  a2
         );
    Y_A3 : and2
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G1,
            i2 =>  nG0,
            y =>  a3
         );
    Y_A4 : and2
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G3,
            i2 =>  nG2,
            y =>  a4
         );
    Y_A5 : and2
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G1,
            i2 =>  G0,
            y =>  a5
         );
    Y_A6 : and2
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G2,
            i2 =>  G3,
            y =>  L3
         );
--------------------------------------------------------XOR2---------------------------------------------------------
    Y_X1 : xor2
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  G2,
            i2 =>  G3,
            y =>  x1
         );
 -------------------------------------------------------------------------------------------------------------------        
    W_1: wire_delay 
    generic map (delay => 0.5 ns) 
        port map(
            i1 => a1,
            y => w1
        );       
    W_2: wire_delay 
    generic map (delay  => 0.5 ns) 
        port map(
            i1 => a2,
            y => w2
        );       
    W_3: wire_delay 
    generic map (delay => 0.5 ns) 
        port map(
            i1 => a3,
            y => w3
            );      
    W_4: wire_delay 
    generic map (delay => 0.5 ns) 
        port map(
            i1 => a4,
            y => w4
            ); 
    W_5: wire_delay 
    generic map (delay => 0.5 ns) 
        port map(
            i1 => a5,
            y => w5
            ); 
    W_X: wire_delay 
    generic map (delay => 0.5 ns) 
        port map(
            i1 => x1,
            y => wx1
            );          
--------------------------------------------------------OR2---------------------------------------------------------
    Y_O1 : or2
    generic map (delay => 0.5 ns)
         port map(
            i1 =>  w1,
            i2 =>  w2,
            y =>  L0
     );
    Y_O2 : or2
    generic map (delay => 0.5 ns)
          port map(
             i1 =>  w3,
             i2 =>  w4,
             y =>  L1
      );
    Y_O3 : or2
    generic map (delay => 0.5 ns)
           port map(
              i1 =>  w5,
              i2 =>  wx1,
              y =>  L2
       );
end structural;
