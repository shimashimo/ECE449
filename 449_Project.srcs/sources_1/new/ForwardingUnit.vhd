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
            ID_EX_rs : in std_logic_vector(2 downto 0);    -- Source Register from Instruction
            ID_EX_rt : in std_logic_vector(2 downto 0);    -- Second Source register from Instruction
            EX_MEM_rd : in std_logic_vector(2 downto 0);   -- Destination Register specified in EX/MEM
            MEM_WB_rd : in std_logic_vector(2 downto 0);   -- Destination Register specified in MEM/WB
            ForwardA : out std_logic_vector(1 downto 0);  -- Output to ALU A port MUX(?)
            ForwardB : out std_logic_vector(1 downto 0)   -- Output to ALU B port MUX(?)
            );
end ForwardingUnit;
-- Hazards to check for
-- 1a. EX/MEM.RegisterRd = ID/EX.RegisterRs
-- 1b. EX/MEM.RegisterRd = ID/EX.RegisterRt
-- 2a. MEM/WB.RegisterRd = ID/EX.RegisterRs
-- 2b. MEM/WB.RegisterRd = ID/EX.RegisterRt

architecture Behavioral of ForwardingUnit is

begin

-- EX hazard
if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd ? 0)
and (EX/MEM.RegisterRd = ID/EX.RegisterRs)) ForwardA = 10
if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd ? 0)
and (EX/MEM.RegisterRd = ID/EX.RegisterRt)) ForwardB = 10

-- mem hazard
if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd ? 0)
and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ? 0)
and (EX/MEM.RegisterRd ? ID/EX.RegisterRs))
and (MEM/WB.RegisterRd = ID/EX.RegisterRs)) ForwardA = 01
if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd ? 0)
and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ? 0)
and (EX/MEM.RegisterRd ? ID/EX.RegisterRt))
and (MEM/WB.RegisterRd = ID/EX.RegisterRt)) ForwardB = 01

-- Stall needed for when instruction tries to read register following a load instruction that write to same register.
-- This prob belongs in controller rather than the ForwardingUnit
end Behavioral;
