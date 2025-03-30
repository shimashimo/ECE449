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
        -- clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR(15 downto 0);
        B : in STD_LOGIC_VECTOR(15 downto 0);
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
--                                    Z <= '0';
--                                    N <= '0';
                                    
                    when "010" =>   
                                    if A = B then
                                        Y <= x"0000";
                                    else
                                        Y <= A - B;
                                    end if;
--                                    Z <= '0';
--                                    N <= '0';
                    when "011" =>   p1 := std_logic_vector(unsigned(A) * unsigned(B));
                                    Y <= p1(15 downto 0);
--                                    Z <= '0';
--                                    N <= '0';
                                    
                    when "100" =>   Y <= A NAND B;
--                                    Z <= '0';   
--                                    N <= '0';
                    
                    when "101" =>  for i in 0 to 15 loop
                                        if i <= 15 - to_integer(unsigned(B)) then
                                            Y(i + to_integer(unsigned(B))) <= A(i);
                                        end if;
                                        if i < to_integer(unsigned(B)) then
                                            Y(i) <= '0';
                                        end if;
                                    end loop;
--                                    Z <= '0';
--                                    N <= '0';
                                    
                    when "110" =>   for i in 0 to 15 loop
                                        if i >= to_integer(unsigned(B)) then
                                            Y(i - to_integer(unsigned(B))) <= A(i);
                                        else
                                            Y(i) <= '0';
                                        end if;
                                    end loop;
--                                    Z <= '0';
--                                    N <= '0';
                                    
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
--                                    Y <= '0';
--                                    Z <= '0';
--                                    N <= '0';
                end case;
            end if;
    end process;
    
end Behavioral;
