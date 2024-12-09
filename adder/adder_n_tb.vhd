library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder_n_tb is
end adder_n_tb;

architecture stimulus of adder_n_tb is
  constant N : integer := 4;
  signal s_a,s_b,s_s : std_logic_vector(N-1 downto 0);
  signal s_c_in : std_logic;
  -- signal s_c_out : std_logic;
begin
  uut : entity work.adder_n(structural)
               generic map(N => N)
               port map(a     => s_a,
                        b     => s_b,
                        s     => s_s,
                        -- c_out => s_c_out,
                        c_in  => s_c_in);
  process
  begin
    s_a <= (others => '0');
    s_b <= (N-1 => '0',others => '1');
    s_c_in <= '0';
    wait for 500 ps;
    for cycle in 0 to 2**N-1 loop
      s_c_in <= '1';
      wait for 500 ps;
      s_a <= std_logic_vector(unsigned(s_a)+3);
      s_b <= std_logic_vector(unsigned(s_b)-1);
      s_c_in <= '0';
      wait for 500 ps;
    end loop;
    wait;
  end process;
end stimulus;
