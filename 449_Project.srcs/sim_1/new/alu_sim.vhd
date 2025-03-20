----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2025 05:16:27 PM
-- Design Name: 
-- Module Name: alu_sim - Behavioral
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
end alu_sim;

architecture Behavioral of alu_sim is

    signal A: STD_LOGIC_VECTOR(15 downto 0) := std_logic_vector(to_signed(-4,16));
    signal B: STD_LOGIC_VECTOR(15 downto 0) := std_logic_vector(to_signed(-4,16));
    signal OP: STD_LOGIC_VECTOR(2 downto 0);
    signal Y: STD_LOGIC_VECTOR(15 downto 0);
    signal Z: STD_LOGIC;
    signal N: STD_LOGIC;
    signal rst: STD_LOGIC;
    
begin
UUT: entity work.ALU
    port map(rst => rst, A => A, B => B, OP => OP, Y => Y, Z => Z, N => N);



process
    begin
        OP <= "010";
        A <= x"000a";
        B <= x"000a";
        wait for 1 us;
        
        OP <= "111";
        A <= x"0000";
        B <= x"0000";
        wait for 5 us;
        
        
end process;

end Behavioral;
