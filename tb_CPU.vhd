library ieee;
use ieee.std_logic_1164.all;

entity tb_CPU is
end entity;

architecture behavior of tb_CPU is
	signal CLK, RESET: std_logic := '0';
	signal PC_OUT, ALU_R: std_logic_vector (31 downto 0);
	constant clk_period : time := 10 ns;
	component CPU port (
		CLK, RESET: in std_logic;
		PC_OUT, ALU_R: out std_logic_vector (31 downto 0)
	);
	end component;
	begin
	main: CPU port map(
		CLK => CLK,
		RESET => RESET,
		PC_OUT => PC_OUT,
		ALU_R => ALU_R
	);
	
	clk_process: process
		begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
			clk <= '0';
			wait for clk_period/2;
			wait;
	end process;
	-- Stimulus process
	stim_proc: process
	begin  	
		reset <= '1';
		wait for clk_period;
		reset <= '0';
		wait;
	end process;
	
end behavior;
