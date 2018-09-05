library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IO is
  port(
    CLK: in std_logic;
    MemWrite: in std_logic;
    MemRead: in std_logic;
    address: in std_logic_vector(15 downto 0);
    writeData: in std_logic_vector(31 downto 0);
    readData: out std_logic_vector(31 downto 0);
  );
end IO;

architecture Memory is IO
  type data_ram is array (0 to 255) of std_logic_vector (15 downto 0);
  signal ram : data_ram := ((i => (i => '0')));

  begin
    process(CLK) is
      begin
      if rising_edge(CLK) then
        if MemWrite = '1' then
          ram(to_integer(unsigned(address))) <= writeData
        end if;
      end if;

      if MemRead = '1' then
        readData <= ram(to_integer(unsigned(address)))
      else then
        readData <= "00000000000000000000000000000000";
      end if;
    end process;
end Memory;
