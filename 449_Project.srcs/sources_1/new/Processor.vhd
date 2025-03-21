----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 05:34:38 PM
-- Design Name: 
-- Module Name: Processor - Behavioral
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

entity Processor is

    Port ( 
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            out_port: out STD_LOGIC_VECTOR(15 downto 0));
end Processor;

architecture Behavioral of Processor is


-- Branch
--signal clk: STD_LOGIC; 
--signal rst: STD_LOGIC := '1';
signal PC: STD_LOGIC_VECTOR(15 downto 0);
signal instruction, brch_addr: STD_LOGIC_VECTOR(15 downto 0);
signal fetch_PC: STD_LOGIC_VECTOR(15 downto 0);
signal brch_en, stall: STD_LOGIC;
signal old_PC: STD_LOGIC_VECTOR(15 downto 0);

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
signal ID_EX_disp: STD_LOGIC_VECTOR(8 downto 0);

-- Controller
signal CON_alu_op: STD_LOGIC_VECTOR(2 downto 0);
signal CON_mem_op: STD_LOGIC;
signal CON_wb_op: STD_LOGIC;

-- EX_MEM
signal EX_MEM_mem_addr: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_DATA: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_wr_en: STD_LOGIC;
signal EX_MEM_wb_out: STD_LOGIC;
signal EX_MEM_inst_out: STD_LOGIC_VECTOR(15 downto 0);     -- Propagate whole instruction
signal EX_MEM_alu_result_out: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_PC: STD_LOGIC_VECTOR(15 downto 0);

-- ALU
signal Y: STD_LOGIC_VECTOR(15 downto 0);
signal Z: STD_LOGIC;
signal N: STD_LOGIC;

-- ForwardingUnit
signal ForwardA : std_logic_vector(1 downto 0);
signal ForwardB : std_logic_vector(1 downto 0);


-- 3 to 1 MUX
signal A : std_logic_vector(15 downto 0);
signal B : std_logic_vector(15 downto 0);


-- MEM_WB
signal MEM_WB_wr_en: STD_LOGIC;
signal MEM_WB_data_out: STD_LOGIC_VECTOR(15 downto 0);
signal MEM_WB_ra: STD_LOGIC_VECTOR(2 downto 0);

-- RAM
signal RAM_data_out: STD_LOGIC_VECTOR(15 downto 0);


begin
Prog_count: entity work.Program_Counter port map(clk, rst, brch_addr, brch_en, stall, PC);
IF_ID: entity work.IF_ID port map(clk, rst, instruction, PC, brch_en, stall, IF_ID_PC, IF_ID_op, IF_ID_ra, IF_ID_rb, IF_ID_rc, IF_ID_inst, IF_ID_misc, IF_ID_disp);
reg: entity work.register_file port map(clk, rst, IF_ID_rb, IF_ID_rc, MEM_WB_ra, MEM_WB_data_out, MEM_WB_wr_en, rd_data1, rd_data2);
controller: entity work.Controller port map(rst, IF_ID_op, CON_alu_op, CON_mem_op, CON_wb_op);
hazard: entity work.HazardDetection port map(IF_ID_inst, ID_EX_inst_out, CON_mem_op, stall);
ID_EX: entity work.ID_EX port map(clk, rst, IF_ID_inst, IF_ID_op, rd_data1, rd_data2, CON_alu_op, CON_mem_op, CON_wb_op, IF_ID_PC, brch_en, stall, IF_ID_disp, ID_EX_disp, ID_EX_PC, ID_EX_alu_out, ID_EX_mem_out, ID_EX_wb_out, ID_EX_RD1, ID_EX_RD2, ID_EX_inst_out);
ForwardingUnit: entity work.ForwardingUnit port map(ID_EX_inst_out, EX_MEM_inst_out, MEM_WB_ra, EX_MEM_wb_out, MEM_WB_wr_en, ForwardA, ForwardB);
MUXA: entity work.MUX3to1 port map(ID_EX_RD1, MEM_WB_data_out, EX_MEM_alu_result_out, ForwardA, A);
MUXB: entity work.MUX3to1 port map(ID_EX_RD2, MEM_WB_data_out, EX_MEM_alu_result_out, ForwardB, B);
ALU: entity work.ALU port map(rst, A, B, ID_EX_alu_out, Y, Z, N);
branch: entity work.Branch port map(ID_EX_PC, ID_EX_inst_out, ID_EX_disp, Z, N, ID_EX_RD1, old_PC, brch_addr, brch_en);
EX_MEM: entity work.EX_MEM port map(clk, rst, Y, ID_EX_mem_out, ID_EX_wb_out, ID_EX_inst_out, A, B, EX_MEM_mem_addr, EX_MEM_DATA, EX_MEM_wr_en, EX_MEM_wb_out, EX_MEM_inst_out, EX_MEM_alu_result_out);
MEM_WB: entity work.MEM_WB port map(clk, rst, RAM_DATA_out, EX_MEM_alu_result_out, old_PC, EX_MEM_inst_out, EX_MEM_wb_out, MEM_WB_wr_en, MEM_WB_data_out, MEM_WB_ra);


    process(clk) begin
        
    end process;
end Behavioral;
