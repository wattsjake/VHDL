library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reciever_TB is
end reciever_TB;

architecture Behavioral of reciever_TB is

component receiver is
    port(clk:   in std_logic;                       --clock input
         rst:   in std_logic;                       --reset, active high
         sdata: in std_logic;                       --serial data in
         pdata: out std_logic_vector(7 downto 0);   --parallel data out
         ready: out std_logic);                     --ready strobe, active high
end component;

signal clk_TB: 	std_logic :='0';
signal rst_TB: 	std_logic;
signal sdata_TB:std_logic;
signal pdata_TB:std_logic_vector(7 downto 0);
signal ready_TB:std_logic;
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

UUT_reciever_TB: receiver port map (clk => clk_TB,
								rst => rst_TB,
								sdata => sdata_TB,
								pdata => pdata_TB,
								ready => ready_TB);
								
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

