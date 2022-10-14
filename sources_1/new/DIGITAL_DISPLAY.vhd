--standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIGITAL_DISPLAY is
  Port (clk:        in std_logic;
        rst:        in std_logic;
        pdata_in:   in std_logic_vector(7 downto 0);
        led_out:    out std_logic_vector(7 downto 0);
        display_out:out std_logic_vector(6 downto 0);
        enable:     out std_logic_vector(3 downto 0));
end DIGITAL_DISPLAY;

architecture Behavioral of DIGITAL_DISPLAY is
    type STATES is (IDLE, DISP0, DISP1);
    constant FULL_COUNT: integer := 25000;
    signal state_bcd: STATES := IDLE;
    signal count: integer :=0;
    signal buffer_bcd: std_logic_vector(7 downto 0) :=(OTHERS => '0');
    signal pdata_DISP_s: std_logic_vector(3 downto 0);
    
begin

    pdata_DISP_s <= buffer_bcd(3 downto 0) when state_bcd = DISP0 else buffer_bcd(7 downto 4);
    led_out <= pdata_in; --link switches to led lights
    
process(clk,rst)
begin
    if (rst='1') then
        count <= 0;
        state_bcd <= IDLE;
        enable <= "1111"; --all off
    elsif(rising_edge(clk)) then
        buffer_bcd <= pdata_in; --shift to buffer
        case state_bcd is
        
            when IDLE => 
            count <= FULL_COUNT;
            state_bcd <= DISP0;
            
            when DISP0 =>
            enable <= "1110";
            count <= count-1;

            if(count <= 0) then
                state_bcd <= DISP1;
                count <= FULL_COUNT;
            else
                state_bcd <= DISP0;
            end if;
            
            when DISP1 =>
            enable <= "1101";
            count <= count-1;

            if(count <= 0) then
                state_bcd <= DISP0;
                count <= FULL_COUNT;
            else
                state_bcd <= DISP1;
            end if;
            
        end case;
    end if;
end process;

process(pdata_DISP_s)
begin
    case pdata_DISP_s is
        when "0000" => display_out <= "0000001"; -- "0"     
        when "0001" => display_out <= "1001111"; -- "1" 
        when "0010" => display_out <= "0010010"; -- "2" 
        when "0011" => display_out <= "0000110"; -- "3" 
        when "0100" => display_out <= "1001100"; -- "4" 
        when "0101" => display_out <= "0100100"; -- "5" 
        when "0110" => display_out <= "0100000"; -- "6" 
        when "0111" => display_out <= "0001111"; -- "7" 
        when "1000" => display_out <= "0000000"; -- "8"     
        when "1001" => display_out <= "0000100"; -- "9" 
        when "1010" => display_out <= "0000010"; -- a
        when "1011" => display_out <= "1100000"; -- b
        when "1100" => display_out <= "0110001"; -- C
        when "1101" => display_out <= "1000010"; -- d
        when "1110" => display_out <= "0110000"; -- E
        when "1111" => display_out <= "0111000"; -- F
        when OTHERS => display_out <= "0000000";
    end case;
end process; 
end Behavioral;

