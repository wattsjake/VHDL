library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tx_TB is
end tx_TB;

architecture Behavioral of tx_TB is

component transmitter is
  port (clk: in std_logic;	--clock input
		rst: in std_logic;	--reset, active high
		pdata: in std_logic_vector(7 downto 0); --parallel data in
		load: in std_logic; -- ready_rx sends signal to this  
		sdata: out std_logic; --serial data out from tx
		busy: out std_logic);
end component;

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
signal ready_TB:std_logic;
signal load_TB: std_logic;
signal busy_TB: std_logic;
signal n_clk_TB: std_logic;
signal pdata_in_TB:std_logic_vector(7 downto 0);
signal pdata_out_TB:std_logic_vector(7 downto 0);

begin

UUT_tx_TB: transmitter port map (clk => n_clk_TB,
                                 rst => rst_TB,
                                 pdata => pdata_in_TB,
								 load => load_TB,
                                 sdata => sdata_TB,
                                 busy => busy_TB);

UUT_rx_TB: receiver port map (clk => clk_TB,
							  rst => rst_TB,
							  sdata => sdata_TB,
							  pdata => pdata_out_TB,
							  ready => ready_TB);
							  	
clk_TB <= not clk_TB after 5 ns; --creates clock with 10ns period
n_clk_TB <= not clk_TB; --use the inverse of clock for the transmitter	


process 
	begin
		--clock set reset
		rst_TB <= '1';
		wait for 10us;
		rst_TB <= '0';
		wait for 10us;
		
		pdata_in_TB <= "00000101";
		load_TB <= '1';
		wait for 10us;
		load_TB <= '0';
		wait for 868us;
		
		pdata_in_TB <= "11111111";
		load_TB <= '1';
		wait for 10us;
		load_TB <= '0';
		wait for 868us;
		
		pdata_in_TB <= "10000001";
		load_TB <= '1';
		wait for 10us;
		load_TB <= '0';
		wait for 868us;
		
	    rst_TB <= '1';
		wait for 10us;
		rst_TB <= '0';
		wait for 10us;
		wait;
		
		
    end process;
end Behavioral;

