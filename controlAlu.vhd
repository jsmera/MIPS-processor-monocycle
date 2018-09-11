library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity controlAlu is
port (
	functions: in std_logic_vector(5 downto 0);
	operationAlu: in std_logic_vector(1 downto 0);
	alu_control: out std_logic_vector(3 downto 0)
);
end controlAlu;

architecture behavioral of controlAlu is  
	begin
	---add
	alu_control <= "0010" when (operationAlu="00" or (operationAlu="10" and functions="100000")) else
					"0110" when(operationAlu="01" or (operationAlu="10" and functions="100010")) else
					"0011" when(operationAlu="11")else
					"0000" when(operationAlu="10" and functions="100100") else
					"0001" when(operationAlu="10" and functions="100101") else
					"0111" when(operationAlu="10" and functions="101010") else
					"0000";
end behavioral;

