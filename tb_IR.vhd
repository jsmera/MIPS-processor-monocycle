library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_IR is
end tb_IR;

architecture behavior of tb_IR is
	signal PC: std_logic_vector (31 downto 0) := (others => '0');
	signal instruction: std_logic_vector (31 downto 0);
	component IR port(
		pc: in std_logic_vector (31 downto 0);
		instruction: out std_logic_vector (31 downto 0)
	);
	end component;
	begin
	instruction_memory: IR port map (
		pc => PC,
		instruction => instruction
	);
	
	process
		begin
			for i in 1 to 15 loop
				PC <= PC + "00000000000000000000000000000100";
				wait for 10 ns;
			end loop;
	end process;
end behavior;
