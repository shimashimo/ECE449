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
            ResetLoad: in STD_LOGIC;
            ResetExecute: in STD_LOGIC;
            IN_PORT: in STD_LOGIC_VECTOR(15 downto 6);
            OUT_PORT: out STD_LOGIC_VECTOR(0 downto 0);
            
            led_segments : out STD_LOGIC_VECTOR( 6 downto 0 );
            led_digits : out STD_LOGIC_VECTOR( 3 downto 0 );
            
            debug_console : in STD_LOGIC;
            board_clock: in std_logic;
    
            vga_red : out std_logic_vector( 3 downto 0 );
            vga_green : out std_logic_vector( 3 downto 0 );
            vga_blue : out std_logic_vector( 3 downto 0 );
    
            h_sync_signal : out std_logic;
            v_sync_signal : out std_logic
            );
end Processor;

architecture Behavioral of Processor is


component led_display is
    Port (

        addr_write : in  STD_LOGIC_VECTOR (15 downto 0);
        clk : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR (15 downto 0);
        en_write : in  STD_LOGIC;

        board_clock : in STD_LOGIC;
        led_segments : out STD_LOGIC_VECTOR( 6 downto 0 );
        led_digits : out STD_LOGIC_VECTOR( 3 downto 0 )
    );
end component;

component console is
    port (

--
-- Stage 1 Fetch
--
        s1_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s1_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );


--
-- Stage 2 Decode
--
        s2_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s2_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );

        s2_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
        s2_reg_b : in STD_LOGIC_VECTOR( 2 downto 0 );
        s2_reg_c : in STD_LOGIC_VECTOR( 2 downto 0 );

        s2_reg_a_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s2_reg_b_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s2_reg_c_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s2_immediate : in STD_LOGIC_VECTOR( 15 downto 0 );


--
-- Stage 3 Execute
--
        s3_pc : in STD_LOGIC_VECTOR ( 15 downto 0 );
        s3_inst : in STD_LOGIC_VECTOR ( 15 downto 0 );

        s3_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );
        s3_reg_b : in STD_LOGIC_VECTOR( 2 downto 0 );
        s3_reg_c : in STD_LOGIC_VECTOR( 2 downto 0 );

        s3_reg_a_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_reg_b_data : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_reg_c_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_immediate : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- Branch and memory operation
--
        s3_r_wb : in STD_LOGIC;
        s3_r_wb_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_br_wb : in STD_LOGIC;
        s3_br_wb_address : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_mr_wr : in STD_LOGIC;
        s3_mr_wr_address : in STD_LOGIC_VECTOR( 15 downto 0 );
        s3_mr_wr_data : in STD_LOGIC_VECTOR( 15 downto 0 );

        s3_mr_rd : in STD_LOGIC;
        s3_mr_rd_address : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- Stage 4 Memory
--
        s4_pc : in STD_LOGIC_VECTOR( 15 downto 0 );
        s4_inst : in STD_LOGIC_VECTOR( 15 downto 0 );

        s4_reg_a : in STD_LOGIC_VECTOR( 2 downto 0 );

        s4_r_wb : in STD_LOGIC;
        s4_r_wb_data : in STD_LOGIC_VECTOR( 15 downto 0 );

--
-- CPU registers
--

        register_0 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_2 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_3 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_4 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_5 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_6 : in STD_LOGIC_VECTOR ( 15 downto 0 );
        register_7 : in STD_LOGIC_VECTOR ( 15 downto 0 );

--
-- CPU registers overflow flags
--
        register_0_of : in STD_LOGIC;
        register_1_of : in STD_LOGIC;
        register_2_of : in STD_LOGIC;
        register_3_of : in STD_LOGIC;
        register_4_of : in STD_LOGIC;
        register_5_of : in STD_LOGIC;
        register_6_of : in STD_LOGIC;
        register_7_of : in STD_LOGIC;

--
-- CPU Flags
--
        zero_flag : in STD_LOGIC;
        negative_flag : in STD_LOGIC;
        overflow_flag : in STD_LOGIC;

--
-- Debug screen enable
--
        debug : in STD_LOGIC;

--
-- Text console display memory access signals ( clk is the processor clock )
--
        addr_write : in  STD_LOGIC_VECTOR (15 downto 0);
        clk : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR (15 downto 0);
        en_write : in  STD_LOGIC;

--
-- Video related signals
--
        board_clock : in STD_LOGIC;
        v_sync_signal : out STD_LOGIC;
        h_sync_signal : out STD_LOGIC;
        vga_red : out STD_LOGIC_VECTOR( 3 downto 0 );
        vga_green : out STD_LOGIC_VECTOR( 3 downto 0 );
        vga_blue : out STD_LOGIC_VECTOR( 3 downto 0 )
    );
