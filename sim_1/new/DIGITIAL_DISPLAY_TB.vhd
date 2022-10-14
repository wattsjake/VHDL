--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIGITAL_DISPLAY_TB is
end DIGITAL_DISPLAY_TB;

architecture Behavioral of DIGITAL_DISPLAY_TB is

component DIGITAL_DISPLAY is
  Port (clk:        in std_logic;
        rst:        in std_logic;
        pdata_in:   in std_logic_vector(7 downto 0);
        led_out:    out std_logic_vector(7 downto 0);
        display_out:out std_logic_vector(6 downto 0);
        enable:     out std_logic_vector(3 downto 0));
end component;

signal clk_TB: 	        std_logic :='0';
signal rst_TB:  	    std_logic;
signal pdata_in_TB:     std_logic_vector(7 downto 0);
signal led_out_TB:      std_logic_vector(7 downto 0);
signal display_out_TB:  std_logic_vector(6 downto 0);
signal enable_TB:       std_logic_vector(3 downto 0);


begin

UUT_DIGITAL_DISPLAY_TB: DIGITAL_DISPLAY port map (clk => clk_TB,
                                                  rst => rst_TB,
                                                  pdata_in => pdata_in_TB,
                                                  led_out => led_out_TB,
                                                  display_out => display_out_TB,
                                                  enable => enable_TB);

clk_TB <= not clk_TB after 5 ns; --10ns period clk

process 
	begin
		rst_TB <= '1';
		wait for 10us;
		rst_TB <= '0';
		wait for 10us;
		pdata_in_TB <= "11111111";
		wait for 1ms;
		pdata_in_TB <= "11110000";
		wait for 1ms;
		pdata_in_TB <= "00001111";
		wait for 1ms;
		pdata_in_TB <= "00000000";
		wait for 100ms;
		pdata_in_TB <= "00110001";
		wait;		
    end process;
end Behavioral;