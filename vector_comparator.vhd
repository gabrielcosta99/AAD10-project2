library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vector_comparator is
    generic
    (
        N : integer range 2 to 16
    );
    Port (
        vec1 : in std_logic_vector(N-1 downto 0);
        vec2 : in std_logic_vector(N-1 downto 0);
        equal : out std_logic
    );
end vector_comparator;

architecture behavioral of vector_comparator is
begin
    process(vec1, vec2)
    begin
        if vec1 = vec2 then
            equal <= '1';  -- Vectors are equal
        else
            equal <= '0';  -- Vectors are not equal
        end if;
    end process;
end behavioral;
