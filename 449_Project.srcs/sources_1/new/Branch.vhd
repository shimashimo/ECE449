----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 03:05:26 PM
-- Design Name: 
-- Module Name: Branch - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Branch is
    Port(
        PC: in STD_LOGIC_VECTOR(15 downto 0);
        inst_in: in STD_LOGIC_VECTOR(15 downto 0);
        disp: in STD_LOGIC_VECTOR(8 downto 0);
        Z: in STD_LOGIC;
        N: in STD_LOGIC;
        ra: in STD_LOGIC_VECTOR(15 downto 0);
        old_PC: out STD_LOGIC_VECTOR(15 downto 0);
        brch_addr: out STD_LOGIC_VECTOR(15 downto 0);
        brch_en: out STD_LOGIC
        );
end Branch;

architecture Behavioral of Branch is

begin
    process (inst_in, disp, Z, N) 
    variable p1: STD_LOGIC_VECTOR(17 downto 0);
    begin
        case(inst_in(15 downto 9)) is 
            when "1000000" => -- BRR
                p1 := std_logic_vector(signed(PC)+2*signed(disp));
                brch_addr <= p1(15 downto 0);
                brch_en <= '1';
            when "1000001" => --BRR.N
                if N = '1' then
                    p1 := std_logic_vector(signed(PC)+2*signed(disp));
                    brch_addr <= p1(15 downto 0);
                    brch_en <= '1';
                else 
                    brch_addr <= (others => '0');
                    brch_en <= '0';
                end if;
            when "1000010" => --BRR.Z
                if Z = '1' then
                    p1 := std_logic_vector(signed(PC)+2*signed(disp));
                    brch_addr <= p1(15 downto 0);
                    brch_en <= '1';
                else 
                    brch_addr <= (others => '0');
                    brch_en <= '0';
                end if;
            when "1000011" => --BR
                p1 := std_logic_vector(signed(ra)+2*signed(disp));
                brch_addr <= p1(15 downto 0);
                brch_en <= '1';
            when "1000100" => --BR.N
                if N = '1' then
                    p1 := std_logic_vector(signed(ra)+2*signed(disp));
                    brch_addr <= p1(15 downto 0);
                    brch_en <= '1';
                else 
                    brch_addr <= (others => '0');
                    brch_en <= '0';
                end if;
            when "1000101" => --BR.Z
                if Z = '1' then
                    p1 := std_logic_vector(signed(ra)+2*signed(disp));
                    brch_addr <= p1(15 downto 0);
                    brch_en <= '1';
                else 
                    brch_addr <= (others => '0');
                    brch_en <= '0';
                end if;     
            when "1000110" => -- BR.SUB
                p1 := std_logic_vector(signed(ra)+2*signed(disp));
                brch_addr <= p1(15 downto 0);
                brch_en <= '1';
                old_PC <= PC;
            when others => 
                old_PC <= (others => '0');
                brch_addr <= (others => '0');
                brch_en <= '0';
        end case;
    end process;

end Behavioral;
