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
          inst: in STD_LOGIC_VECTOR(15 downto 0);       -- Propagete Instruction
          PC_in: in STD_LOGIC_VECTOR(15 downto 0);
          flush_en: in STD_LOGIC;   -- Flush PC and Instruc
          stall_en: in STD_LOGIC;
          PC_out: out STD_LOGIC_VECTOR(15 downto 0);
          out_op: out STD_LOGIC_VECTOR(6 downto 0);
          ra: out STD_LOGIC_VECTOR(2 downto 0);
          rb: out STD_LOGIC_VECTOR(2 downto 0);
          rc: out STD_LOGIC_VECTOR(2 downto 0);
          inst_out: out STD_LOGIC_VECTOR(15 downto 0);  -- Propagete Instruction
          misc: out STD_LOGIC_VECTOR(8 downto 0);
          disp: out STD_LOGIC_VECTOR(8 downto 0)
          );
end IF_ID;

architecture Behavioral of IF_ID is
begin
    process (clk) begin
        if(rising_edge(clk)) then  -- Latching?
            if(rst = '1') then  -- Do we want reset to be on next clock edge? Only when clock == 1? Or reset immediately?
                        PC_out <= (others => '0');
                        out_op <= (others => '0');
                        ra <= "000";
                        rb <= "000";
                        rc <= "000";
                        inst_out <= (others => '0');
                        misc <= (others => '0');
                        disp <= (others => '0');
            else
                if flush_en = '1' then
                    PC_out <= PC_in;
                    inst_out <= (others => '0');
                    out_op <= (others => '0');
                    -- Floating values - (latched values - previous values will propagate through?)
                elsif stall_en = '1' then
                    -- Do Nothing? Want to keep values so
--                    PC_out <= PC_in;
--                    inst_out <= inst;
                else
                    PC_out <= PC_in;
                    inst_out <= inst;
                    case inst(15 downto 9) is
                        when "0000001" | "0000010" | "0000011" | "0000100" =>
                            out_op <= inst(15 downto 9);    --A1 
                            ra <= inst(8 downto 6);
                            rb <= inst(5 downto 3);
                            rc <= inst(2 downto 0);
                            misc <= (others => '0');
                            disp <= (others => '0');
                        when "0000101" | "0000110" =>       --A2
                            out_op <= inst(15 downto 9);
                            ra <= inst(8 downto 6);
                            rb <= inst(8 downto 6);
                            rc <= (others => '0');
                            misc <= "000" & inst(5 downto 0) ;
                            disp <= (others => '0');
                        when "0000111" =>   --A3
                            out_op <= inst(15 downto 9);
                            ra <= inst(8 downto 6);
                            rb <= inst(8 downto 6);
                            rc <= (others => '0');
                            misc <= "000" & inst(5 downto 0);
                            disp <= (others => '0');
                        when "0100000" => -- out
                            out_op <= inst(15 downto 9);
                            rb <= inst(8 downto 6);
                        when "0100001" => -- in
                            out_op <= inst(15 downto 9);
                            ra <= inst(8 downto 6);
                        when "1000000" | "1000001" | "1000010" =>   --BRR, BRR.N, BRR.Z
                            out_op <= inst(15 downto 9);
                            ra <= "000";
                            rb <= "000";
                            rc <= (others => '0');
                            misc <= (others => '0');
                            disp <= inst(8 downto 0);
                        when "1000011" | "1000100" | "1000101" | "1000110" => --BR, BR.N, BR.Z, BR.SUB
                            out_op <= inst(15 downto 9);
                            ra <= inst(8 downto 6);
                            rb <= inst(8 downto 6);
                            rc <= (others => '0');
                            misc <= (others => '0');
                            disp <= "000" & inst(5 downto 0);
                        when "0010000" | "0010011" => -- Load, Move
                            out_op <= inst(15 downto 9);
                            rb <= inst(8 downto 6); --ra = dest
                            rc <= inst(5 downto 3); --rb = source
                        when "0010001" => -- Store
                            out_op <= inst(15 downto 9);  
                            rc <= inst(8 downto 6); --rb = dest
                            rb <= inst(5 downto 3); --ra = source
                        when "0010010" => -- LoadIMMM
                            out_op <= inst(15 downto 9);
                            rb <= "111"; --rb = memA
                        when others => 
                            out_op <= "0000000";    -- NOP
                            ra   <= (others => '0');
                            rb   <= (others => '0');
                            rc   <= (others => '0');
                            misc <= (others => '0');
                            disp <= (others => '0');
                    end case;
                end if;
            end if;
        end if; 

        
    end process;
end Behavioral;


