library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_jump is
	port (
		a: in std_logic_vector(25 downto 0);
		b: out std_logic_vector(27 downto 0)
	);
end entity;

architecture beh of shift_jump is
	signal temp: std_logic_vector(27 downto 0);

	begin
	temp <= std_logic_vector(resize(unsigned(a), 28));
	b <= std_logic_vector(shift_left(signed(temp), 2));
end beh;