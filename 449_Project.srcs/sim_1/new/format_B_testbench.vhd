----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2025 03:23:47 PM
-- Design Name: 
-- Module Name: format_B_testbench - Behavioral
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

entity format_B_testbench is
--  Port ( );
end format_B_testbench;

architecture Behavioral of format_B_testbench is
signal clk: STD_LOGIC; 
signal rst: STD_LOGIC := '1';
signal PC: STD_LOGIC_VECTOR(15 downto 0);
signal instruction, brch_addr: STD_LOGIC_VECTOR(15 downto 0);
signal brch_en, stall: STD_LOGIC;

-- IF_ID 
signal IF_ID_inst: STD_LOGIC_VECTOR(15 downto 0);
signal IF_ID_op: STD_LOGIC_VECTOR(6 downto 0);
signal IF_ID_ra, IF_ID_rb, IF_ID_rc: STD_LOGIC_VECTOR(2 downto 0);
signal IF_ID_misc, IF_ID_disp: STD_LOGIC_VECTOR(8 downto 0);
signal IF_ID_PC: STD_LOGIC_VECTOR(15 downto 0);

-- Register File
signal rd_data1: std_logic_vector(15 downto 0); 
signal rd_data2: std_logic_vector(15 downto 0);

-- ID_EX
signal ID_EX_alu_out: STD_LOGIC_VECTOR(2 downto 0);
signal ID_EX_mem_out: STD_LOGIC;
signal ID_EX_wb_out: STD_LOGIC;
signal ID_EX_RD1: STD_LOGIC_VECTOR(15 downto 0);
signal ID_EX_RD2: STD_LOGIC_VECTOR(15 downto 0);
signal ID_EX_inst_out: STD_LOGIC_VECTOR(15 downto 0); -- Propagete Instruction
signal ID_EX_PC: STD_LOGIC_VECTOR(15 downto 0);

-- Controller
signal CON_alu_op: STD_LOGIC_VECTOR(2 downto 0);
signal CON_mem_op: STD_LOGIC;
signal CON_wb_op: STD_LOGIC;

-- EX_MEM
signal EX_MEM_mem_addr: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_wr_en: STD_LOGIC;
signal EX_MEM_wb_out: STD_LOGIC;
signal EX_MEM_inst_out: STD_LOGIC_VECTOR(15 downto 0);     -- Propagate whole instruction
signal EX_MEM_alu_result_out: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_PC: STD_LOGIC_VECTOR(15 downto 0);

-- ALU
signal Y: STD_LOGIC_VECTOR(15 downto 0);
signal Z: STD_LOGIC;
signal N: STD_LOGIC;

-- Branch 



-- MEM_WB
signal MEM_WB_wr_en: STD_LOGIC;
signal MEM_WB_data_out: STD_LOGIC_VECTOR(15 downto 0);
signal MEM_WB_ra: STD_LOGIC_VECTOR(2 downto 0);




begin
Prog_count: entity work.Program_Counter port map(clk, rst, brch_addr, brch_en, stall, PC);
IF_ID: entity work.IF_ID port map(clk, rst, instruction, PC, IF_ID_PC, IF_ID_op, IF_ID_ra, IF_ID_rb, IF_ID_rc, IF_ID_inst, IF_ID_misc, IF_ID_disp);
reg: entity work.register_file port map(clk, rst, IF_ID_rb, IF_ID_rc, MEM_WB_ra, MEM_WB_data_out, MEM_WB_wr_en, rd_data1, rd_data2);
controller: entity work.Controller port map(rst, IF_ID_op, CON_alu_op, CON_mem_op, CON_wb_op);
ID_EX: entity work.ID_EX port map(clk, rst, IF_ID_inst, IF_ID_op, rd_data1, rd_data2, CON_alu_op, CON_mem_op, CON_wb_op, IF_ID_PC, ID_EX_PC, ID_EX_alu_out, ID_EX_mem_out, ID_EX_wb_out, ID_EX_RD1, ID_EX_RD2, ID_EX_inst_out);
ALU: entity work.ALU port map(rst, ID_EX_RD1, ID_EX_RD2, ID_EX_alu_out, Y, Z, N);
branch: entity work.branch port map(ID_EX_PC, ID_EX_inst_out,  IF_ID_disp, Z, N, ID_EX_RD1, EX_MEM_alu_result_out, EX_MEM_wb_out, brch_addr, brch_en);
EX_MEM: entity work.EX_MEM port map(clk, rst, Y, ID_EX_mem_out, ID_EX_wb_out, ID_EX_inst_out, EX_MEM_mem_addr, EX_MEM_wr_en, EX_MEM_wb_out, EX_MEM_inst_out, EX_MEM_alu_result_out);
MEM_WB: entity work.MEM_WB port map(clk, rst, EX_MEM_alu_result_out, EX_MEM_inst_out, EX_MEM_wb_out, MEM_WB_wr_en, MEM_WB_data_out, MEM_WB_ra);

process begin
    clk <= '0';
    wait for 1us;
    clk <= '1';
    wait for 1us;
end process;

testbench: process(clk) begin
--    rst <= '1';
--    wait for 1us; 
--    rst <= '0';
    
    case PC is 
        when x"0000" => 
            rst <= '0'; 
            instruction <= "0100001000000010";
        when x"0002" =>
            instruction <= "0100001001000011";
        when x"0004" => 
            instruction <= "0100001010000001";
        when x"0006" =>
            instruction <= "0100001011000101";
        when x"0008" => 
            instruction <= "0100001100000000";
        when x"000a" =>
            instruction <= "0100001101000001";
        when x"000c" => 
            instruction <= "0100001110000101";
        when x"000e" =>
            instruction <= "0100001111000000";
        when x"0010" => 
            instruction <= "1000110100001010";
        when x"0012" => 
            instruction <= "1000000000000000";
        when x"0014" => 
            instruction <= "0000001010001101";
        when x"0016" => 
            instruction <= "0000011001000010";         
        when x"0018" => 
            instruction <= "0000010110110101";   
        when x"001a" => 
            instruction <= "0000111110000000";       
        when x"001c" => 
            instruction <= "1000010000000010";  
        when x"001e" => 
            instruction <= "1000000111111011";    
        when others => NULL;
    end case;
end process;

end Behavioral;
