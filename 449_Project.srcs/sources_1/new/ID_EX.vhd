----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2025 04:16:17 PM
-- Design Name: 
-- Module Name: ID_EX - Behavioral
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

entity ID_EX is
  Port ( 
        clk: in STD_LOGIC;
        rst: in STD_LOGIC;
        inst_in: in STD_LOGIC_VECTOR(15 downto 0);  -- Propagete Instruction
        op_in: in STD_LOGIC_VECTOR(6 downto 0);
        rd_data1: in STD_LOGIC_VECTOR(15 downto 0);
        rd_data2: in STD_LOGIC_VECTOR(15 downto 0);
        alu_in: in STD_LOGIC_VECTOR(2 downto 0);
        mem_in: in STD_LOGIC;
        wb_in: in STD_LOGIC;
        PC_in: in STD_LOGIC_VECTOR(15 downto 0);
        brch_en: in STD_LOGIC;
        disp: in STD_LOGIC_VECTOR(8 downto 0);
        disp_out: out STD_LOGIC_VECTOR(8 downto 0);
        PC_out: out STD_LOGIC_VECTOR(15 downto 0);
        alu_out: out STD_LOGIC_VECTOR(2 downto 0);
        mem_out: out STD_LOGIC;
        wb_out: out STD_LOGIC;
        RD1: out STD_LOGIC_VECTOR(15 downto 0);
        RD2: out STD_LOGIC_VECTOR(15 downto 0);
        inst_out: out STD_LOGIC_VECTOR(15 downto 0) -- Propagete Instruction
  );
end ID_EX;

architecture Behavioral of ID_EX is

begin
process (clk) begin
    if(rising_edge(clk)) then  -- Latching?
        if(rst = '1') then
            disp_out <= (others => '0');
            PC_out <= (others => '0');
            alu_out <= "000";
            mem_out <= '0';
            wb_out <= '0';
            RD1 <= (others => '0');
            RD2 <= (others => '0');
            inst_out <= (others => '0');
        else
            if alu_in /= "000" then
                alu_out <= alu_in;
                RD1 <= rd_data1;
                RD2 <= rd_data2;
            end if;
            
            if mem_in = '1' then
                mem_out <= mem_in;
            end if;
            
            if wb_in = '1' then
                wb_out <= wb_in;
            end if;
            
            disp_out <= disp;
            inst_out <= inst_in; 
            PC_out <= PC_in;
        end if;
    end if;

end process;

end Behavioral;
