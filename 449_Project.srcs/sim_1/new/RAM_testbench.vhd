library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RAM_testbench is
--  Port ( );
end RAM_testbench;

architecture Behavioral of RAM_testbench is
    signal clk: STD_LOGIC;
    signal rst_a: STD_LOGIC;
    signal rst_b: STD_LOGIC;
    signal enb_a: STD_LOGIC;
    signal enb_b: STD_LOGIC;
    signal write_a: STD_LOGIC_VECTOR(0 downto 0);
    signal addr_a: STD_LOGIC_VECTOR(15 downto 0);   -- Address for A
    signal addr_b: STD_LOGIC_VECTOR(15 downto 0);   -- Address for B
    signal din: STD_LOGIC_VECTOR(15 downto 0);      -- Data in for A, B port doesn't do write operations
    signal dout_a: STD_LOGIC_VECTOR(15 downto 0);   -- Data out for A
    signal dout_b: STD_LOGIC_VECTOR(15 downto 0);   -- Data out for B
begin

    RAM_testbench: entity work.RAM port map(clk, rst_a, rst_b, enb_a, enb_b, write_a, addr_a, addr_b, din, dout_a, dout_b);
    
    process begin
        clk <= '0';
        wait for 10 us;
        clk <= '1';
        wait for 10 us;
    end process;
    
    process begin
         rst_a <= '1';  -- Reset to start with initial values of 0
         rst_b <= '1';
         enb_a <= '0';  
         enb_b <= '0';
         WAIT UNTIL (clk = '0' AND clk'event);
         WAIT UNTIL (clk = '1' AND clk'event);
         rst_a <= '0';  
         rst_b <= '0';
         WAIT UNTIL (clk = '1' AND clk'event); -- HERE WRITE BY PORT A AND READ FROM PORT B
         enb_a <= '1';  -- Enable read or write operations
         enb_b <= '1';  -- Enable read or write operations
         write_a <= (0 => '1', others => '0');    -- Write enable bit is a vector? - for word-wise writing
         addr_a <= x"0000"; -- Write to address 0x0000
         din <= x"FFFF";    -- Data to write in port A
         WAIT UNTIL (clk = '1' AND clk'event); -- HERE READ FROM PORT A
         enb_a <= '1';      
         addr_a <= x"0004"; -- When write_a is not enabled, its a read operation then?
         addr_b <= x"0004"; -- Read from address 0x0001
         WAIT;
    end process;
end Behavioral;
