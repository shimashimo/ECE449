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
            data_in: in STD_LOGIC_VECTOR(15 downto 0);
            inst_in: in STD_LOGIC_VECTOR(15 downto 0);
            wb_in: in STD_LOGIC;
            wr_en: out STD_LOGIC;
            data_out: out STD_LOGIC_VECTOR(15 downto 0);
            ra: out STD_LOGIC_VECTOR(2 downto 0)
            );
end MEM_WB;

architecture Behavioral of MEM_WB is

begin
    process(clk) begin
        if clk = '1' then
        
            if rst = '1' then
                wr_en <= '0';
                data_out <= (others => '0');
                ra <= (others => '0');
            end if;
            
            if inst_in(15 downto 9) = "1000110" then 
                ra <= "111";
            else 
                ra <= inst_in(8 downto 6);
            end if;
            
            if inst_in(15 downto 9) = "0100001" then
                data_out <= "0000000000" & inst_in(5 downto 0);
            else
                data_out <= data_in;
            end if;            
            wr_en <= wb_in;
        end if;
    end process;

end Behavioral;
