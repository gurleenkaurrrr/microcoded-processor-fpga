library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_GPU is
    port( 
        Clock : in std_logic;
        Reset : in std_logic; -- ACTIVE LOW RESET
        A, B : in unsigned(7 downto 0);
        OP : in unsigned(15 downto 0);
        Neg: out std_logic;
        R1 : out unsigned(3 downto 0);
        R2 : out unsigned(3 downto 0)
    );
end ALU_GPU;

architecture calculation of ALU_GPU is
    signal Reg1, Reg2, Result : unsigned(7 downto 0) := (others => '0');
begin
				Reg1 <= A;
				Reg2 <= B;


    process(Clock, OP, reset)
    begin
        if Reset = '0' then
            -- ACTIVE-LOW RESET BEHAVIOR
            Result <= (others => '0');
            Neg <= '0';

        elsif rising_edge(Clock) then
		      
				
            Neg <= '0'; -- default
            
            case OP is

                WHEN "0000000000000001" => -- ADD
                    Result <= Reg1 + Reg2;

                WHEN "0000000000000010" => -- SUB
                    if Reg1 >= Reg2 then
                        Result <= Reg1 - Reg2;
                        Neg <= '0';
                    else
                        Result <= Reg2 - Reg1;
                        Neg <= '1';
                    end if;

                WHEN "0000000000000100" => -- NOT A
                    Result <= not Reg1;

                WHEN "0000000000001000" => -- NAND
                    Result <= not (Reg1 and Reg2);

                WHEN "0000000000010000" => -- NOR
                    Result <= not (Reg1 or Reg2);

                WHEN "0000000000100000" => -- AND
                    Result <= Reg1 and Reg2;

                WHEN "0000000001000000" => -- OR
                    Result <= Reg1 or Reg2;

                WHEN "0000000010000000" => -- XOR
                    Result <= Reg1 xor Reg2;

                WHEN "0000000100000000" => -- XNOR
                    Result <= Reg1 xnor Reg2;

                WHEN OTHERS =>
                    Result <= "11111111";

            end case;
        end if;
    end process;

    R1 <= Result(3 downto 0);
    R2 <= Result(7 downto 4);

end calculation;
