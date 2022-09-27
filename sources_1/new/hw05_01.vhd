--standard library this is a test
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity statemachine is
  port (clk, rst, x1, x2: in std_logic; --inputs
        z1, z2: out std_logic); --outputs
end statemachine;

architecture Behavioral of statemachine is
	signal state: std_logic_vector(2 downto 0);
	
begin
process(clk, rst)
begin
	if rst = '1' then
		state <= "01";
	
	elsif falling_edge(clk) then
		case state is
			when "00" =>
				z1 <= '0';
				z2 <= '1';
			when "01" =>
				z1 <= '1';
				z2 <= '1';
			when "11" =>
				z1 <= '1';
				z2 <= '0';
end process;

end Behavioral;
