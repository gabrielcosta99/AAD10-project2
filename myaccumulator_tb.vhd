library IEEE;
use IEEE.std_logic_1164.all;

entity accumulator_tb is
end accumulator_tb;

architecture stimulus of accumulator_tb is
  constant ADDR_BITS      : positive := 4;
  constant DATA_BITS_LOG2 : positive := 2;
  signal s_clock : std_logic;
  signal s_w_addr : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
  signal s_w_inc  : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
  signal s_r_addr : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
  signal s_r_data : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
begin
  uut : entity work.accumulator(structural)
               generic map(ADDR_BITS => ADDR_BITS,
                          DATA_BITS_LOG2 => DATA_BITS_LOG2)
               port map(clock      => s_clock,
                        write_addr => s_w_addr,
                        write_inc  => s_w_inc,

                        read_addr  => s_r_addr,
                        read_data  => s_r_data);
  clock : process
  begin
    s_clock <= '0';
    wait for 500 ps;
    for cycle in 0 to 10 loop
      wait for 500 ps;
      s_clock <= '1';
      wait for 500 ps;
      s_clock <= '0';
    end loop;
    wait for 500 ps;
    wait;
  end process;
  w_addr_and_inc : process
  begin
    s_w_addr <= "0000"; s_w_inc <= "0000";
    wait for 1480 ps;
    s_w_addr <= X"3"; s_w_inc <= X"2";
    wait for 1000 ps;
    s_w_addr <= X"3"; s_w_inc <= X"7";
    wait for 1000 ps;
    s_w_addr <= X"3"; s_w_inc <= X"4";
    wait for 1000 ps;
    s_w_addr <= X"5"; s_w_inc <= X"F";
    wait for 1000 ps;
    s_w_addr <= X"B"; s_w_inc <= X"2";
    wait for 1000 ps;
    s_w_addr <= X"3"; s_w_inc <= X"A";
    wait for 1000 ps;
    s_w_addr <= X"3"; s_w_inc <= X"0";
    wait for 1000 ps;
    s_w_addr <= X"5"; s_w_inc <= X"4";
    wait for 1000 ps;
    s_w_addr <= X"3"; s_w_inc <= X"5";
    wait for 1000 ps;
    s_w_addr <= X"B"; s_w_inc <= X"D";
    wait for 1000 ps;
    wait;
  end process;
  r_addr : process
  begin
    s_r_addr <= X"0";
    wait for 1480 ps;
    s_r_addr <= X"3";
    wait for 1000 ps;
    s_r_addr <= X"3";
    wait for 1000 ps;
    s_r_addr <= X"3";
    wait for 1000 ps;
    s_r_addr <= X"3";
    wait for 1000 ps;
    s_r_addr <= X"B";
    wait for 1000 ps;
    s_r_addr <= X"5";
    wait for 1000 ps;
    s_r_addr <= X"3";
    wait for 700 ps;
    s_r_addr <= X"B";
    wait for 600 ps;
    s_r_addr <= X"3";
    wait for 700 ps;
    s_r_addr <= X"5";
    wait for 1000 ps;
    s_r_addr <= X"B";
    wait for 1000 ps;
    wait;
  end process;
end stimulus;
