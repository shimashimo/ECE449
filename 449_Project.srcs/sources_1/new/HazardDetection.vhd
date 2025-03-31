----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2025 11:28:21 PM
-- Design Name: 
-- Module Name: HazardDetection - Behavioral
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

entity HazardDetection is
  Port ( 
        clk: in std_logic;
        IF_ID_instr: in std_logic_vector(15 downto 0);
        ID_EX_instr: in std_logic_vector(15 downto 0);
        ID_EX_mem_op: in std_logic;
        MEM_WB_en: in std_logic;
        EX_MEM_ra : in std_logic_vector(15 downto 0);
        stall: out std_logic     -- Make IF_ID register into nop
        --PC_stall: out std_logic;        -- Program Counter Stall Signal
        --ctr_stall: out std_logic        -- Controller Stall Signal
  );
end HazardDetection;

architecture Behavioral of HazardDetection is

begin
    process(IF_ID_instr, ID_EX_instr)
    variable IF_ID_rs : std_logic_vector(2 downto 0);
    variable IF_ID_rt : std_logic_vector(2 downto 0);
    variable ID_EX_rt : std_logic_vector(2 downto 0);
    variable EX_MEM_rd: std_logic_vector(2 downto 0);
        begin
            if IF_ID_instr(15 downto 9) = "0000111" or  IF_ID_instr(15 downto 9) = "0100000" then
                IF_ID_rs := IF_ID_instr(8 downto 6);
                IF_ID_rt := IF_ID_instr(8 downto 6);
            elsif IF_ID_instr(15 downto 9) = "0010001" then
                IF_ID_rt := IF_ID_instr(8 downto 6);
                IF_ID_rs := IF_ID_instr(5 downto 3);
            elsif IF_ID_instr(15 downto 9) = "0010011" or IF_ID_instr(15 downto 9) = "0010000" then
                IF_ID_rs := IF_ID_instr(8 downto 6);
                IF_ID_rt := IF_ID_instr(5 downto 3);
            else 
                IF_ID_rs := IF_ID_instr(5 downto 3);
                IF_ID_rt := IF_ID_instr(2 downto 0);
            end if;
            EX_MEM_rd := EX_MEM_ra(8 downto 6);
            ID_EX_rt := ID_EX_instr(8 downto 6); -- Want rb index... i think
            if ((ID_EX_instr(15 downto 9) = "0010000") and         -- Stall when current instruction is load
               ((ID_EX_rt = IF_ID_rs) or         -- and the destination register of the load is
                (ID_EX_rt = IF_ID_rt))) then     -- one of the source registers in the next instruction
                                                 -- Then Stall
                stall <= '1';
            elsif ((ID_EX_instr(15 downto 9) = "0010010") and         -- Stall when current instruction is load imm
                  (("111" = IF_ID_rs) or         -- and the destination register of the load is
                   ("111" = IF_ID_rt))) or 
                   (ID_EX_instr(15 downto 9) = "0010010" and 
                    IF_ID_instr(15 downto 9) = "0010010") then     -- one of the source registers in the next instruction
                stall <= '1';
            elsif ((ID_EX_instr(15 downto 9) = "0010011") and         -- Stall when current instruction is mov
                   ((ID_EX_rt = IF_ID_rs) or         -- and the destination register of the load is
                    (ID_EX_rt = IF_ID_rt))) then     -- one of the source registers in the next instruction
                                                                     -- Then Stall                                       
                stall <= '1'; 
--            elsif MEM_WB_en = '1' 
--                and (MEM_WB_ra /= IF_ID_rt)
--                  and (MEM_WB_ra /= IF_ID_rs) then       
--                stall <= '1';
            elsif (ID_EX_instr(15 downto 9) = "0100001")  and -- Stall when current instruction is in
                    ((ID_EX_instr(8 downto 6) = IF_ID_rs) or         -- and the destination register of the load is 
                     (ID_EX_instr(8 downto 6) = IF_ID_rt)) then  
            
                stall <= '1';
            elsif (ID_EX_instr(15 downto 9) = "0010010") and ((EX_MEM_rd = IF_ID_rs) or (EX_MEM_rd = IF_ID_rt)) then
                stall <= '1';
            else
                stall <= '0';
            end if;
    end process;
end Behavioral;
