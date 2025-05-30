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

signal rst: std_logic := '1';
signal clk: std_logic;
signal IN_PORT: std_logic_vector(15 downto 6);

-- Branch
signal PC: STD_LOGIC_VECTOR(15 downto 0);
signal instruction, brch_addr: STD_LOGIC_VECTOR(15 downto 0);
signal fetch_PC: STD_LOGIC_VECTOR(15 downto 0);
signal brch_en, stall: STD_LOGIC;
signal old_PC: STD_LOGIC_VECTOR(15 downto 0);

-- ROM
signal ROM_out: STD_LOGIC_VECTOR(15 downto 0);
signal ROM_en: STD_LOGIC;

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
signal EX_MEM_mem_addra: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_mem_addrb: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_DATA: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_mem_en: STD_LOGIC;
signal EX_MEM_wr_en: STD_LOGIC_VECTOR(0 downto 0);
signal EX_MEM_wb_out: STD_LOGIC;
signal EX_MEM_inst_out: STD_LOGIC_VECTOR(15 downto 0);     -- Propagate whole instruction
signal EX_MEM_alu_result_out: STD_LOGIC_VECTOR(15 downto 0);
signal EX_MEM_PC: STD_LOGIC_VECTOR(15 downto 0);

-- ALU
signal Y: STD_LOGIC_VECTOR(15 downto 0);
signal Z: STD_LOGIC;
signal N: STD_LOGIC;

-- ForwardingUnit
signal ForwardA: std_logic_vector(1 downto 0);
signal ForwardB: std_logic_vector(1 downto 0);


-- 3 to 1 MUX
signal A: std_logic_vector(15 downto 0);
signal B: std_logic_vector(15 downto 0);


-- MEM_WB
signal MEM_WB_wr_en: STD_LOGIC;
signal MEM_WB_data_out: STD_LOGIC_VECTOR(15 downto 0);
signal MEM_WB_ra: STD_LOGIC_VECTOR(2 downto 0);

-- RAM
signal RAM_data_outa: STD_LOGIC_VECTOR(15 downto 0);
signal RAM_data_outb: STD_LOGIC_VECTOR(15 downto 0);
signal RAM_PC: STD_LOGIC_VECTOR(15 downto 0);


begin
Prog_count: entity work.Program_Counter 
    port map(clk=>clk, rst_ld=>rst, rst_ex => '0', brch_addr=>brch_addr, brch_en=>brch_en, stall=>stall, PC=>PC);
    
IF_ID: entity work.IF_ID 
    port map(clk=>clk, rst=>rst, inst=>instruction, PC_in=>fetch_PC, flush_en=>brch_en, stall_en=>stall, PC_out=>IF_ID_PC, out_op=>IF_ID_op, ra=>IF_ID_ra, 
             rb=>IF_ID_rb, rc=>IF_ID_rc, inst_out=>IF_ID_inst, misc=>IF_ID_misc, disp=>IF_ID_disp);
             
reg: entity work.register_file 
    port map(clk=>clk, rst=>rst, rd_index1=>IF_ID_rb, rd_index2=>IF_ID_rc, wr_index=>MEM_WB_ra, wr_data=>MEM_WB_data_out, 
             wr_enable=>MEM_WB_wr_en, rd_data1=>rd_data1, rd_data2=>rd_data2);
             
controller: entity work.Controller 
    port map(rst=>rst, op_in=>IF_ID_op, alu_op=>CON_alu_op, mem_op=>CON_mem_op, wb_op=>CON_wb_op);
    
hazard: entity work.HazardDetection 
    port map(clk=>clk, IF_ID_instr=>IF_ID_inst, ID_EX_instr=>ID_EX_inst_out, ID_EX_mem_op=>CON_mem_op, MEM_WB_en=>MEM_WB_wr_en, MEM_WB_ra=>MEM_WB_ra, stall=>stall);
    
ID_EX: entity work.ID_EX 
    port map(clk=>clk, rst=>rst, inst_in=>IF_ID_inst, op_in=>IF_ID_op, rd_data1=>rd_data1, rd_data2=>rd_data2, alu_in=>CON_alu_op, mem_in=>CON_mem_op, 
             wb_in=>CON_wb_op, PC_in=>IF_ID_PC, flush_en=>brch_en, stall_en=>stall, disp_in=>IF_ID_disp, disp_out=>ID_EX_disp, PC_out=>ID_EX_PC, alu_out=>ID_EX_alu_out, 
             mem_out=>ID_EX_mem_out, wb_out=>ID_EX_wb_out, RD1=>ID_EX_RD1, RD2=>ID_EX_RD2, inst_out=>ID_EX_inst_out);
             
ForwardingUnit: entity work.ForwardingUnit 
    port map(ID_EX_instr=>ID_EX_inst_out, EX_MEM_instr=>EX_MEM_inst_out, MEM_WB_rd=>MEM_WB_ra, EX_MEM_wb=>EX_MEM_wb_out, MEM_WB_wb=>MEM_WB_wr_en, ForwardA=>ForwardA, 
             ForwardB=>ForwardB);
    
MUXA: entity work.MUX3to1 
    port map(A=>ID_EX_RD1, B=>MEM_WB_data_out, C=>EX_MEM_alu_result_out, Sel=>ForwardA, Y=>A);

