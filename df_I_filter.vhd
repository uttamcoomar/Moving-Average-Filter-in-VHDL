library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_reg is
 generic(
     data_width: integer := 8
     );
 port(rst: in STD_LOGIC;
      clk: in STD_LOGIC;
      D: in STD_LOGIC_VECTOR(data_width-1 downto 0) ;
      Q: out STD_LOGIC_VECTOR(data_width-1 downto 0)  );
 end entity shift_reg; 
    
 architecture rtl of shift_reg is
 begin
 process(clk,rst)
 begin 
 if rst='1' then
      Q <= (others=>'0');
 elsif rising_edge(clk) then
		Q <= D;
 end if;
 end process;
 end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

 entity adder is
 generic(
     data_width: integer := 8
     );
 port( 
      A: in STD_LOGIC_VECTOR(data_width-1 downto 0) ;
      B: in STD_LOGIC_VECTOR(data_width-1 downto 0) ;
      C: out STD_LOGIC_VECTOR(data_width-1 downto 0) );
 end entity adder; 
      
 architecture rtl of adder is
 begin
    
    C <= std_logic_vector(signed(A) + signed(B));
    
 end;
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity df_I_filter is
generic(data_width: integer := 8);
port(rst: in STD_LOGIC;
     clk: in STD_LOGIC;
     X: in STD_LOGIC_VECTOR(data_width-1 downto 0) ;
     Y: out STD_LOGIC_VECTOR(data_width-1 downto 0));
end entity df_I_filter;

architecture block_type of df_I_filter is

 
 component shift_reg
  generic(
     data_width: integer := 8
     );
 port(rst: in STD_LOGIC;
      clk: in STD_LOGIC;
      D: in STD_LOGIC_VECTOR(data_width-1 downto 0);
      Q: out STD_LOGIC_VECTOR(data_width-1 downto 0) ); 
 end component;
 
component adder is
 generic(
     data_width: integer := 8
     );
 port( 
      A: in STD_LOGIC_VECTOR(data_width-1 downto 0) ;
      B: in STD_LOGIC_VECTOR(data_width-1 downto 0) ;
      C: out STD_LOGIC_VECTOR(data_width-1 downto 0) );
 end component; 
 
 constant taps: integer := 4; 
 type Do is array(0 to taps) of STD_LOGIC_VECTOR(data_width-1 downto 0);
 signal DI: Do := (others => (others => '0')) ;
 signal sig: Do := (others => (others => '0')) ;
 
 begin
      
      DI(0) <= X;
      sig(0) <= X;
  
      GEN_SHIFT_REG: for I in 0 to taps-2 generate
                    SHIFT_REGX: shift_reg port map(rst,clk,DI(I),DI(I+1));
      end generate GEN_SHIFT_REG;
      
      GEN_ADD: for I in 0 to taps-2 generate
                    SHIFT_ADDX: adder port map(sig(I),DI(I+1),sig(I+1));
      end generate GEN_ADD;
      
      Y <= std_logic_vector(shift_right(signed(sig(taps-1)),integer(log2(real(taps)))));
      
 end;
