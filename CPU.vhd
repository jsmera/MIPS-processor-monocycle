library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CPU is
	port(
		CLK, RESET: in std_logic;
		PC_OUT, ALU_R: out std_logic_vector (31 downto 0)
	);
end CPU;

architecture behavior of CPU is
	signal pc_current: std_logic_vector (31 downto 0);
	signal pc_next, pc_add, pc_jump, pc_branch: std_logic_vector (31 downto 0);
	signal instruction: std_logic_vector (31 downto 0);
	-- Decode
	signal writeRegister: std_logic_vector (4 downto 0);
	signal RegDst, RegWrite, Branch, MemWrite, MemRead, jump, MemtoReg, ALUSrc: std_logic;
	signal ALUOp: std_logic_vector (1 downto 0);
	
	signal extend_final, shiftleft2, addressBranch: std_logic_vector (31 downto 0);
	signal extend: std_logic_vector (15 downto 0);
	
	signal and_1: std_logic;
	-- Register, ALU
	signal A, B, B1, result, final: std_logic_vector(31 downto 0);
	signal zero: std_logic;
	signal ALU_OPERATION: std_logic_vector(3 downto 0);
	-- Data
	signal readData: std_logic_vector(31 downto 0);
	signal jump_signal: std_logic_vector(27 downto 0);
	component IR port (
		pc: in std_logic_vector (31 downto 0);
		instruction: out std_logic_vector (31 downto 0)
	);
	end component;
	
	component RegisterFile port (
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
	
	component adder is
	port (
		a,b: in std_logic_vector(31 downto 0);
		c: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component sign_extend is
	port (
		a: in std_logic_vector(15 downto 0);
		b: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component shift_2 is
	port (
		a: in std_logic_vector(31 downto 0);
		b: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component shift_jump is
	port (
		a: in std_logic_vector(25 downto 0);
		b: out std_logic_vector(27 downto 0)
	);
	end component;
	
	component Control port (
		opcode: in std_logic_vector (5 downto 0);
		RegDst, RegWrite, Branch, MemWrite, MemRead, MemtoReg, jump, ALUSrc: out std_logic;
		ALUOp: out std_logic_vector (1 downto 0)
	);
	end component;
	
	component controlAlu port (
		functions: in std_logic_vector(5 downto 0);
		operationAlu: in std_logic_vector(1 downto 0);
		alu_control: out std_logic_vector(3 downto 0)
	);
	end component;
	
	component alu port (
		A, B : in std_logic_vector (31 downto 0);
		alu_control : in std_logic_vector (3 downto 0);
		zero : out std_logic;
		result : out std_logic_vector (31 downto 0)
	);
	end component;
	

	component Memory port (
		CLK: in std_logic;
		MemWrite: in std_logic;
		MemRead: in std_logic;
		address: in std_logic_vector(31 downto 0);
		writeData: in std_logic_vector(31 downto 0);
		readData: out std_logic_vector(31 downto 0)
	);
	end component;
	
	begin
	--- Fetch
	process(CLK, RESET)
		begin 
			if(RESET = '1') then
				pc_current <= "00000000000000000000000000000000";
			elsif(rising_edge(CLK)) then
				pc_current <= pc_next;
			end if;
	end process;

	Intruction_Memory: IR port map(
		pc => pc_current,
		instruction => instruction
	);

	extend <= instruction(15 downto 0);
	
	UnitControl: Control port map(
		opcode => instruction(31 downto 26),
		RegDst => RegDst,
		RegWrite => RegWrite,
		Branch => Branch,
		MemWrite => MemWrite,
		MemRead => MemRead,
		MemtoReg => MemtoReg,
		ALUSrc => ALUSrc,
		ALUOp => ALUOp,
		jump => jump
	);
	
	-- Mux
	writeRegister <= instruction(15 downto 11) when (RegDst = '1') else instruction(20 downto 16);
	
	-- Sign extend
	EXTEND1: sign_extend port map(
		a => extend,
		b => extend_final
	);
	
	Registers: RegisterFile port map(
		clk => CLK,
		registerWrite => RegWrite,
		registerRead1 => instruction(25 downto 21),
		registerRead2 => instruction(20 downto 16),
		writeRegister => writeRegister,
		registerWriteData => final,
		registerReadData1 => A,
		registerReadData2 => B
	);

	-- Mux
	B1 <= extend_final when (ALUSrc = '1') else B;

	-- ALU
	ALU_INS: alu port map(
		A => A,
		B => B1,
		alu_control => ALU_OPERATION,
		zero => zero,
		result => result
	);

	-- ALU control
	ALUCONTROL: controlAlu port map(
		functions => instruction(5 downto 0),
		operationAlu => ALUOp,
		alu_control => ALU_OPERATION
	);

	RAM:  Memory port map (
		CLK => CLK,
		MemWrite => MemWrite,
		MemRead => MemRead,
		address => result,
		writeData => B,
		readData => readData
	);

	-- Mux 
	final <= readData when (MemtoReg = '1') else result;

	ADD1: adder port map(
		a => pc_current,
		b => "00000000000000000000000000000100",
		c => pc_add
	);
	
	and_1 <= zero and Branch;
	SHIFT2: shift_2 port map(
		a => extend_final,
		b => shiftleft2
	);
	
	addressBranch <= pc_add + shiftleft2;
	-- Mux
	pc_branch  <=	addressBranch when (and_1 = '1') else pc_add;
	
	SHIFT_JUMP1: shift_jump port map(
		a => instruction(25 downto 0),
		b => jump_signal
	);

	pc_jump <= pc_add(31 downto 28) & jump_signal ;
	pc_next <= pc_jump when (jump = '1') else pc_branch;
	PC_OUT <= pc_current;
	ALU_R <= result;
	
end behavior;
