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
        A : in STD_LOGIC_VECTOR(2 downto 0);
        B : in STD_LOGIC_VECTOR(2 downto 0);
--        CarryIn : in STD_LOGIC;
        OP : in STD_LOGIC_VECTOR(6 downto 0);       -- Opcode is 7 bits
--        Status : out STD_LOGIC_VECTOR(4 downto 0);
        Y : out STD_LOGIC_VECTOR(2 downto 0));
end ALU;

architecture Behavioral of ALU is
begin
    process (A, B, OP)
        variable p1: STD_LOGIC_VECTOR(5 downto 0);
    begin
        case OP is
            when "0000001" => Y <= A + B;
            when "0000010" => Y <= A - B;
            when "0000011" => p1 := A * B;
                              Y <= p1(2 downto 0);
            when "0000100" => Y <= A NAND B;
            when others => NULL;
        end case;
    end process;
    
end Behavioral;
