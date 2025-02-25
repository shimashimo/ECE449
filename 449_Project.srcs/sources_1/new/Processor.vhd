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
ALU : entity work.ALU port map(A->A, B->B, Y->Y);
Reg : entity work.register_file port map(rd_index1->rd_index1, rd_index2->rd_index2, rd_data1->rd_data1, rd_data2->rd_data2);
RAM : entity work.RAM port map(addrb->addrb, doutb->doutb);
PC : entity work.Program_Counter port map(PC_In->Input, PC_Out->Output);

entity Processor is

    Port ( 
--           n_port : in STD_LOGIC;
           clk : in STD_LOGIC;
--           Reset_Exec : in STD_LOGIC;
--           Reset_Load : in STD_LOGIC;
--           out_port : out STD_LOGIC);
end Processor;

signal address: STD_LOGIC_VECTOR(31 downto 0);
signal op: STD_LOGIC_VECTOR(5 downto 0);
signal ra: STD_LOGIC_VECTOR(2 downto 0);
signal rb: STD_LOGIC_VECTOR(2 downto 0);
signal rc: STD_LOGIC_VECTOR(2 downto 0);
signal op1: STD_LOGIC_VECTOR(15 downto 0);
signal op2: STD_LOGIC_VECTOR(15 downto 0);
signal alu_result: STD_LOGIC_VECTOR(15 downto 0);



architecture Behavioral of Processor is
begin
    process(clk) is 
    begin
        if rising_edge(clk) then    --fetch
            address<-PC_Output;
        if falling_edge(clk) then
            addrb<-address
        if rising_edge(clk) then         --decode
            op<-doutb(15 downto 9);
            ra<-doutb(8 downto 6);
            rb<-doutb(5 downto 3);
            rc<-doutb(2 downto 0);
        if falling_edge(clk) then
            rd_index1<-rb;
            rd_index2<-rc;
        if rising_edge(clk) then    --execution
            A<-op1;
            B<-op2;
        if falling_edge(clk) then
            alu_result<-Y;
            
            
            
            

end Behavioral;
