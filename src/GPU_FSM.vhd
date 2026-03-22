library ieee;
use ieee.std_logic_1164.all;

entity GPU_FSM is
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;   -- active low reset
        student_id    : out std_logic_vector(3 downto 0);
        current_state : out std_logic_vector(3 downto 0)
    );
end GPU_FSM;

architecture fsm of GPU_FSM is

    -- 9-state type
    type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
    signal yfsm : state_type;

begin

    --------------------------------------------------------------------
    -- SINGLE CLOCKED PROCESS (state transitions + Moore outputs)
    --------------------------------------------------------------------
    process (clk, reset)
    begin
        if reset = '0' then
            --------------------------------------------------------------
            -- RESET VALUES
            --------------------------------------------------------------
            yfsm <= s0;
            current_state <= "0000";    -- state 0
            student_id    <= "0101";    -- 5

        elsif rising_edge(clk) then

            --------------------------------------------------------------
            -- NEXT STATE LOGIC
            --------------------------------------------------------------
            case yfsm is
                when s0 => yfsm <= s1;
					 when s1 => yfsm <= s2;
					 when s2 => yfsm <= s3;
					 when s3 => yfsm <= s4;
					 when s4 => yfsm <= s5;
					 when s5 => yfsm <= s6;
					 when s6 => yfsm <= s7;
					 when s7 => yfsm <= s8;
					 when s8 => yfsm <= s0;
                when others => yfsm <= s0;
            end case;

            --------------------------------------------------------------
            -- MOORE OUTPUTS (updated on SAME rising edge as state change)
            --------------------------------------------------------------
            case yfsm is

                when s0 =>
                    current_state <= "0000";  -- 0
                    student_id    <= "0101";  -- 5

                when s1 =>
                    current_state <= "0001";  -- 8
                    student_id    <= "0000";  -- 0

                when s2 =>
                    current_state <= "0010";  -- 6
                    student_id    <= "0001";  -- 1

                when s3 =>
                    current_state <= "0011";  -- 4
                    student_id    <= "0011";  -- 3

                when s4 =>
                    current_state <= "0100";  -- 2
                    student_id    <= "0000";  -- 0

                when s5 =>
                    current_state <= "0101";  -- 7
                    student_id    <= "1000";  -- 8

                when s6 =>
                    current_state <= "0110";  -- 5
                    student_id    <= "0110";  -- 6

                when s7 =>
                    current_state <= "0111";  -- 3
                    student_id    <= "0110";  -- 6

                when s8 =>
                    current_state <= "1000";  -- 1
                    student_id    <= "0011";  -- 3

                when others =>
                    current_state <= "0000";
                    student_id    <= "1110";
            end case;

        end if;
    end process;

end fsm;
