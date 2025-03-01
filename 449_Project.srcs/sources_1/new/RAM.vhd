----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 04:21:35 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

Library xpm;
use xpm.vcomponents.all;


entity RAM is
	Port (
		clk: in STD_LOGIC;
		rst_a: in STD_LOGIC;
		rst_b: in STD_LOGIC;
		enb_a: in STD_LOGIC;
		enb_b: in STD_LOGIC;
		write_a: in STD_LOGIC_VECTOR(15 downto 0);
		addr_a: in STD_LOGIC_VECTOR(15 downto 0);
		addr_b: in STD_LOGIC_VECTOR(15 downto 0);
		din: in STD_LOGIC_VECTOR(15 downto 0);
		dout_a: out STD_LOGIC_VECTOR(15 downto 0);
		dout_b: out STD_LOGIC_VECTOR(15 downto 0));
end RAM;

architecture Behavioural of RAM is

begin
	-- xpm_memory_dpdistram: Dual Port Distributed RAM
	-- Xilinx Parameterized Macro, version 2018.3
	xpm_memory_dpdistram_inst : xpm_memory_dpdistram
	generic map (
		ADDR_WIDTH_A => 16, -- DECIMAL
		ADDR_WIDTH_B => 16, -- DECIMAL
		BYTE_WRITE_WIDTH_A => 16, -- DECIMAL
		CLOCKING_MODE => "common_clock", -- String
		MEMORY_INIT_FILE => "none", -- String
		MEMORY_INIT_PARAM => "0", -- String
		MEMORY_OPTIMIZATION => "true", -- String
		MEMORY_SIZE => 8192, -- DECIMAL
		MESSAGE_CONTROL => 0, -- DECIMAL
		READ_DATA_WIDTH_A => 16, -- DECIMAL
		READ_DATA_WIDTH_B => 16, -- DECIMAL
		READ_LATENCY_A => 2, -- DECIMAL
		READ_LATENCY_B => 2, -- DECIMAL
		READ_RESET_VALUE_A => "0", -- String
		READ_RESET_VALUE_B => "0", -- String
		USE_EMBEDDED_CONSTRAINT => 0, -- DECIMAL
		USE_MEM_INIT => 1, -- DECIMAL
		WRITE_DATA_WIDTH_A => 16 -- DECIMAL
	)
	port map (
	douta => dout_a, 	-- READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
	doutb => dout_b, 	-- READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
	addra => addr_a, 	-- ADDR_WIDTH_A-bit input: Address for port A write and read operations.
	addrb => addr_b, 	-- ADDR_WIDTH_B-bit input: Address for port B write and read operations.
	clka => clk, 		-- 1-bit input: Clock signal for port A. Also clocks port B when parameter
						-- CLOCKING_MODE is "common_clock".
	clkb => clk, 		-- 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
	-- "independent_clock". Unused when parameter CLOCKING_MODE is "common_clock".
	dina => din, 		-- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
	ena => enb_a, 		-- 1-bit input: Memory enable signal for port A. Must be high on clock cycles when read
						-- or write operations are initiated. Pipelined internally.
	enb => enb_b, 		-- 1-bit input: Memory enable signal for port B. Must be high on clock cycles when read
						-- or write operations are initiated. Pipelined internally.
	regcea => '1', 	-- 1-bit input: Clock Enable for the last register stage on the output data path.
	regceb => '1', 	-- 1-bit input: Do not change from the provided value.
	rsta => rst_a, 		-- 1-bit input: Reset signal for the final port A output register stage. Synchronously
						-- resets output port douta to the value specified by parameter READ_RESET_VALUE_A.
	rstb => rst_b, 		-- 1-bit input: Reset signal for the final port B output register stage. Synchronously
						-- resets output port doutb to the value specified by parameter READ_RESET_VALUE_B.
	wea => write_a 			-- WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input data port dina. 1
						-- bit wide when word-wide writes are used. In byte-wide write configurations, each bit
						-- controls the writing one byte of dina to address addra. For example, to
						-- synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea
						-- would be 4'b0010.
	);
	-- End of xpm_memory_dpdistram_inst instantiation

end Behavioural;
