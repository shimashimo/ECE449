----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2025 04:47:42 PM
-- Design Name: 
-- Module Name: Controller - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( 
        rst: in STD_LOGIC;
        op_in: in STD_LOGIC_VECTOR(5 downto 0);
        alu_op: out STD_LOGIC_VECTOR(2 downto 0);
        mem_op: out STD_LOGIC;
        wb_op: out STD_LOGIC 
    );
end Controller;

architecture Behavioral of Controller is

begin
    process(op_in) begin
        case op_in is
            when "000001" | "000010" | "000011" | "000100" | "000101" | "000110" | "000111" => -- ALU 
                alu_op <= op_in(2 downto 0);
                mem_op <= '0';
                wb_op <= '0';
            when "100000" | "100001" => -- Writeback
                wb_op <= '1';
                mem_op <= '0';
                alu_op <= "000";
            when "010000" | "010001" | "010010" | "010011" => --Memory Access
                mem_op <= '1';
                mem_op <= '0';
                alu_op <= "000";
        end case;
    
    end process;
end Behavioral;
