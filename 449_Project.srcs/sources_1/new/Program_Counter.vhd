----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 05:20:16 PM
-- Design Name: 
-- Module Name: Program_Counter - Behavioral
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


entity Program_Counter is
    Port ( 
            clk: in STD_LOGIC;
            rst_ld: in STD_LOGIC;                                       -- BTN T18
            rst_ex: in STD_LOGIC;                                       -- BTN U18
            brch_addr: in STD_LOGIC_VECTOR(15 downto 0);                -- Address from Branch Unit
            brch_en: in STD_LOGIC;                                      -- Branch signal
            stall: in STD_LOGIC;                                        -- Stall 
            PC: out STD_LOGIC_VECTOR(15 downto 0) := (others => '0'));  -- Instruction address for IF/ID
end Program_Counter;

architecture Behavioral of Program_Counter is
begin
    process (clk) 
    variable prog_ctr: STD_LOGIC_VECTOR(15 downto 0);
        begin
    
        if (rising_edge(clk)) then
            if (rst_ld = '1') then 
                prog_ctr := x"0002";
            
            elsif (rst_ex = '1') then 
                prog_ctr := x"0000";
            
            elsif (stall = '1') then
                prog_ctr := prog_ctr;
            
            elsif (brch_en = '1') then
                prog_ctr := brch_addr;
                            
            else
                prog_ctr := std_logic_vector(signed(prog_ctr) + 2);
            end if;
            PC <= prog_ctr;  
        end if;
        
    end process;                       

end Behavioral;
