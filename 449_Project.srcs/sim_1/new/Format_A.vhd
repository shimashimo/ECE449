----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2025 05:16:27 PM
-- Design Name: 
-- Module Name: Format A - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity format_a_sim is
end format_a_sim;

architecture Behavioral of format_a_sim is

    signal A: STD_LOGIC_VECTOR(15 downto 0);
    signal B: STD_LOGIC_VECTOR(15 downto 0);
    signal OP: STD_LOGIC_VECTOR(2 downto 0);
    signal Y: STD_LOGIC_VECTOR(15 downto 0);
    signal Z: STD_LOGIC;
    signal N: STD_LOGIC;
    signal r1: STD_LOGIC_VECTOR(15 downto 0);
    signal r2: STD_LOGIC_VECTOR(15 downto 0);
    signal r3: STD_LOGIC_VECTOR(15 downto 0);    
    signal rst: STD_LOGIC := '0';
    signal clk: STD_LOGIC;
    signal output: STD_LOGIC_VECTOR(15 downto 0);
    signal pc: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
begin
UUT: entity work.ALU
    port map(rst => rst, A => A, B => B, OP => OP, Y => Y, Z => Z, N => N);

process begin
    clk <= '0';
    wait for 1us;
    clk <= '1';
    wait for 1us;
end process;

testbench: process(clk)
    begin
    
    if pc = "0000" then -- Reset all values to 0, set initial values of registers, r1 and r2
              rst <= '1';
              r1 <= x"0003";
              r2 <= x"0005";
              A <= x"0000";
              B <= x"0000";
              OP <= "000";
    end if;
            
    if rising_edge(clk) then  
        if pc = "0001" then
            rst <= '0';
        end if;
        
        if pc = "0010" then
            OP <= "001";
            A <= r2;
            B <= r1;
        end if;
        
        if pc = "0011" then
            r3 <= Y;
        end if; 
    
        if pc = "0100" then
            OP <= "101";
            A <= r3;
            B <= x"0002";
        end if;
        
        if PC = "0101" then 
            r3 <= Y;
        end if;
    
        if pc = "0110" then
            OP <= "011";
            A <= r1;
            B <= r3;
        end if;
    
        if pc = "0111" then
            r2 <= Y;
        end if;
        
        if pc = "1000" then
            output <= r2;
        end if;
        
        pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
      
    end if;
end process testbench;

end Behavioral;
