use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity interface is  
port (
 Addr : in  std_logic_vector(1 downto 0 ) ; 
Wr : in std_logic ; 
Rd : in  std_logic ; 
D_out : out std_logic_vector (7 downto 0 ) ; 
Reset_n : in std_logic ; 
Clk : in std_logic ; 
 Irq_ELN_n : out std_logic  ; 
)  ;

end entity interface ; 

architecture
