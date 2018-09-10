library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RegisterFile is
end tb_RegisterFile;

architecture behavioral of tb_RegisterFile is 
	signal clk: std_logic := '0';
	signal regWrite: std_logic := '1';
	signal regRead1: std_logic_vector(4 downto 0);
	signal regRead2: std_logic_vector(4 downto 0);
	signal writeReg: std_logic_vector(4 downto 0);
	signal regWriteData: std_logic_vector(31 downto 0);
	signal regReadData1: std_logic_vector(31 downto 0);
	signal regReadData2: std_logic_vector(31 downto 0); 
	constant period : time := 10 ns;
	component RegisterFile 
		port (
			clk: in std_logic;
			registerWrite: in std_logic;
			registerRead1: in std_logic_vector(4 downto 0);
			registerRead2: in std_logic_vector(4 downto 0);
			writeRegister: in std_logic_vector(4 downto 0);
			registerWriteData: in std_logic_vector(31 downto 0);
			registerReadData1: out std_logic_vector(31 downto 0);
			registerReadData2: out std_logic_vector(31 downto 0)
			);
	end component;
	begin
		reg : RegisterFile port map(
			clk => clk,
			registerWrite => regWrite,
			registerRead1 => regRead1,
			registerRead2 => regRead2,
			writeRegister => writeReg,
			registerWriteData => regWriteData, 
			registerReadData1 => regReadData1,
			registerReadData2 => regReadData1
		);
		
		Clock: process
			begin
				wait for 15 ns;
				clk <= '1';
				wait for 20 ns;
				clk <= '0';
				wait for 20 ns;
				clk <= '1';
				wait;
		end process Clock;
		
		Write1: process
			begin	
				wait for 20 ns;
				regWrite <= '1';
				wait for 20 ns;
				regWrite <= '0';
				wait;
		end process Write1;
		
		Addres: process
			begin
				wait for 20 ns;
				writeReg <= "00010";
				wait for 20 ns;
				regReadData1 <= (others => '0');
				regReadData1(4 downto 0) <= writeReg;
				wait;
		end process Addres;
		
		Data: process
			begin
				wait for 20 ns;
				regWriteData <= std_logic_vector(to_unsigned(27, regWriteData'length));
				wait;
		end process Data;
end behavioral;