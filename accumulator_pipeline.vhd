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
  signal s_write_addr_stable,s_delayed_write_addr_stable : std_logic_vector(ADDR_BITS-1 downto 0);
  signal s_delayed_write_inc_stable,s_write_inc_stable,s_value_to_write, s_aux_read_data,s_adder_n_a:  std_logic_vector(2**DATA_BITS_LOG2-1 downto 0) := (others => '0');
  signal s_equal: std_logic := '0';
begin

  my_register_addr: entity work.my_register(behavioral)
    generic map (N => ADDR_BITS)
    port map (
        clock => clock,
        d     => write_addr,
        q     => s_write_addr_stable
    );

  -- Triple Port RAM
  triple_port_ram: entity work.triple_port_ram(synchronous_new)
    generic map (
        ADDR_BITS      => ADDR_BITS,
        DATA_BITS_LOG2 => DATA_BITS_LOG2
    )
    port map (
        clock         => clock,
        write_en      => '1',
        write_addr    => s_delayed_write_addr_stable,
        write_data    => s_value_to_write,

        read_addr     => read_addr,
        read_data     => read_data,
        aux_read_addr => s_write_addr_stable,
        aux_read_data => s_aux_read_data
    );

  -- Stabilize "write_inc"
  my_register_inc: entity work.my_register(behavioral)
    generic map (N => 2**DATA_BITS_LOG2)
    port map (
        clock => clock,
        d     => write_inc,
        q     => s_write_inc_stable
    );

  -- Delay the "s_write_inc_stable" so we can increment the value that is stored in the ram in the next clock cycle
  delay_s_write_inc: entity work.my_register(behavioral)
    generic map (N => 2**DATA_BITS_LOG2)
    port map (
        clock => clock,
        d     => s_write_inc_stable,
        q     => s_delayed_write_inc_stable
    );


  adder_n: entity work.adder_n(structural)
    generic map (N => 2**DATA_BITS_LOG2)
    port map (
        a     => s_adder_n_a,
        b     => s_delayed_write_inc_stable,
        c_in  => '0',
        s     => s_value_to_write,
        c_out => open
    );

  -- check if "s_delayed_write_addr_stable" and "s_write_addr_stable" are equal 
  comparator: entity work.vector_comparator(behavioral)
    generic map (N => ADDR_BITS)
    port map (
        vec1  => s_delayed_write_addr_stable,
        vec2  => s_write_addr_stable,
        equal => s_equal
    );

  --  If "s_delayed_write_addr_stable" and "s_write_addr_stable" are equal, we use the value of "s_value_to_write",
  -- instead of the value we read from the "ram"
  multiplex: entity work.multiplexer(behavioral)
    generic map (N => 2**DATA_BITS_LOG2)
    port map (
        clock => clock,
        sel   => s_equal,
        a     => s_aux_read_data,
        b     => s_value_to_write,
        y     => s_adder_n_a
    );

  -- Delay the "s_write_addr_stable" so we can use it when we want to store the new value
  delay_writeaddr: entity work.my_register(behavioral)
    generic map (N => ADDR_BITS)
    port map (
        clock => clock,
        d     => s_write_addr_stable,
        q     => s_delayed_write_addr_stable
    );

end structural;