MUXB: entity work.MUX3to1 
    port map(A=>ID_EX_RD2, B=>MEM_WB_data_out, C=>EX_MEM_alu_result_out, Sel=>ForwardB, Y=>B);
    
ALU: entity work.ALU 
    port map(rst=>rst, A=>A, B=>B, OP=>ID_EX_alu_out, Y=>Y, Z=>Z, N=>N);
    
branch: entity work.Branch 
    port map(PC=>ID_EX_PC, inst_in=>ID_EX_inst_out, disp=>ID_EX_disp, Z=>Z, N=>N, ra=>ID_EX_RD1, old_PC=>old_PC, brch_addr=>brch_addr, brch_en=>brch_en);
    
EX_MEM: entity work.EX_MEM 
    port map(clk=>clk, rst=>rst, alu_result=>Y, mem_op=>ID_EX_mem_out, wb_op=>ID_EX_wb_out, inst_in=>ID_EX_inst_out, memA=>A, memB=>B, 
             mem_addra=>EX_MEM_mem_addra, mem_data=>EX_MEM_DATA, mem_en=>EX_MEM_mem_en, wr_en=>EX_MEM_wr_en, wb_out=>EX_MEM_wb_out, inst_out=>EX_MEM_inst_out, 
             alu_result_out=>EX_MEM_alu_result_out);
             
RAM: entity work.RAM 
    port map(clk=>clk, PC_in=>PC, rst_a=>rst, rst_b=>rst, enb_a=>EX_MEM_mem_en, enb_b=>EX_MEM_mem_en, write_a=>EX_MEM_wr_en, addr_a=>EX_MEM_mem_addra, 
             addr_b=>PC, din=>EX_MEM_DATA, dout_a=>RAM_data_outa, dout_b=>RAM_data_outb, PC_out=>RAM_PC);
             
MEM_WB: entity work.MEM_WB 
    port map(clk=>clk, rst=>rst, in_port_data=>IN_PORT, mem_data=>RAM_DATA_outa, data_in=>EX_MEM_alu_result_out, old_PC_in=>old_PC, inst_in=>EX_MEM_inst_out, wb_in=>EX_MEM_wb_out,
             wr_en=>MEM_WB_wr_en, data_out=>MEM_WB_data_out, ra=>MEM_WB_ra);


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
    if(rising_edge(clk)) then
    case PC is 
        when x"0000" => 
            rst <= '0'; 
            instruction <= "0010010000000010";  -- Load R0 load value 2
        when x"0002" => 
            instruction <= "0010011000111000";  -- Load R0 load value 2
        when x"0004" =>
            instruction <= "0010010000000011";  -- Load R1 load value 3
        when x"0006" => 
            instruction <= "0010011001111000";  -- Load R1 load value 2
        when x"0008" => 
            instruction <= "0010010000000001";  -- Load R2 value of 1
        when x"000a" => 
            instruction <= "0010011010111000";  -- Load R0 load value 2
        when x"000c" =>
            instruction <= "0010010000000101";  -- Load R3 value of 5
        when x"000e" => 
            instruction <= "0010011011111000";  -- Load R0 load value 2
        when x"0010" => 
            instruction <= "0010010000000000";  -- Load R4 value of 528 (Storing 000000 into R4 in our case)
        when x"0012" => 
            instruction <= "0010011100111000";  -- Load R0 load value 2
        when x"0014" =>
            instruction <= "0010010000000001";  -- Load R5 value of 1
        when x"0016" => 
            instruction <= "0010011101111000";  -- Load R0 load value 2
        when x"0018" => 
            instruction <= "0010010000000101";  -- Load R6 value of 5
        when x"001a" => 
            instruction <= "0010011110111000";  -- Load R0 load value 2
        when x"001c" =>
            instruction <= "0010010000000000";  -- Load R7 value of 0
        when x"001e" => 
            instruction <= "1000110100010001";  -- BR.SUB R4, 10    - Go to subroutine (go to PC = 0x14)
        when x"0020" => 
            instruction <= "1000000000000000";  -- BRR 0 - Infinite Loop; PC <= PC+2*0 = PC. This is for when program is done and halts infinitely
        when x"0022" => 
            instruction <= "0000001010001101";  -- ADD R2, R1, R5 ; Start of subroutine. Runs 5 times. - R2 <-- R1 + 1
        when x"0024" => 
            instruction <= "0000011001000010";  -- MUL R1, R0, R2 ; R1 <-- R0 x R2       
        when x"0026" => 
            instruction <= "0000010110110101";  -- SUB R6, R6, R5 ; R6 <-- R6 - 1   The counter for the loop.
        when x"0028" => 
            instruction <= "0000111110000000";  -- TEST R6        ; Set the z flag for the branch decision     
        when x"002a" => 
            instruction <= "1000010000000010";  -- BRR.z 2     ; If r6 is zero, jump out of the loop.
        when x"002c" => 
            instruction <= "1000000111111011";  -- BRR -5		; If not jump to the start of the subroutine.  Go back to PC = 0x14
        when others => instruction <= x"0000";  
    end case;
    fetch_PC <= PC;
    end if;
end process;

end Behavioral;
