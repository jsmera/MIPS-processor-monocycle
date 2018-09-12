library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Memory is
  port(
    CLK: in std_logic;
    MemWrite: in std_logic;
    MemRead: in std_logic;
    address: in std_logic_vector(31 downto 0);
    writeData: in std_logic_vector(31 downto 0);
    readData: out std_logic_vector(31 downto 0)
  );
end Memory;

architecture behavior of Memory is
  type data_ram is array (0 to 31) of std_logic_vector (31 downto 0);
  signal ram : data_ram := ((others => (others => '0')));
  constant IDK: std_logic_vector(31 downto 0) := (others => '0');
  begin
    process(CLK) is
      begin
      if rising_edge(CLK) then
        if MemWrite = '1' then
          ram(conv_integer(address(6 downto 2))) <= writeData;
        end if;
      end if;
    end process;
    readData <= ram(conv_integer(address(6 downto 2))) when (MemRead = '1') else IDK;
end behavior;
