library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity alu is
	Port (
		A,B : in STD_LOGIC_VECTOR (31 downto 0);
		alu_control : in STD_LOGIC_VECTOR (3 downto 0);
		zero : out STD_LOGIC;
		result : out STD_LOGIC_VECTOR (31 downto 0));
	end alu;

	architecture behavioral of alu is
		begin
			result <= A + B when alu_control="0010" else
							A - B when (alu_control="0110" or alu_control="0011") else
							A and B when alu_control="0000" else
							A or B when alu_control="0001" else
							"00000000000000000000000000000001" when (alu_control="0111" and A < B) else
							"00000000000000000000000000000000" when alu_control="0111";
			zero <= '1' when (A/=B and alu_control="0011") else
						'0' when(A=B and alu_control="0011") else
						'1' when A=B else
						'0';
	end behavioral;