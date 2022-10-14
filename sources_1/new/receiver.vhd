--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity receiver is
    --generic (baud_rate_p : integer := 115200); --check with gardner
    
    port(clk:   in std_logic;                       --clock input
         rst:   in std_logic;                       --reset, active high
         sdata: in std_logic;                       --serial data in
         pdata: out std_logic_vector(7 downto 0);   --parallel data out
         ready: out std_logic);                     --ready strobe, active high
end receiver;

architecture Behavioral of receiver is
    type STATES is (IDLE, START_BIT, DATA, STOP_BIT, SAVE_DATA);
	constant FULL_COUNT :integer :=868;								--constants are UPPER case
    constant HALF_COUNT :integer :=FULL_COUNT/2;
    signal state_rx: STATES := IDLE; 								--signals are lower case
    signal count_down :integer :=0;
    signal bit_count :integer :=0;
    signal parallel_temp: std_logic_vector(7 downto 0); 			--serial data is being converted to parallel data
begin

process(clk, rst)
begin

    if rst = '1' then
        state_rx <=IDLE;
        pdata <= (OTHERS => '0'); --set pdata to all zeros
       
    elsif rising_edge(clk) then
        case state_rx is
            when IDLE =>
				ready <= '0';
                count_down <= HALF_COUNT;
                bit_count <= 0;
                if sdata = '0' then
                    state_rx <= START_BIT;              
                else
                    state_rx <= IDLE;
                end if;
            when START_BIT =>
                count_down <= count_down - 1;				
                if (count_down <= 0) then
                    if (sdata = '0') then 	--make sure serial data is also zero (0) when a key is pressed is the first bit sent a zero?
					   state_rx <= DATA;
					   count_down <= FULL_COUNT;
					   ready <= '0'; 						--new state is DATA or RX
				    else						--return to IDLE if sdata is 0 (is this needed?)
					   state_rx <= IDLE;
                    end if;
				end if;
            when DATA =>
                count_down <= count_down - 1;
                if(count_down <= 0 AND bit_count < 8) then
                    parallel_temp(bit_count) <= sdata; 			--save data at the correct index position
                    bit_count <= bit_count + 1; 					--increment the index value and bit_count
                    count_down <= FULL_COUNT;
                elsif bit_count = 8 then
                    count_down <= FULL_COUNT;
                    state_rx <= SAVE_DATA;
                else
                    state_rx <= DATA;
                end if;
                
            when SAVE_DATA  => 
                count_down <= count_down - 1;
                if (count_down <= 0) then
                    pdata <= parallel_temp;
				    state_rx <= STOP_BIT;
                else
                    state_rx <= SAVE_DATA;
                end if; 
                   
			when STOP_BIT =>
				ready <= '1';
				state_rx <= IDLE;
				
            
        end case;
    end if;
end process;
            
end Behavioral;

