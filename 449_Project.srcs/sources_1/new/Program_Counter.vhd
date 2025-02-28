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
            brch_addr: in STD_LOGIC_VECTOR(15 downto 0);
            brch_en: in STD_LOGIC;
            rst: in STD_LOGIC;
            clk: in STD_LOGIC;
            stall: in STD_LOGIC;
            PC : out STD_LOGIC_VECTOR(15 downto 0));
end Program_Counter;

architecture Behavioral of Program_Counter is

signal prog_ctr: STD_LOGIC_VECTOR(15 downto 0);

begin
    process (clk) begin
        if (rising_edge(clk)) then
            if (rst = '1') then 
                prog_ctr <= x"0000";
            end if;

            if (stall = 1) then
                prog_ctr <= prog_ctr;
            end if;

            if (brch_en = 1) then
                prog_ctr <= brch_addr;
            else
                prog_ctr <= std_logic_vector(signed(prog_ctr) + 2);
            end if;
    end process;
            
    PC <= prog_ctr;                

end Behavioral;
