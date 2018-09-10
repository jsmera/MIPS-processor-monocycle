library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Memory is
end tb_Memory;

architecture behavior of tb_Memory is
	signal clk: std_logic := '0';
	signal MemWrite: std_logic := '1';
	signal MemRead: std_logic := '0';
	signal address: std_logic_vector (15 downto 0);
	signal dataIn: std_logic_vector(31 downto 0);
	signal dataOut: std_logic_vector(31 downto 0);
	constant period : time := 10 ns;
	component Memory
		port (
			CLK: in std_logic;
			MemWrite: in std_logic;
			MemRead: in std_logic;
			address: in std_logic_vector(15 downto 0);
			writeData: in std_logic_vector(31 downto 0);
			readData: out std_logic_vector(31 downto 0)
		);
	end component;
	begin
		ram : Memory port map (
			CLK => clk,
			MemWrite => MemWrite,
			MemRead => MemRead,
			address => address,
			writeData => dataIn,
			readData => dataOut
		);

		Clock: process
			begin
				wait for 15 ns;
				clk <= '1';
				wait for 5 ns;
				clk <= '0';
				wait for 20 ns;
				clk <= '1';
		end process Clock;
		Write: process
			begin
				wait for 20 ns;
				MemWrite <= '1';
				wait for 5 ns;
				MemWrite <= '0';
				MemRead <= '1';
		end process Write;
		AddressP: process
			begin
				wait for 20 ns;
				address <= "0000000000000000";
				wait;
		end process AddressP;
		Data: process
			begin
				wait for 20 ns;
				dataIn <= std_logic_vector(to_unsigned(56, dataIn'length));
				wait;
		end process Data;
		
end;