----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2025 05:19:59 PM
-- Design Name: 
-- Module Name: EX_MEM - Behavioral
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

entity EX_MEM is
    Port ( 
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            alu_result: in STD_LOGIC_VECTOR(15 downto 0);
            mem_op: in STD_LOGIC;
            wb_op: in STD_LOGIC;
            inst_in: in STD_LOGIC_VECTOR(15 downto 0);      -- Propagate whole instruction
            mem_addr: out STD_LOGIC_VECTOR(15 downto 0);
            wr_en: out STD_LOGIC;
            wb_out: out STD_LOGIC;
            inst_out: out STD_LOGIC_VECTOR(15 downto 0);     -- Propagate whole instruction
            alu_result_out: out STD_LOGIC_VECTOR(15 downto 0)
            );
end EX_MEM;

architecture Behavioral of EX_MEM is

begin
    process(clk) begin
        if (clk = '1') then
            inst_out <= inst_in;
            wb_out <= wb_op;
            alu_result_out <= alu_result;
        end if;
    
    end process;


end Behavioral;
