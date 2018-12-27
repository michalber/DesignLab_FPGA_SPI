--/////////////////////////////////////////////////////////////////////////
--	AGH, Design Lab
--	Micha? Berdzik, Elektronika III rok
--/////////////////////////////////////////////////////////////////////////
-- Create Date: 27.11.2018 12:11:06
-- Design Name: 
-- Module Name: spi_slave_TB
-- Project Name: DesignLab_SPI 
-- Target Devices: Zybo 
-- Tool Versions: 
-- Description:		   
--////////////////////////////////////////////////////////////////////////////////


library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity spi_slave_tb is
end spi_slave_tb;

architecture TB_ARCHITECTURE of spi_slave_tb is
	-- Component declaration of the tested unit
	component spi_slave
	port(
		RST: in std_logic; -- synchronous reset - high active 
		-- spi slave interface
		SCLK: in std_logic; -- spi clock from MyRIO
		MOSI: in std_logic; -- master-in-slave-out
		MISO: out std_logic; -- master-out-slave-in
		CS: in std_logic; -- chip select - low active			 
		-- user interface	 
		DIN: in  std_logic_vector(15 downto 0); -- 16bit input data for SPI master		  
		LOAD: in std_logic
		);	
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal RST : std_logic := '0';
	signal SCLK : std_logic := '0';
	signal MOSI : std_logic;
	signal MISO : std_logic;
	signal CS : std_logic := '0';	 
	signal DIN: std_logic_vector(15 downto 0) := (others => '0');	 
--	signal DOUT: std_logic_vector(15 downto 0);
	signal LOAD: std_logic := '0'; 
	
begin

	-- Unit Under Test port map
	UUT : spi_slave
		port map (	
			RST => RST,
			SCLK => SCLK,
			MOSI => MOSI,
			MISO => MISO,
			CS => CS,	 
			DIN => DIN,
			LOAD => LOAD
		);

-- SCLK stimulus -------------------------------------------------------------------------------- 
SCLK <= not SCLK after 50ns;
-- ----------------------------------------------------------------------------------------------
LOAD_P : process
begin
	LOAD <= '0';
	wait for 2800ns;
	LOAD <= '1';
	wait for 100ns;
	LOAD <= '0';
	wait;
end process;		
-- ----------------------------------------------------------------------------------------------
DIN_P : process
begin
	DIN <= b"0111_0101_0011_0001";
	wait;
end process;	
-- ----------------------------------------------------------------------------------------------
RST_P : process
begin
	RST <= '0';
	wait;
end process;	
-- ----------------------------------------------------------------------------------------------
CS_P : process
begin
	CS <= '0';
	wait;
end process;
-- ----------------------------------------------------------------------------------------------
MOSI_DATA_P : process
begin			   
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '0';
	wait for 100 ns; 
	MOSI <= '1';
	wait for 100 ns; 
	MOSI <= '1';
	wait for 100 ns; 
	MOSI <= '1';
	wait for 100 ns; 
	MOSI <= '1';
	wait for 100 ns; 
	MOSI <= '1';
	wait for 100 ns; 
	MOSI <= '1';
	wait for 100 ns;
end process;
-- ----------------------------------------------------------------------------------------------

end TB_ARCHITECTURE;