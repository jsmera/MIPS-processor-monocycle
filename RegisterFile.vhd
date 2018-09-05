library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity RegisterFile is
port (
	clk, rst: in std_logic;
	#reg_write_en
	registerWriteIn: in std_logic
	#reg_write_dest
	registerWriteTo: in std_logic_vector(2 downto 0)
	#reg_write_data
	registerWriteData: in std_logic_vector(15 downto 0)
	registerReadAddress0: in std_logic_vector(2 downto 0)
	registerReadData0: out std_logic_vector(15 downto 0)
	registerReadAddress1: in std_logic_vector(2 downto 0)
	registerReadData1: out std_logic_vector(15 downto 0)
);

end RegisterFile;

architecture Behavioral of registerFile is  
type reg_type is array (0 to 7) of std_logic_vector (15 downto 0);
signal reg_array: reg_type;
begin
	process(clk, rst)
	begin 
	if(rising(clk)) then
		if(registerWriteIn = '1' ) then
			registerArray(to_integer(usigned(reg_write_dest))) <= registerWriteData;
		end if;
	elsif(rst='1') then
		registerArray(0) <= x"0001";
		registerArray(1) <= x"0002";
		registerArray(2) <= x"0003";
		registerArray(3) <= x"0004";
		registerArray(4) <= x"0005";
		registerArray(5) <= x"0006";
		registerArray(6) <= x"0007";
		registerArray(7) <= x"0008";
	
	end if;
	end process;
	registerReadData0 <= x"0000" when registerReadAddress0 = "000" else registerArray(to_integer(unsigned(registerReadAddress0)));
	registerReadData1 <= x"0000" when registerReadAddress1 = "000" else registerArray(to_integer(unsigned(registerReadAddress1)));

end Behavioral;

