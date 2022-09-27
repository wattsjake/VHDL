--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bitcounter_TB is
end bitcounter_TB;

architecture Behavioral of bitcounter_TB is

component bitcounter is
  port (clk: in std_logic :='0';
		x: in std_logic_vector(3 downto 0); --inputs
        b: out std_logic_vector(2 downto 0)); --outputs
end component;

signal clk_TB: 	std_logic :='0';
signal x_TB: std_logic_vector(3 downto 0);
signal b_TB: std_logic_vector(2 downto 0);

begin

bitcounter_TB: bitcounter port map (clk => clk_TB,
									x => x_TB,
								    b => b_TB);
									
clk_TB <= not clk_TB after 5 ns;

process
    begin
        x_TB <= "0000";
		wait for 1us;
		x_TB <= "0001";
		wait for 1us;
		x_TB <= "0011";
		wait for 1us;
		x_TB <= "1110";
		wait for 1us;
		x_TB <= "0110";
		wait;
		
		
    end process;
end Behavioral;
