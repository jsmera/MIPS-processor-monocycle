library ieee;
use ieee.std_logic.all;

entity CPU is
	port(
		CLK, RESET: in std_logic;
		PC_OUT, ALU_R: out std_logic_vector (31 downto 0);
	);
end CPU;

architecture behavior of CPU is
	signal pc_current: std_logic_vector (31 downto 0);
	-- signal pc_next: std_logic_vector (31 downto 0); -- Ver si es necesario
	signal instruction: std_logic_vector (31 downto 0);
	-- Decode
	signal writeRegister: std_logic_vector (4 downto 0);
	signal RegDst, RegWrite, Branch, MemWrite, MemRead, MemtoReg, ALUSrc: std_logic;
	signal ALUOp: std_logic_vector (1 downto 0);
	-- Register
	signal A, B: std_logic_vector(31 downto 0);
	component IR port (
		pc: in std_logic_vector (31 downto 0);
		instruction: out std_logic_vector (31 downto 0)
	);
	end IR;
	
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
	end RegisterFile;
	
	component Control port (
		opcode: in std_logic_vector (5 downto 0);
		RegDst, RegWrite, Branch, MemWrite, MemRead, MemtoReg, ALUSrc: out std_logic;
		ALUOp: out std_logic_vector (1 downto 0)
	);
	end component;
	
	begin
	--- Fetch
	process(CLK)
		begin 
			if(RESET = '1') then
				pc_current <= x"0000";
			elsif(rising_edge(CLK)) then
				pc_current <= pc_next;
			end if;
	end process;

	Intruction_Memory: IR port map(
		pc => pc_current,
		instruction => instruction
	);
	
	UnitControl: Control port map(
		clk => CLK,
		opcode => instruction(31 downto 26),
		RegDst => RegDst,
		RegWrite => RegWrite,
		Branch => Branch,
		MemWrite => MemWrite,
		MemRead => MemRead,
		MemtoReg => MemtoReg,
		ALUSrc => ALUSrc,
		ALUOp => ALUOp
	);
	
	-- Mux
	writeRegister <= instruction(20 downto 16) when (RegDst = '1') else instruction(15 downto 11);
	
	Registers: RegisterFile port map(
		clk => CLK,
		registerWrite => RegWrite,
		registerRead1 => instruction(25 downto 21),
		registerRead2 => instruction(20 downto 16),
		writeRegister => writeRegister,
		registerWriteData => , -- ALU result
		registerReadData1 => A,
		registerReadData2 => B
	);
end behavior;
