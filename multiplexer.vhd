library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity multiplexer is
    generic
    (
        N : integer range 2 to 16
    );
    port (
        clock : in std_logic;
        a : in std_logic_vector(N-1 downto 0);  -- Input 1
        b : in std_logic_vector(N-1 downto 0);  -- Input 2
        sel : in std_logic;  -- Select line
        y : out std_logic_vector(N-1 downto 0) := (others => '0')  -- Output
    );
end multiplexer;

architecture behavioral of multiplexer is
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if sel = '0' then
                y <= a;  -- Pass input 'a' to output when sel is '0'
            else
                y <= b;  -- Pass input 'b' to output when sel is '1'
            end if;
        end if;
    end process;
end behavioral;
