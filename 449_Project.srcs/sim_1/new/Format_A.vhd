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

entity alu_sim is
    Port(
        clk: in STD_LOGIC;
        out: out STD_LOGIC_VECTOR(15 downto 0)
    );
end alu_sim;

architecture Behavioral of alu_sim is

    signal A: STD_LOGIC_VECTOR(15 downto 0) := std_logic_vector(to_signed(-4,16));
    signal B: STD_LOGIC_VECTOR(15 downto 0) := std_logic_vector(to_signed(-4,16));
    signal OP: STD_LOGIC_VECTOR(2 downto 0);
    signal Y: STD_LOGIC_VECTOR(15 downto 0);
    signal Z: STD_LOGIC;
    signal N: STD_LOGIC;
    signal r1: STD_LOGIC_VECTOR(15 downto 0);
    signal r2: STD_LOGIC_VECTOR(15 downto 0);
    signal r3: STD_LOGIC_VECTOR(15 downto 0);    
    
begin
UUT: entity work.ALU
    port map(A => A, B => B, OP => OP, Y => Y, Z => Z, N => N);

testbench: process(clk)
    begin
    
    r1 <= x"03";
    r2 <= x"05";

    wait until rising_edge(clk);

    OP <= "001";
    A <= r2;
    B <= r1;
    r3 <= Y;

    wait until rising_edge(clk);

    OP <= "101";
    A <= r3;
    B <= x"02";

    wait until rising_edge(clk);

    OP <= "011";
    A <= r1;
    B <= r3;
    r2 <= Y;

    wait until rising_edge(clk);

    out <= r2

    end loop;
end process testbench;

end Behavioral;
