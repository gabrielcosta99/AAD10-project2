library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.numeric_std.all;

entity accumulator is
    generic
    (
    ADDR_BITS : integer range 2 to 8 := 4;
    DATA_BITS_LOG2 : integer range 2 to 5 := 3
    );
    port
    (
    clock : in std_logic;
    -- write port
    write_addr : in std_logic_vector(ADDR_BITS-1 downto 0);
    write_inc : in std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
    -- read port
    read_addr : in std_logic_vector(ADDR_BITS-1 downto 0);
    read_data : out std_logic_vector(2**DATA_BITS_LOG2-1 downto 0)
    );
end accumulator;


architecture structural of accumulator is
  signal delayed_write_addr,s_write_addr : std_logic_vector(ADDR_BITS-1 downto 0);
  signal double_delayed_write_inc,delayed_write_inc,value_to_write, s_aux_r_d,s_delayed_value_to_write:  std_logic_vector(2**DATA_BITS_LOG2-1 downto 0) := (others => '0');
  signal s_data12, s_data23,s_adder_n_a: std_logic_vector(2**DATA_BITS_LOG2-1 downto 0) := (others => '0');
  signal s_equal: std_logic := '0';
begin
    my_register_addr: entity work.my_register(behavioral)
                 generic map(N => ADDR_BITS)
                    port map(clock => clock,
                              d     => write_addr,
                              q     => delayed_write_addr);

    my_register_inc:  entity work.my_register(behavioral)
                      generic map(N => 2**DATA_BITS_LOG2)
                         port map(clock => clock,
                                  d     => write_inc,
                                  q     => delayed_write_inc);


    triple_port_ram:  entity work.triple_port_ram(synchronous_new)
                      generic map(ADDR_BITS => ADDR_BITS, DATA_BITS_LOG2 => DATA_BITS_LOG2)
                         port map(clock         => clock,
                                  write_en      => '1',
                                  write_addr    => s_write_addr,
                                  write_data    => value_to_write,
                                  
                                  read_addr     => read_addr,
                                  read_data     => read_data,
                                  aux_read_addr => delayed_write_addr,
                                  aux_read_data => s_data12);

    double_delay_write_inc: entity work.my_register(behavioral)
    generic map(N => 2**DATA_BITS_LOG2)
        port map(clock => clock,
                  d     => delayed_write_inc,
                  q     => double_delayed_write_inc);   


    adder_n:  entity work.adder_n(structural)
    generic map(N => 2**DATA_BITS_LOG2)
        port map(a     => s_adder_n_a,
                b     => double_delayed_write_inc,
                c_in  => '0',
                s     => value_to_write,
                c_out  => open);

    -- delay_data12: entity work.my_register(behavioral)
    -- generic map(N => 2**DATA_BITS_LOG2)
    --    port map(clock => clock,
    --              d     => s_data12,
    --              q     => s_data23);

    comparator: entity work.vector_comparator(behavioral)
    generic map(N => ADDR_BITS)
      port map(vec1 => s_write_addr,
                vec2     => delayed_write_addr,
                equal    => s_equal);             

    multiplex: entity work.multiplexer(behavioral)
    generic map(N => 2**DATA_BITS_LOG2)
       port map( clock => clock,
                 sel => s_equal,
                 a     => s_data12,
                 b    => value_to_write,        -- if s_equal = 1, y = value_to_write
                 y    => s_adder_n_a); 

    delay_writeaddr: entity work.my_register(behavioral)
    generic map(N => ADDR_BITS)
       port map(clock => clock,
                 d     => delayed_write_addr,
                 q     => s_write_addr);


end structural;