end component;

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

-- registers
signal reg_0: STD_LOGIC_VECTOR(15 downto 0);
signal reg_1: STD_LOGIC_VECTOR(15 downto 0);
signal reg_2: STD_LOGIC_VECTOR(15 downto 0);
signal reg_3: STD_LOGIC_VECTOR(15 downto 0);
signal reg_4: STD_LOGIC_VECTOR(15 downto 0);
signal reg_5: STD_LOGIC_VECTOR(15 downto 0);
signal reg_6: STD_LOGIC_VECTOR(15 downto 0);
signal reg_7: STD_LOGIC_VECTOR(15 downto 0);


begin
Prog_count: entity work.Program_Counter 
    port map(clk=>clk, rst_ld=>ResetLoad, rst_ex => ResetExecute, brch_addr=>brch_addr, brch_en=>brch_en, stall=>stall, PC=>PC);
    
ROM: entity work.ROM
    port map(clk=>clk, rst=>ResetExecute, enb=>ROM_en, addr=>PC, data_out=>ROM_out);
    
IF_ID: entity work.IF_ID 
    port map(clk=>clk, rst=>ResetExecute, inst=>ROM_out, PC_in=>PC, flush_en=>brch_en, stall_en=>stall, PC_out=>IF_ID_PC, out_op=>IF_ID_op, ra=>IF_ID_ra, 
             rb=>IF_ID_rb, rc=>IF_ID_rc, inst_out=>IF_ID_inst, misc=>IF_ID_misc, disp=>IF_ID_disp);
             
reg: entity work.register_file 
    port map(clk=>clk, rst=>ResetExecute, rd_index1=>IF_ID_rb, rd_index2=>IF_ID_rc, wr_index=>MEM_WB_ra, wr_data=>MEM_WB_data_out, 
             wr_enable=>MEM_WB_wr_en, rd_data1=>rd_data1, rd_data2=>rd_data2);
             
controller: entity work.Controller 
    port map(rst=>ResetExecute, op_in=>IF_ID_op, alu_op=>CON_alu_op, mem_op=>CON_mem_op, wb_op=>CON_wb_op);
    
hazard: entity work.HazardDetection 
    port map(clk=>clk, IF_ID_instr=>IF_ID_inst, ID_EX_instr=>ID_EX_inst_out, ID_EX_mem_op=>CON_mem_op, MEM_WB_en=>MEM_WB_wr_en, MEM_WB_ra=>MEM_WB_ra, stall=>stall);
    
