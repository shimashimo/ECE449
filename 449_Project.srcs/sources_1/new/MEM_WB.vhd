----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2025 01:51:31 PM
-- Design Name: 
-- Module Name: MEM_WB - Behavioral
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

entity MEM_WB is
    Port (
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            in_port_data: in STD_LOGIC_VECTOR(15 downto 6);
            mem_data: in STD_LOGIC_VECTOR(15 downto 0);
            data_in: in STD_LOGIC_VECTOR(15 downto 0);
            old_PC_in: in STD_LOGIC_VECTOR(15 downto 0);
            inst_in: in STD_LOGIC_VECTOR(15 downto 0);
            wb_in: in STD_LOGIC;
            wr_en: out STD_LOGIC;
            data_out: out STD_LOGIC_VECTOR(15 downto 0);
            ra: out STD_LOGIC_VECTOR(2 downto 0);
            outport: out STD_LOGIC_VECTOR(0 downto 0)
            );
end MEM_WB;

architecture Behavioral of MEM_WB is

begin
    process(clk) begin
        if rising_edge(clk) then
        
            outport <= (others => '0');
            
            if rst = '1' then
                wr_en <= '0';
                data_out <= (others => '0');
                ra <= (others => '0');
            else
                -- Sets data_out
                case inst_in(15 downto 9) is
--                    when "0100001" =>    -- Instr = IN - Take input from port and put into R[ra]
--                        data_out <= "0000000000" & inst_in(5 downto 0);
--                        ra <= inst_in(8 downto 6);
                    when "0010010" => -- LOADIMM
                        ra <= "111";
                        if inst_in(8) = '1' then
                            data_out <= inst_in(7 downto 0) & data_in(7 downto 0);
                        else
                            data_out <= data_in(15 downto 8) & inst_in(7 downto 0);
                        end if;
                    when "0010000" => --Load
                        data_out <= mem_data;
                        ra <= inst_in(8 downto 6);
                    when "1000110" => 
                        ra <= "111";
                        data_out <= old_PC_in;
                    when "0100000" => --out
                        outport <= data_in(0 downto 0);
                    when "0100001" => --in
                        ra <= inst_in(8 downto 6);
                        data_out <= in_port_data(15 downto 6) & "000000";
                    when others =>
                        data_out <= data_in;
                        ra <= inst_in(8 downto 6);
                end case;
                
                wr_en <= wb_in;
           end if;
        end if;
    end process;

end Behavioral;
