--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity transmitter is
  port (clk: in std_logic;	--clock input
		rst: in std_logic;	--reset, active high
		pdata: in std_logic_vector(7 downto 0); --parallel data in
		load: in std_logic; -- ready_rx sends signal to this  
		sdata: out std_logic; --serial data out from tx
		busy: out std_logic);
end transmitter;

architecture Behavioral of transmitter is
	type STATES is (IDLE,DATA);
	signal state_tx: STATES := IDLE;
	signal buffer_tx: std_logic_vector(9 downto 0); --create a larger array to hold start, stop bits.
	signal bit_idx: integer :=0; --used in DATA
	signal count_down: integer :=0; --used for counting
	constant FULL_COUNT: integer :=868;
	
begin

process(clk, rst)
begin

	if rst = '1' then
		state_tx <= IDLE;
		busy <= '0'; --reset busy to 0
		sdata <= '1';
		bit_idx <= 0;
		count_down <= FULL_COUNT;
		--buffer_tx <= (OTHERS => '0');
		buffer_tx <= "1000000000"; --stop bit .... start bit
		
	
	elsif rising_edge(clk) then --should this be falling edge change in TOP
	    --bit_idx <= 0; --do i need to do this?
		case state_tx is
			when IDLE =>
			    sdata <= '1';
			    bit_idx <= 0;
				count_down <= FULL_COUNT; --set count_down to full count
				if load = '1' then
					buffer_tx(8 downto 1) <= pdata;
					state_tx <= DATA;
					busy <= '1'; --set busy equal to one? check this
				else
					state_tx <= IDLE;
					busy <= '0';
				end if;
			when DATA =>
				count_down <= count_down - 1;
			    sdata <= buffer_tx(bit_idx);
				busy <= '1';
				if(count_down <= 0) then
					bit_idx <= bit_idx + 1;
					state_tx <= DATA;
					count_down <= FULL_COUNT; --added debug
					if(bit_idx >= 9) then --changed from 7 to 9
					   state_tx <= IDLE;
					   bit_idx <= 0;
					   busy <= '0';
				    else
				        state_tx <= DATA;
                    end if;
                else
                    bit_idx <= bit_idx; --added with dr gardner
                    state_tx <= DATA;
				end if;
		end case;
	end if;									
end process;
 
end Behavioral;