ID_EX: entity work.ID_EX 
    port map(clk=>clk, rst=>ResetExecute, inst_in=>IF_ID_inst, op_in=>IF_ID_op, rd_data1=>rd_data1, rd_data2=>rd_data2, alu_in=>CON_alu_op, mem_in=>CON_mem_op, 
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
    port map(rst=>ResetExecute, A=>A, B=>B, OP=>ID_EX_alu_out, Y=>Y, Z=>Z, N=>N);
    
branch: entity work.Branch 
    port map(PC=>ID_EX_PC, inst_in=>ID_EX_inst_out, disp=>ID_EX_disp, Z=>Z, N=>N, ra=>ID_EX_RD1, old_PC=>old_PC, brch_addr=>brch_addr, brch_en=>brch_en);
    
EX_MEM: entity work.EX_MEM 
    port map(clk=>clk, rst=>ResetExecute, alu_result=>Y, mem_op=>ID_EX_mem_out, wb_op=>ID_EX_wb_out, inst_in=>ID_EX_inst_out, memA=>A, memB=>B, 
             mem_addra=>EX_MEM_mem_addra, mem_data=>EX_MEM_DATA, mem_en=>EX_MEM_mem_en, wr_en=>EX_MEM_wr_en, wb_out=>EX_MEM_wb_out, inst_out=>EX_MEM_inst_out, 
             alu_result_out=>EX_MEM_alu_result_out);
             
RAM: entity work.RAM 
    port map(clk=>clk, PC_in=>PC, rst_a=>ResetExecute, rst_b=>ResetExecute, enb_a=>EX_MEM_mem_en, enb_b=>EX_MEM_mem_en, write_a=>EX_MEM_wr_en, addr_a=>EX_MEM_mem_addra, 
             addr_b=>PC, din=>EX_MEM_DATA, dout_a=>RAM_data_outa, dout_b=>RAM_data_outb, PC_out=>RAM_PC);
             
MEM_WB: entity work.MEM_WB 
    port map(clk=>clk, rst=>ResetExecute, in_port_data=>IN_PORT, mem_data=>RAM_DATA_outa, data_in=>EX_MEM_alu_result_out, old_PC_in=>old_PC, inst_in=>EX_MEM_inst_out, wb_in=>EX_MEM_wb_out,
             wr_en=>MEM_WB_wr_en, data_out=>MEM_WB_data_out, ra=>MEM_WB_ra);

led_display_memory : led_display
port map (

        addr_write => x"FFF2",
        clk => clk,
        data_in => PC,
        en_write => '1',

        board_clock => board_clock,
        led_segments => led_segments,
        led_digits => led_digits
    );

    
console_display : console
    port map
    (
    --
    -- Stage 1 Fetch
    --
        s1_pc => RAM_PC,
        s1_inst => RAM_data_outb,
    
    --
    -- Stage 2 Decode
    --
    
        s2_pc => IF_ID_PC,
        s2_inst => IF_ID_inst,
    
        s2_reg_a => IF_ID_ra,
        s2_reg_b => IF_ID_rb,
        s2_reg_c => IF_ID_rc,
    
        s2_reg_a_data => x"0000",
        s2_reg_b_data => rd_data1,
        s2_reg_c_data => rd_data2,
        s2_immediate => x"0000",
    
    --
    -- Stage 3 Execute
    --
    
        s3_pc => ID_EX_PC,
        s3_inst => ID_EX_inst_out,
    
        s3_reg_a => ID_EX_inst_out(8 downto 6),
        s3_reg_b => ID_EX_inst_out(5 downto 3),
        s3_reg_c => ID_EX_inst_out(2 downto 0),
    
        s3_reg_a_data => x"0000",
        s3_reg_b_data => x"0000",
        s3_reg_c_data => x"0000",
        s3_immediate => x"0000",
    
        s3_r_wb => '0',
        s3_r_wb_data => x"0000",
    
        s3_br_wb => '0',
        s3_br_wb_address => x"0000",
    
        s3_mr_wr => CON_mem_op,
        s3_mr_wr_address => x"0000",
        s3_mr_wr_data => x"0000",
    
        s3_mr_rd => CON_mem_op,
        s3_mr_rd_address => x"0000",
    
    --
    -- Stage 4 Memory
    --
    
        s4_pc => x"0000",
        s4_inst => EX_MEM_inst_out,
        s4_reg_a => MEM_WB_ra,
        s4_r_wb => MEM_WB_wr_en,
        s4_r_wb_data => MEM_WB_data_out,
    
    --
    -- CPU registers
    --
    
        register_0 => reg_0,
        register_1 => reg_1,
        register_2 => reg_2,
        register_3 => reg_3,
        register_4 => reg_4,
        register_5 => reg_5,
        register_6 => reg_6,
        register_7 => reg_7,
    
        register_0_of => '0',
        register_1_of => '0',
        register_2_of => '0',
        register_3_of => '0',
        register_4_of => '0',
        register_5_of => '0',
        register_6_of => '0',
        register_7_of => '0',
    
    --
    -- CPU Flags
    --
        zero_flag => Z,
        negative_flag => N,
        overflow_flag => '0',
    
    --
    -- Debug screen enable
    --
        debug => debug_console,
    
    --
    -- Text console display memory access signals ( clk is the processor clock )
    --
    
        clk => '0',
        addr_write => x"0000",
        data_in => x"0000",
        en_write => '0',
    
    --
    -- Video related signals
    --
    
        board_clock => board_clock,
        h_sync_signal => h_sync_signal,
        v_sync_signal => v_sync_signal,
        vga_red => vga_red,
        vga_green => vga_green,
        vga_blue => vga_blue
    );



    process(clk) begin
        if (rising_edge(clk)) then
            case(MEM_WB_ra) is 
                when "000" =>
                    reg_0 <= MEM_WB_data_out;
                when "001" =>
                    reg_1 <= MEM_WB_data_out;
                when "010" =>
                    reg_2 <= MEM_WB_data_out;
                when "011" =>
                    reg_3 <= MEM_WB_data_out;
                when "100" =>
                    reg_4 <= MEM_WB_data_out;
                when "101" =>
                    reg_5 <= MEM_WB_data_out;
                when "110" =>
                    reg_6 <= MEM_WB_data_out;
                when "111" =>
                    reg_7 <= MEM_WB_data_out;
                when others => NULL;
            end case;
        end if;
    end process;
end Behavioral;
