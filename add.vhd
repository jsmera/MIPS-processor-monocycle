library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.ALL;

entity adder is
	port (
		a,b: in std_logic_vector(31 downto 0);
		c: out std_logic_vector(31 downto 0)
	);
end entity;

architecture behavior of adder is
	begin
	c <= a+b;
end behavior;