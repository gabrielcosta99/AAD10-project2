library IEEE;
use IEEE.std_logic_1164.all;

entity shifter_tb is
end shifter_tb;

architecture stimulus of shifter_tb is
    constant DATA_BITS: integer := 8;  -- Increased to test larger shifts
    -- constant SHIFT_AMOUNT: integer := 3;  -- Test 3-bit shift capability
    signal s_data_in : std_logic_vector(DATA_BITS-1 downto 0);
    signal s_data_out : std_logic_vector(DATA_BITS-1 downto 0);
    signal s_sel : std_logic_vector(2 downto 0);  -- Changed to 3 bits for shift control
begin
    uut : entity work.my_shifter(behavioral)
                generic map (
                    DATA_BITS    => DATA_BITS
                    -- SHIFT_AMOUNT => SHIFT_AMOUNT
                )
                port map (
                    data_in  => s_data_in,
                    data_out => s_data_out,
                    sel      => s_sel
                );

    -- Test different input patterns
    data_in : process
    begin
        -- Test pattern 1: single bit
        s_data_in <= "00000001";
        wait for 100 ps;
        
        -- Test pattern 2: alternating bits
        s_data_in <= "10101010";
        wait for 100 ps;
        
        -- Test pattern 3: all ones
        s_data_in <= "11111111";
        wait for 100 ps;
        
        -- Test pattern 4: random pattern
        s_data_in <= "10110011";
        wait for 100 ps;
        
        wait;
    end process;

    -- Test different shift amounts
    sel : process
    begin
        -- No shift
        s_sel <= "000";
        wait for 25 ps;
        
        -- 1-bit shift
        s_sel <= "001";
        wait for 25 ps;
        
        -- 2-bit shift
        s_sel <= "010";
        wait for 25 ps;
        
        -- 3-bit shift
        s_sel <= "011";
        wait for 25 ps;
        
        -- 4-bit shift
        s_sel <= "100";
        wait for 25 ps;
        
        -- Maximum shift
        s_sel <= "111";
        wait for 25 ps;
        
        wait;
    end process;
end stimulus;