--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity full_adder_ex01_TB is
end full_adder_ex01_TB;

architecture Behavioral of full_adder_ex01_TB is

component full_adder_ex01 is
  port (x, y, c_in: in bit; --inputs
        c_out, sum: out bit); --outputs
end component;

signal x_TB: bit;
signal y_TB: bit;
signal c_in_TB: bit;
signal c_out_TB: bit;
signal sum_TB: bit;

begin

full_adder_ex01_TB: full_adder_ex01 port map (x => x_TB,
								              y => y_TB,
								              c_in => c_in_TB,
								              c_out => c_out_TB,
								              sum => sum_TB);

process
    begin
        x_TB <= '0';
		y_TB <= '0';
		c_in_TB <= '0';
		wait for 10ns;
		
		x_TB <= '1';
		y_TB <= '0';
		c_in_TB <= '0';
		wait for 10ns;
		
		x_TB <= '0';
		y_TB <= '1';
		c_in_TB <= '0';
		wait for 10ns;
		
		x_TB <= '0';
		y_TB <= '0';
		c_in_TB <= '1';
		wait for 10ns;
		
		x_TB <= '1';
		y_TB <= '1';
		c_in_TB <= '0';
		wait for 10ns;
		
		x_TB <= '1';
		y_TB <= '1';
		c_in_TB <= '1';
		wait for 10ns;
		
    end process;
end Behavioral;
