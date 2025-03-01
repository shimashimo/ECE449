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
--            in_port: in STD_LOGIC_VECTOR(15 downto 0);
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            n: out STD_LOGIC;
            z: out STD_LOGIC;
--            rst_ex: in STD_LOGIC;
--            rst_ld: in STD_LOGIC;
            out_port: out STD_LOGIC_VECTOR(15 downto 0));
end Processor;

architecture Behavioral of Processor is
signal fetch: STD_LOGIC;
signal decode: STD_LOGIC;
signal execute: STD_LOGIC;
signal mem_acces: STD_LOGIC;
signal wr_back: STD_LOGIC;
signal address: STD_LOGIC_VECTOR(15 downto 0);
signal op: STD_LOGIC_VECTOR(5 downto 0);
signal addr_ra: STD_LOGIC_VECTOR(2 downto 0);
signal addr_rb: STD_LOGIC_VECTOR(2 downto 0);
signal addr_rc: STD_LOGIC_VECTOR(2 downto 0);
signal ra:  STD_LOGIC_VECTOR(15 downto 0);
signal rb:  STD_LOGIC_VECTOR(15 downto 0);
signal rc:  STD_LOGIC_VECTOR(15 downto 0);
signal op1: STD_LOGIC_VECTOR(15 downto 0);  -- rename to instr?
signal op2: STD_LOGIC_VECTOR(15 downto 0);
signal alu_result: STD_LOGIC_VECTOR(15 downto 0);

ALU : entity work.ALU port map(clk, rst, A, B, OP, Y, Z, N);
Reg : entity work.register_file port map(rst, clk, rd_index1, rd_index2, rd_data1, rd_data2, wr_index, wr_data, wr_enable);
RAM : entity work.RAM port map(clk, rst_a, rst_b, enb_a, enb_b, write_a, addr_a, addr_b, din, dout_a, dout_b);
PC : entity work.Program_Counter port map(brch_addr, brch_en, rst, clk, stall, PC);

begin
    process(clk) begin
        enb_a <= '1';   --enable port a RAM
        wr_enable <= '0';
        brch_en <= '0';
        fetch <= '1';

        -- fetch
        if falling_edge(clk) then
            --fetch
            if fetch = '1' then
                addr_a <= address;
                op1 <= dout_a;

                fetch <= '0';
                decode <= '1';
            end if;
        
            --decode
            if decode = '1' then
                op <= op1(15 downto 9);
                addr_ra <= op1(8 downto 6);
                addr_rb <= op1(5 downto 3);
                addr_rc <= op1(2 downto 0);

                decode <= '0';
                execute <= '1';
            end if;

            --execute
            if execute = '1' then
                OP <= op;
                A <= rb;
                B <= rc;
                ra <= Y;

                execute = '0';
                mem_acces = '1';
            end if;

            --memory access
            -- not implemented
            if mem_acces = '1' then
                mem_acces = '0';
                wr_back = '1';
            end if;

            --writeback
            if wr_back = '1' then
                wr_enable <= '1';
                wr_index <= addr_a;
                wr_data <= ra;
            end if;

        wr_back = '0';
    end process;
end Behavioral;
