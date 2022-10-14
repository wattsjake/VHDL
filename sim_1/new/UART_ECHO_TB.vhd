library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_ECHO_TB is
end UART_ECHO_TB;

architecture Behavioral of UART_ECHO_TB is

component UART_ECHO is
  port (clk: in std_logic; --master clk
		rst: in std_logic; --master rst
		sdata_in: in std_logic; --sdata in
		sdata_out: out std_logic; 
		busy_out: out std_logic;
		pdata_out: out std_logic_vector(7 downto 0)); --led lights out
end component;

signal clk_TB: 	std_logic :='0';
signal rst_TB: 	std_logic;
signal sdata_TB:std_logic;
signal sdata_out_TB:std_logic;
signal pdata_TB:std_logic_vector(7 downto 0);
signal busy_TB:std_logic;
CONSTANT BIT_PERIOD_TB: time :=8680ns; 

procedure TX_BITS(
    data : in std_logic_vector(7 downto 0);
    signal tx_serial : out std_logic) is
begin
    tx_serial <= '0';
    wait for BIT_PERIOD_TB; -- BIT_PERIOD_TB is a constant that you need to calculate
    
    for ii in 0 to 7 loop
        tx_serial <= data(ii);
        wait for BIT_PERIOD_TB;
    end loop;
     
    tx_serial <= '1';
    wait for BIT_PERIOD_TB;
     
end TX_BITS;

begin

UUT_UART_ECHO_TB: UART_ECHO port map (clk => clk_TB,
								rst => rst_TB,
								sdata_in => sdata_TB,
								pdata_out => pdata_TB,
								sdata_out => sdata_out_TB,
								busy_out => busy_TB);
								
clk_TB <= not clk_TB after 5 ns; 					--creates clock with 10ns period

process 
	begin
		--clock set reset
		rst_TB <= '1';
		wait for 10ns;
		rst_TB <= '0';
		wait for 10ns;
		
        wait until rising_edge(clk_TB);
        TX_BITS(X"56", sdata_TB);
        wait for 1us;
        TX_BITS(X"12", sdata_TB);
        TX_BITS(X"13", sdata_TB);
        TX_BITS(X"14", sdata_TB);
        wait for 100us;
        
        rst_TB <= '1';
        wait for 1us;
		rst_TB <= '0';
		
		TX_BITS(X"15", sdata_TB);
		
        
        wait;
        
    end process;
end Behavioral;
