--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_ECHO is
  port (clk: in std_logic; --master clk
		rst: in std_logic; --master rst
		sdata_in: in std_logic; --sdata in
		sdata_out: out std_logic; 
		busy_out: out std_logic;
		pdata_out: out std_logic_vector(7 downto 0)); --led lights out
end UART_ECHO;

architecture Behavioral of UART_ECHO is

component receiver is
    port(clk:   in std_logic;                       --clock input
         rst:   in std_logic;                       --reset, active high
         sdata: in std_logic;                       --serial data in
         pdata: out std_logic_vector(7 downto 0);   --parallel data out
         ready: out std_logic);                     --ready strobe, active high
end component;

component transmitter is
  port (clk: in std_logic;	--clock input
		rst: in std_logic;	--reset, active high
		pdata: in std_logic_vector(7 downto 0); --parallel data in
		load: in std_logic; -- ready_rx sends signal to this  
		sdata: out std_logic; --serial data out from tx
		busy: out std_logic);
end component;

signal n_clk: std_logic;
signal pdata_s: std_logic_vector(7 downto 0);
signal ready_s: std_logic;
signal busy_s: std_logic;
--signal state_device: std_logic_vector(2 downto 0);

begin

n_clk <= not clk;
pdata_out <= pdata_s; --led lights out

UUT_rx: receiver port map (clk => clk,
						   rst => rst,
						   sdata => sdata_in,
						   pdata => pdata_s,
						   ready => ready_s);

UUT_tx: transmitter port map (clk => n_clk,
                              rst => rst,
                              pdata => pdata_s,
							  load => ready_s,
                              sdata => sdata_out,
                              busy => busy_out);

end Behavioral;
