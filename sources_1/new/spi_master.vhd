--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_master is
    -- spi_clk_f is limited to 30 MHz for DA2
    generic(m_clk_f :   in integer := 100e6;
            spi_clk_f : in integer := 10e6);
            
    port(clk :      in std_logic; -- clock input
         rst :      in std_logic; -- reset, active high
         load :     in std_logic; -- notification to send data
         data_in :  in std_logic_vector(15 downto 0); -- pdata in
         sdata_0 :  out std_logic; -- serial data out 1
         sdata_1 :  out std_logic; -- serial data out 2
         spi_clk :  out std_logic; -- clk out to SPI devices
         CS0_n :    out std_logic); -- chip select 1, active low
end spi_master;

architecture Behavioral of spi_master is
    type STATES is (IDLE, CLK_L, CLK_H);
    constant SPI_COUNT: integer := (m_clk_f/spi_clk_f)/2;
    signal state_spi: STATES := IDLE;
    signal count: integer :=0; --used for counting
    signal buffer_spi: std_logic_vector(15 downto 0);
    signal bit_idx: integer := 0;
    signal spi_clk_s: std_logic;
    
begin
    spi_clk_s <= '0' when state_spi = CLK_L else '1'; --bring spi_clk out of process
    spi_clk <= spi_clk_s;

process(clk, rst)
begin
    if rst = '1' then
		state_spi <= IDLE;
		buffer_spi <= (OTHERS => '0');
	elsif rising_edge(clk) then 
        case state_spi is 
            when IDLE =>
                count <= SPI_COUNT;
                if load = '1' then
                    buffer_spi <= data_in;
                    state_spi <= CLK_L;
			    else
					state_spi <= IDLE;
				end if;
				
            when CLK_L =>
                count <= count - 1;
                --spi_clk <= '0';
                if (count <= 1) then
                    state_spi <= CLK_H;
                    count <= SPI_COUNT;
                else
                    state_spi <= CLK_L;
                end if;
                
            when CLK_H => 
                count <= count - 1;
                --spi_clk <= '1';
                if (count <= 1) then
                    state_spi <= CLK_L;
                    count <= SPI_COUNT;
                else
                    state_spi <= CLK_H;
                end if;
		end case;
    end if;
end process;

process(spi_clk_s, rst)
begin
    if rst = '1' then
        bit_idx <= 0;
    elsif rising_edge(spi_clk_s) then
        bit_idx <= bit_idx + 1;
    end if;
end process;

end Behavioral;

