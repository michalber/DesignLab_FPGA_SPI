--/////////////////////////////////////////////////////////////////////////
--	AGH, Design Lab
--	Micha³ Berdzik, Elektronika/Electronics III year
--/////////////////////////////////////////////////////////////////////////
-- Create Date: 27.11.2018 15:55:10
-- Design Name: DesignLab_SPI
-- Module Name: spi_slave
-- Project Name: DesignLab_SPI 
-- Target Devices: Zybo 
-- Tool Versions: 
-- Description:		   
--////////////////////////////////////////////////////////////////////////////////

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity spi_slave is
	port(
--		CLK: in std_logic; -- system clock
		RST: in std_logic; -- synchronous reset - high active 
		-- spi slave interface
		SCLK: in std_logic; -- spi clock from MyRIO
		MOSI: in std_logic; -- master-in-slave-out
		MISO: out std_logic; -- master-out-slave-in
		CS: in std_logic; -- chip select - low active			 
		-- user interface	 
		DIN: in  std_logic_vector(15 downto 0); -- 4bit input data for SPI master	
--		DOUT: out  std_logic_vector(15 downto 0); -- 16bit output data for SPI master		  
		LOAD: in std_logic
	);
end spi_slave;		 

architecture spi_slave of spi_slave is	  	 

---------------------- signal registers ---------------------------------
	signal bit_cnt            	: std_logic_vector(3 downto 0) := "0000";
	signal data_shreg         	: std_logic_vector(15 downto 0) := x"0000";   
	signal data_pending			: std_logic_vector(15 downto 0) := x"0000";  
----------------------- signal flags ----------------------------------      
    signal load_data_flag     	: std_logic := '0';    
	signal bit_cnt_max_flag     : std_logic := '0';  					 	
	signal data_available		: std_logic := '0';
--	signal done_flag		  	: std_logic := '0';
--	signal slave_ready        	: std_logic := '0'; 
--------------------------------------------------------------------------    

begin			   
	-- -------------------------------------------------------------------------
    --  spi slave data loading to data buffer
    -- -------------------------------------------------------------------------
	clk_process : process (SCLK)	  
	begin		   		   
		if (falling_edge(SCLK)) then
		    if(RST = '1') then
		        -- reset all data and flags
		        data_pending <= (others=>'0');
                data_available <= '0';  
			else
			     if(LOAD = '1') then
				    data_pending <= DIN;    -- load new data to data buffer
				    data_available <= '1';  -- set flag that indicate that new data is available
			     elsif(LOAD = '0' and bit_cnt = 1) then
			        data_available <= '0';   -- reset flag when LOAD is 0 and counter is 1
			     end if;          
			end if;
  	    end if;
	end process;	
	
	-- load data flag to indicate that data should be loaded to slave MISO
	load_data_flag <= '1' when (data_available = '1' and bit_cnt_max_flag='1') else '0';
	
		
	-- -----------------------	--------------------------------------------------
    --  spi slave 4bit counter 
    -- -------------------------------------------------------------------------    
	bit_cnt_process : process (CLK)	
	begin
		if (falling_edge(SCLK)) then
		    if(RST = '1') then
		        bit_cnt <= (others => '0');		       
			else
			     if bit_cnt < 15 then
				    bit_cnt <= bit_cnt+1;			
			     else
				    bit_cnt <= "0000";
				 end if;				
			end if;
		end if;	
	end process;
	
    -- The flag of maximal value of the bit counter.
    bit_cnt_max_flag <= '1' when (bit_cnt = "1111") else '0';  		
		
    -- -------------------------------------------------------------------------
    --  MOSI Register - Receiving data / Loading data to shift register
    -- -------------------------------------------------------------------------
    -- The shift register holds data for sending to master, capture and store
    -- incoming data from master or from external load
    data_shreg_p : process (CLK)
    begin
        if (falling_edge(SCLK)) then
            if(RST = '1') then
                data_shreg <= (others => '0');                
            else
                if (load_data_flag = '1') then
                    data_shreg <= data_pending;
                elsif (CS = '0') then							
                    data_shreg <= data_shreg(14 downto 0) & MOSI;
                end if; 								
            end if;			
        end if;
    end process;

    -- -------------------------------------------------------------------------
    --  MISO Register - Sending Data
    -- -------------------------------------------------------------------------
    miso_p : process (CLK)
    begin
        if (falling_edge(SCLK)) then
            if(RST = '1') then
                MISO <= '0';
            elsif(CS = '0') then			
                MISO <= data_shreg(15);				
            end if;
        end if;
    end process;

end spi_slave;



--temat: komunikacja myrio - zybo spi
---opis sprzetu
---opis SPI
--opis, konfiguracja, kod
---jakie sygna³y, czestotliwosci, bity
---konfuuracja master
---testy z czujnikiem
---zybo
--zapis, odczyt, konfiguracja, kod + testbench

--ca³y kod jako za³¹cznik