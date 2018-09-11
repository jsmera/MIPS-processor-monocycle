library ieee;
use ieee.std_logic_1164.all;

entity tb_Control is
end tb_Control;

architecture behavior of tb_Control is
	component Control port (
		opcode: in std_logic_vector (5 downto 0);
		RegDst, RegWrite, Branch, MemWrite, MemRead, MemtoReg, ALUSrc: out std_logic;
		ALUOp: out std_logic_vector (1 downto 0)
	);
	end component;
	signal op: std_logic_vector (5 downto 0);
	signal RegDst, RegWrite, Branch, MemWrite, MemRead, MemtoReg, ALUSrc: std_logic;
	signal ALUOp: std_logic_vector (1 downto 0);
	begin
		test_control: Control port map(
			opcode => op,
			RegDst => RegDst,
			RegWrite => RegWrite,
			Branch => Branch,
			MemWrite => MemWrite,
			MemRead => MemRead,
			MemtoReg => MemtoReg,
			ALUSrc => ALUSrc,
			ALUOp => ALUOp
		);
		
		process
			begin
				op <= "000000";
				wait for 10 ns;
				op <= "100011";
				wait for 10 ns;
				op <= "000100";
				wait for 10 ns;
				op <= "101011";
				wait;
		end process;
end behavior;
