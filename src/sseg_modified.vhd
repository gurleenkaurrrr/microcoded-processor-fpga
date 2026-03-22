library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sseg_modified is
    port(
        EvenOdd  : in  std_logic;                 -- 1 = YES → “Y”, 0 = NO → “n”
        leds  : out std_logic_vector(0 to 6)
    );
end entity;

architecture Behavioral of sseg_modified is
begin
    process(EvenOdd)
    begin
        if EvenOdd = '1' then
            leds <= "1000100";   -- Y (active‑low)
        else
            leds <= "0001001";   -- n (active‑low)
        end if;
    end process;
end architecture;
