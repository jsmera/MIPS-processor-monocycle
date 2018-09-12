library ieee;
use ieee.std_logic_1164.all;

entity Control is
	port(
		opcode: in std_logic_vector (5 downto 0);
		RegDst, RegWrite, Branch, MemWrite, MemRead, MemtoReg, jump, ALUSrc: out std_logic;
		ALUOp: out std_logic_vector (1 downto 0)
	);
end Control;

architecture behavior of Control is
	begin
		aluOp <= "10" when (opcode = "000000") else
					"01" when (opcode = "000100") else
					"00";
		RegDst <= '1' when (opcode = "000000") else
					 '0' when (opcode = "100011") else
					 'X';
		ALUSrc <= '0' when (opcode = "000000" or opcode = "000100") else
					 '1' when (opcode = "100011" or opcode = "101011");
		MemtoReg <= '0' when (opcode = "000000") else
						'1' when (opcode = "100011") else
						'X';
		RegWrite <= '1' when (opcode = "000000" or opcode = "100011") else
		            '0';
		MemRead <= '0' when (opcode = "000000" or opcode = "101011" or opcode = "000100" or opcode = "000010") else
					  '1' when (opcode = "100011") else
					  'X';
		MemWrite <= '0' when (opcode = "000000" or opcode = "100011" or opcode = "000100" or opcode = "000010") else
						'1' when (opcode = "101011") else
						'X';
		Branch <= '0' when (opcode = "000000" or opcode = "100011" or opcode = "101011") else
					 '1';
		jump <= '1' when (opcode = "000010") else '0';
end behavior;
