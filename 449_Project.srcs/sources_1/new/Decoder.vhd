----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 03:24:55 PM
-- Design Name: 
-- Module Name: Decoder - Behavioral
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

entity IF_ID is
    Port ( 
          clk: in STD_LOGIC;
          rst: in STD_LOGIC;
          inst: in STD_LOGIC_VECTOR(15 downto 0);
          out_op: out STD_LOGIC_VECTOR(5 downto 0);
          ra: out STD_LOGIC_VECTOR(2 downto 0);
          rb: out STD_LOGIC_VECTOR(2 downto 0);
          rc: out STD_LOGIC_VECTOR(2 downto 0);
          inst_out: out STD_LOGIC_VECTOR(15 downto 0);
          misc: out STD_LOGIC_VECTOR(8 downto 0)
                    );
end IF_ID;

architecture Behavioral of IF_ID is
begin
    process (clk) begin
        if(clk = '1') then  -- Latching?
        
            case inst(15 downto 9) is
                when "000001" | "000010" | "000011" | "000100" =>
                    out_op <= inst(15 downto 9);
                    ra <= inst(8 downto 6);
                    rb <= inst(5 downto 3);
                    rc <= inst(2 downto 0);
                when "000101" | "000110" => 
                    out_op <= inst(15 downto 9);
                    ra <= inst(8 downto 6);
                    rb <= inst(8 downto 6);
                    misc <= "000" & inst(5 downto 0) ;
                when others => 
                    out_op <= "000000";
            end case;
            
            inst_out <= inst;
            
        end if; 
        if(rst = '1') then  -- Do we want reset to be on next clock edge? Only when clock == 1? Or reset immediately?
            ra <= "000";
            rb <= "000";
            rc <= "000";
            misc <= (others => '0');
        end if;
        
    end process;
end Behavioral;


