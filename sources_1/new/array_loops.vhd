--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity array_loops is
  Port (clk: in std_logic);
end array_loops;

architecture Behavioral of array_loops is

type matrix4x3 is array (0 to 3, 0 to 2) of integer;
constant mtx0: matrix4x3 := ((1,2,3),(4,5,6),(7,8,9),(10,11,12));
--mtx0 
--1,  2, 3
--4,  5, 6
--7,  8, 9
--10,11,12

type matrix8x4 is array (0 to 7) of std_logic_vector(3 downto 0);
signal mtx1: matrix8x4;
--mtx1 
--0,0,0,0
--0,0,0,0
--0,0,0,0
--0,0,0,0
--0,0,0,0
--0,0,0,0
--0,0,0,0
--0,0,0,0

begin

process(clk)
begin
loop1: for ii in 0 to 3 loop
	mtx1(ii) <= std_logic_vector((unsigned(mtx1(ii)))+1);
end loop loop1;
end process;

process(clk)
begin
loop1: for ii in mtx1'range loop --attribute 'range
	mtx1(ii) <= std_logic_vector((unsigned(mtx1(ii)))+1);
end loop loop1;
end process;


end Behavioral;
