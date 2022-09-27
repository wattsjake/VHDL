library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity four_bit_adder is
  Port (A, B : in std_logic_vector(3 downto 0);
        Cin : in std_logic;
        Sum: out std_logic_vector(4 downto 0));
end four_bit_adder;

architecture Behavioral of four_bit_adder is
component full_adder is
  Port (X, Y, Cin: in std_logic;
		S, Co:     out std_logic);
end component;

signal C : std_logic_vector (4 downto 0);
begin
C(0) <= Cin;

four_bit_adder: for ii in 0 to 3 generate
    FAx : full_adder port map(A(ii), B(ii), C(ii), Sum(ii), C(ii+1));
end generate;

sum(4) <= c(4);


end Behavioral;
