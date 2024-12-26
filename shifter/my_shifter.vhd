-- filepath: /home/weza/Documents/UA/Year-1/S-1/AAD/AAD10-project2/shifter/my_shifter.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity my_shifter is
    generic (
        DATA_BITS : integer := 8  -- Data DATA_BITS
    );
    port (
        data_in  : in  std_logic_vector(DATA_BITS-1 downto 0);
        sel    : in  std_logic_vector(2 downto 0);  -- Max 8-bit sel
        data_out : out std_logic_vector(DATA_BITS-1 downto 0)
    );
end my_shifter;

architecture behavioral of my_shifter is
    signal stage1, stage2, stage3 : std_logic_vector(DATA_BITS-1 downto 0);
begin
    -- Stage 1: 1-bit sel
    stage1 <= data_in(DATA_BITS-2 downto 0) & '0' when sel(0) = '1' else data_in;
    
    -- Stage 2: 2-bit sel
    stage2 <= stage1(DATA_BITS-3 downto 0) & "00" when sel(1) = '1' else stage1;
    
    -- Stage 3: 4-bit sel
    stage3 <= stage2(DATA_BITS-5 downto 0) & "0000" when sel(2) = '1' else stage2;
    
    -- Output assignment
    data_out <= stage3;
end behavioral;