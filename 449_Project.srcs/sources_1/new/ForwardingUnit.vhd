----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2025 11:52:12 AM
-- Design Name: 
-- Module Name: ForwardingUnit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;





entity ForwardingUnit is
    Port (  
            ID_EX_instr : in std_logic_vector(15 downto 0);     -- Source and second source spliced from Instruction
            EX_MEM_instr : in std_logic_vector(15 downto 0);    -- Destination Register specified in EX/MEM
            MEM_WB_rd : in std_logic_vector(2 downto 0);        -- Destination Register specified in MEM/WB
            EX_MEM_wb : in std_logic;                           -- Register wb enable from EX/MEM latch
            MEM_WB_wb : in std_logic;                           -- Register wb enable from MEM/WB latch
            ForwardA : out std_logic_vector(1 downto 0);        -- Output to ALU A port MUX(?)
            ForwardB : out std_logic_vector(1 downto 0)         -- Output to ALU B port MUX(?)
            );
end ForwardingUnit;

-- Hazards to check for
-- 1a. EX/MEM.RegisterRd = ID/EX.RegisterRs
-- 1b. EX/MEM.RegisterRd = ID/EX.RegisterRt
-- 2a. MEM/WB.RegisterRd = ID/EX.RegisterRs
-- 2b. MEM/WB.RegisterRd = ID/EX.RegisterRt


architecture Behavioral of ForwardingUnit is


begin
    process(ID_EX_instr, EX_MEM_instr, MEM_WB_rd, EX_MEM_wb, MEM_WB_wb)
    variable ID_EX_rs : std_logic_vector(2 downto 0);
    variable ID_EX_rt : std_logic_vector(2 downto 0);
    variable EX_MEM_rd : std_logic_vector(2 downto 0);
        begin
            if EX_MEM_instr(15 downto 9) = "0010010" then   -- Set LOADIMM dest register
                EX_MEM_rd := "111";
            else
                EX_MEM_rd := EX_MEM_instr(8 downto 6);      -- All other instruction dest register
            end if;
            
            if ID_EX_instr(15 downto 9) = "0010010" then    -- Set LOADIMM source registers
                ID_EX_rs := "111";
                ID_EX_rt := "111";  
            elsif ID_EX_instr(15 downto 9) = "0010001" then -- Set Store source registers
                ID_EX_rt := ID_EX_instr(8 downto 6);
                ID_EX_rs := ID_EX_instr(5 downto 3);
            elsif ID_EX_instr(15 downto 9) = "0010011" or ID_EX_instr(15 downto 9) = "0010000" then -- Set MOV and LOAD source registers
                ID_EX_rs := ID_EX_instr(8 downto 6);
                ID_EX_rt := ID_EX_instr(5 downto 3); 
            elsif ID_EX_instr(15 downto 9) = "0000111" or  ID_EX_instr(15 downto 9) = "0100000" or ID_EX_instr(15 downto 9) = "0000101" or ID_EX_instr(15 downto 9) = "0000110" then    -- Set TEST, OUT, SHL and SHR source registers
                ID_EX_rs := ID_EX_instr(8 downto 6);
                ID_EX_rt := ID_EX_instr(8 downto 6); 
            elsif ID_EX_instr(15 downto 9) = "1000011" or ID_EX_instr(15 downto 9) = "1000100" or ID_EX_instr(15 downto 9) = "1000101" or ID_EX_instr(15 downto 9) = "1000110" then -- Set B2 style source registers
                ID_EX_rs := ID_EX_instr(8 downto 6);
                ID_EX_rt := ID_EX_instr(8 downto 6);  
            else
                ID_EX_rs := ID_EX_instr(5 downto 3);
                ID_EX_rt := ID_EX_instr(2 downto 0);  
            end if;
            
            -- Forwarding for RS
            if (EX_MEM_wb = '1') and (EX_MEM_rd /= "000") and (EX_MEM_rd = ID_EX_rs) then
                ForwardA <= "10";
            elsif (MEM_WB_wb = '1') and (MEM_WB_rd /= "000")
            and not (EX_MEM_wb = '1' and EX_MEM_rd /= "000") 
            and EX_MEM_rd /= ID_EX_rs and MEM_WB_rd = ID_EX_rs then
                ForwardA <= "01";
            elsif (MEM_WB_wb = '1') and (MEM_WB_rd /= "000") and (MEM_WB_rd = ID_EX_rs) then
                ForwardA <= "01";
            else
                ForwardA <= "00";
            end if;
            
            
            -- Forwarding for RT
            if EX_MEM_wb = '1' and EX_MEM_rd /= "000" and EX_MEM_rd = ID_EX_rt then
                ForwardB <= "10";
           
            elsif (MEM_WB_wb = '1') and (MEM_WB_rd /= "000")
            and not (EX_MEM_wb = '1' and EX_MEM_rd /= "000") 
            and EX_MEM_rd /= ID_EX_rt and MEM_WB_rd = ID_EX_rt then  
                ForwardB <= "01";
                
            elsif (MEM_WB_wb = '1') and (MEM_WB_rd /= "000") and (MEM_WB_rd = ID_EX_rt) then
                   ForwardB <= "01";
            else
                ForwardB <= "00";
            end if;
            
            

    end process;
-- Stall needed for when instruction tries to read register following a load instruction that write to same register.
-- This prob belongs in controller rather than the ForwardingUnit
end Behavioral;
