--standard library 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_master_TB is
end spi_master_TB;

architecture Behavioral of spi_master_TB is

component spi_master is
    port(clk :      in std_logic; -- clock input
         rst :      in std_logic; -- reset, active high
         load :     in std_logic; -- notification to send data
         data_in :  in std_logic_vector(15 downto 0); -- pdata in
         sdata_0 :  out std_logic; -- serial data out 1
         sdata_1 :  out std_logic; -- serial data out 2
         spi_clk :  out std_logic; -- clk out to SPI devices
         CS0_n :    out std_logic); -- chip select 1, active low  
end component;

signal clk_TB: 	std_logic :='0';
signal rst_TB: 	std_logic;
signal load_TB: std_logic;
signal data_in_TB: std_logic_vector(15 downto 0);
signal sdata_0_TB: std_logic;
signal sdata_1_TB: std_logic;
signal spi_clk_TB: std_logic;
signal CS0_n_TB:   std_logic;


begin

UUT_spi_master_TB: spi_master port map (clk => clk_TB,
								        rst => rst_TB,
								        load => load_TB,
								        data_in => data_in_TB,
								        sdata_0 => sdata_0_TB,
								        sdata_1 => sdata_1_TB,
								        spi_clk => spi_clk_TB,
								        CS0_n => CS0_n_TB);
								
clk_TB <= not clk_TB after 5 ns;

process 
	begin
		--clock set reset
		load_TB <= '0';
		data_in_TB <= "0000000110000000";
		rst_TB <= '1';
		wait for 13ns;
		rst_TB <= '0';
		wait for 10ns;
		load_TB <= '1';
		wait for 100ns;
		load_TB <= '0';
		wait;
        
    end process;
end Behavioral;


