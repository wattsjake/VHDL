--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bitcounter is
  port (clk: in std_logic;
		x: in std_logic_vector(3 downto 0);
        b: out std_logic_vector(2 downto 0));
end bitcounter;

architecture Behavioral of bitcounter is
	signal count :integer :=0; --used for counter in for loop
	
begin
process(clk)

begin
    count <= 0;
	loop1: for ii in 0 to 3 loop
		if (x(ii) = '1') then
			count <= count + 1;
		else
			count <= count + 0;
        end if;
	end loop loop1;
	
	b <= std_logic_vector(to_unsigned(count, b'length));
	
end process;
	


	
end Behavioral;