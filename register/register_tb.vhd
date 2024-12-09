library IEEE;
use IEEE.std_logic_1164.all;

entity register_tb is
end register_tb;

architecture stimulus of register_tb is
  constant ADDR_BITS: integer := 4;
  signal s_clock : std_logic;
  signal s_d,s_q : std_logic_vector(ADDR_BITS-1 downto 0);
begin
  uut : entity work.my_register(behavioral)
               port map(clock => s_clock,
                        d     => s_d,
                        q     => s_q);
  clock : process
  begin
    s_clock <= '0';
    wait for 50 ps;
    for cycle in 0 to 8 loop
      wait for 50 ps;
      s_clock <= '1';
      wait for 50 ps;
      s_clock <= '0';
    end loop;
    wait for 50 ps;
    wait;
  end process;
  d : process
  begin
    s_d <= "UUUU";
    wait for 150 ps;
    s_d <= "1111";
    wait for 300 ps;
    s_d <= "0000";
    wait for 100 ps;
    s_d <= "1100";
    wait for 100 ps;
    s_d <= "UUUU";
    wait for 100 ps;
    s_d <= "0101";
    wait;
  end process;
end stimulus;
