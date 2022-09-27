--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity full_adder_ex01 is
  port (x, y, c_in: in bit; --inputs
        c_out, sum: out bit); --outputs
end full_adder_ex01;

architecture Behavioral of full_adder_ex01 is
begin
    sum <= x xor y xor c_in after 10ns;
    c_out <= (x and y) or (x and c_in) or (y and c_in) after 10ns;
end Behavioral;
