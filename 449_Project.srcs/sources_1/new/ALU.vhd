----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Eric and Ewan
-- 
-- Create Date: 02/10/2025 04:14:26 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created: Feb. 10, 2025
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ALU is
    Port (
        rst : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR(15 downto 0);       
        B : in STD_LOGIC_VECTOR(15 downto 0);
        misc: in STD_LOGIC_VECTOR(8 downto 0);      -- MISC values for A2 instructions
        OP : in STD_LOGIC_VECTOR(2 downto 0);       -- Opcode is 7 bits
        Y : out STD_LOGIC_VECTOR(15 downto 0);
        Z : out STD_LOGIC;
        N : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
begin
    process (rst, A, B, OP)
        variable p1: STD_LOGIC_VECTOR(31 downto 0);
    begin
            if rst = '1' then
                Y <= x"0000";
                Z <= '0';
                N <= '0';
            else
                case OP is
                    when "001" =>   Y <= A + B;
                                    
                    when "010" =>   
                                    if A = B then
                                        Y <= x"0000";
                                    else
                                        Y <= A - B;
                                    end if;

                    when "011" =>   p1 := std_logic_vector(unsigned(A) * unsigned(B));
                                    Y <= p1(15 downto 0);
                                    
                    when "100" =>   Y <= A NAND B;

                    when "101" => Y <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(misc))));

                    when "110" => Y <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(misc))));
                                    
                    when "111" =>   if signed(A) < 0 then
                                        N <= '1';
                                    else
                                        N <= '0';
                                    end if;
                                    if unsigned(A) = 0 then
                                        Z <= '1';
                                    else
                                        Z <= '0';
                                    end if;
                                    Y <= (others => '0');
                    
                    when others =>  NULL;    -- Output NULL on NOP?

                end case;
            end if;
    end process;
    
end Behavioral;
