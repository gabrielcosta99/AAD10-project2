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
  signal s_write_addr_stable : std_logic_vector(ADDR_BITS-1 downto 0);
  signal s_write_inc_stable,s_value_to_write, s_aux_read_data:  std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
begin
    my_register_addr: entity work.my_register(behavioral)
                 generic map(N => ADDR_BITS)
                    port map(clock => clock,
                              d     => write_addr,
                              q     => s_write_addr_stable);

    my_register_inc:  entity work.my_register(behavioral)
                      generic map(N => 2**DATA_BITS_LOG2)
                         port map(clock => clock,
                                  d     => write_inc,
                                  q     => s_write_inc_stable);

    triple_port_ram:  entity work.triple_port_ram(synchronous_new)
                      generic map(ADDR_BITS => ADDR_BITS, DATA_BITS_LOG2 => DATA_BITS_LOG2)
                         port map(clock         => clock,
                                  write_en      => '1',
                                  write_addr    => s_write_addr_stable,
                                  write_data    => s_value_to_write,
                                  
                                  read_addr     => read_addr,
                                  read_data     => read_data,
                                  aux_read_addr => s_write_addr_stable,
                                  aux_read_data => s_aux_read_data);


    adder_n:  entity work.adder_n(structural)
    generic map(N => 2**DATA_BITS_LOG2)
        port map(a     => s_aux_read_data,
                b     => s_write_inc_stable,
                c_in  => '0',
                s     => s_value_to_write,
                c_out  => open);
    
end structural;

