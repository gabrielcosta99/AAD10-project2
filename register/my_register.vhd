library IEEE;
use IEEE.std_logic_1164.all;

entity my_register is
  generic(N : integer range 2 to 32 := 4);
  port(
        clock : in  std_logic;
        d     : in  std_logic_vector(N-1 downto 0);
        q     : out std_logic_vector(N-1 downto 0):=(others => '0')
      );
end my_register;

architecture behavioral of my_register is
begin
  process(clock) is
  begin
    if rising_edge(clock) then
      q <= transport d after 10 ps;
    end if;
  end process;
end behavioral;
