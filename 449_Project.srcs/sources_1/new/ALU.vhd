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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port (
        clk : in STD_LOGIC;
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
    process (clk)
        variable p1: STD_LOGIC_VECTOR(31 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                Y <= x"0000";
                Z <= '0';
                N <= '0';
            else
                case OP is
                    when "001" => Y <= A + B;
                    when "010" => Y <= A - B;
                    when "011" => p1 := std_logic_vector(unsigned(A) * unsigned(B));
                                    Y <= p1(15 downto 0);
                    when "100" => Y <= A NAND B;
                    when "101" =>  for i in 0 to 15 loop
                                        if i <= 15 - to_integer(unsigned(B)) then
                                            Y(i + to_integer(unsigned(B))) <= A(i);
                                        end if;
                                        if i < to_integer(unsigned(B)) then
                                            Y(i) <= '0';
                                        end if;
                                    end loop;
                    when "110" =>   for i in 0 to 15 loop
                                        if i >= to_integer(unsigned(B)) then
                                            Y(i - to_integer(unsigned(B))) <= A(i);
                                        else
                                            Y(i) <= '0';
                                        end if;
                                    end loop;
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
                    when others => NULL;
                end case;
            end if;
        end if;
    end process;
    
end Behavioral;
