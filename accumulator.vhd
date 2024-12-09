library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

entity accumulator is
    generic
    (
    ADDR_BITS : integer range 2 to 8 := 4;
    DATA_BITS : integer range 4 to 32 := 8
    );
    port
    (
    clock : in std_logic;
    -- write port
    write_addr : in std_logic_vector(ADDR_BITS-1 downto 0);
    write_inc : in std_logic_vector(DATA_BITS-1 downto 0);
    -- read port
    read_addr : in std_logic_vector(ADDR_BITS-1 downto 0);
    read_data : out std_logic_vector(DATA_BITS-1 downto 0)
    );
end accumulator;


architecture structural of accumulator is
  signal delayed_write_addr : std_logic_vector(ADDR_BITS-1 downto 0);
  signal delayed_write_inc,value_to_write, s_aux_r_d:  std_logic_vector(DATA_BITS-1 downto 0);
begin
    my_register_addr: entity work.my_register(behavioral)
                 generic map(N => ADDR_BITS)
                    port map(clock => clock,
                              d     => write_addr,
                              q     => delayed_write_addr);

    -- my_register_addr2: entity work.my_register(behavioral)
    --                    generic map(N => ADDR_BITS)
    --                       port map(clock => clock,
    --                                d     => delayed_write_addr,
    --                                q     => delayed_write_addr2);

    my_register_inc:  entity work.my_register(behavioral)
                      generic map(N => ADDR_BITS)
                         port map(clock => clock,
                                  d     => write_inc,
                                  q     => delayed_write_inc);



  --     process(clock)
  -- begin
  --   if rising_edge(clock) then
  --     if write_inc_changed = '1' then
  --       -- adder_n executes and value_to_write gets updated
  --       value_to_write <= value_to_write; -- Signal propagation depends on this
  --     else
  --       value_to_write <= value_to_write; -- Optional: Hold previous value
  --     end if;
  --   end if;
  -- end process;
    triple_port_ram:  entity work.triple_port_ram(synchronous_new)
                      generic map(ADDR_BITS => ADDR_BITS, DATA_BITS => DATA_BITS)
                         port map(clock         => clock,
                                  write_en      => '1',
                                  write_addr    => delayed_write_addr,
                                  write_data    => value_to_write,
                                  
                                  read_addr     => read_addr,
                                  read_data     => read_data,
                                  aux_read_addr => delayed_write_addr,
                                  aux_read_data => s_aux_r_d);


    adder_n:  entity work.adder_n(structural)
    generic map(N => DATA_BITS)
        port map(a     => s_aux_r_d,
                b     => delayed_write_inc,
                c_in  => '0',
                s     => value_to_write,
                c_out  => open);
    
    -- process(value_to_write) is
    -- begin
    --   if(delayed_write_inc = write_inc) then
    --     value_to_write <= s_aux_r_d;
    --   end if;
    -- end process;
    -- delayed_write_inc <= (others => '0');

  -- process(value_to_write) is
  -- begin
  --   value_to_write <= (others => '0');
  -- end process;
end structural;

