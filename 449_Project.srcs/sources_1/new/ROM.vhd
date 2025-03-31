----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 04:25:04 PM
-- Design Name: 
-- Module Name: ROM - Behavioral
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


entity ROM is
    Port (
        clk: in STD_LOGIC;
        rst: in STD_LOGIC;
        enb: in STD_LOGIC;
        addr: in STD_LOGIC_VECTOR(15 downto 0);
        data_out: out STD_LOGIC_VECTOR(15 downto 0));
end ROM;

architecture Behavioral of ROM is

begin
    -- xpm_memory_sprom: Single Port ROM
    -- Xilinx Parameterized Macro, version 2018.3
    xpm_memory_sprom_inst : xpm_memory_sprom
    generic map (
        ADDR_WIDTH_A => 16, -- DECIMAL
        AUTO_SLEEP_TIME => 0, -- DECIMAL
        ECC_MODE => "no_ecc", -- String
        MEMORY_INIT_FILE => "bootloader.mem", -- String
        MEMORY_INIT_PARAM => "", -- String
        MEMORY_OPTIMIZATION => "true", -- String
        MEMORY_PRIMITIVE => "auto", -- String
        MEMORY_SIZE => 8192, -- DECIMAL
        MESSAGE_CONTROL => 0, -- DECIMAL
        READ_DATA_WIDTH_A => 16, -- DECIMAL
        READ_LATENCY_A => 0, -- DECIMAL
        READ_RESET_VALUE_A => "0", -- String
        USE_MEM_INIT => 1, -- DECIMAL
        WAKEUP_TIME => "disable_sleep" -- String
    )
    port map (
    dbiterra => open,   -- 1-bit output: Leave open.
    douta => data_out,         -- READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
    sbiterra => open,   -- 1-bit output: Leave open.

    addra =>addr,         -- ADDR_WIDTH_A-bit input: Address for port A read operations.
    clka => clk,           -- 1-bit input: Clock signal for port A.
    ena => enb,             -- 1-bit input: Memory enable signal for port A. Must be high on clock
                            -- cycles when read operations are initiated. Pipelined internally.
    injectdbiterra => '0', -- 1-bit input: Do not change from the provided value.
    injectsbiterra => '0', -- 1-bit input: Do not change from the provided value.
    regcea => '1',       -- 1-bit input: Do not change from the provided value.
    rsta => rst,           -- 1-bit input: Reset signal for the final port A output register
                            -- stage. Synchronously resets output port douta to the value specified
                            -- by parameter READ_RESET_VALUE_A.
    sleep => '0' -- 1-bit input: sleep signal to enable the dynamic power saving feature.
    );
    -- End of xpm_memory_sprom_inst instantiation

end Behavioral;
