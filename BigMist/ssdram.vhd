-------------------------------------------------------------------------------
--
-- MSX1 FPGA project
--
-- Copyright (c) 2016, Fabio Belavenuto (belavenuto@gmail.com)
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- Please report bugs to the author, but before you do so, please
-- make sure that this is not a derivative work and that
-- you have the latest version of this file.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ssdram is
	generic (
		freq_g			: integer	:= 100;
		rfsh_cycles_g	: integer	:= 4096;
		rfsh_period_g	: integer	:= 64
	);
	port (
		clock_i		: in    std_logic;
		reset_i		: in    std_logic;
		refresh_i	: in    std_logic									:= '1';
		-- Static RAM bus
		addr_i		: in    std_logic_vector(22 downto 0);		-- 8MB
		data_i		: in    std_logic_vector( 7 downto 0);
		data_o		: out   std_logic_vector( 7 downto 0);
		cs_n_i		: in    std_logic;
		oe_n_i		: in    std_logic;
		we_n_i		: in    std_logic;
		-- SD-RAM ports
		mem_cke_o	: out   std_logic;
		mem_cs_n_o	: out   std_logic;
		mem_ras_n_o	: out   std_logic;
		mem_cas_n_o	: out   std_logic;
		mem_we_n_o	: out   std_logic;
		mem_udq_o	: out   std_logic;
		mem_ldq_o	: out   std_logic;
		mem_ba_o	: out   std_logic_vector( 1 downto 0);
		mem_addr_o	: out   std_logic_vector(11 downto 0);
		mem_data_io	: inout std_logic_vector(15 downto 0)
	);
end entity;

architecture Behavior of ssdram is

	constant SdrCmd_de_c	: std_logic_vector(3 downto 0) := "1111"; -- deselect
	constant SdrCmd_xx_c	: std_logic_vector(3 downto 0) := "0111"; -- no operation
	constant SdrCmd_rd_c	: std_logic_vector(3 downto 0) := "0101"; -- read
	constant SdrCmd_wr_c	: std_logic_vector(3 downto 0) := "0100"; -- write		
	constant SdrCmd_ac_c	: std_logic_vector(3 downto 0) := "0011"; -- activate
	constant SdrCmd_pr_c	: std_logic_vector(3 downto 0) := "0010"; -- precharge all
	constant SdrCmd_re_c	: std_logic_vector(3 downto 0) := "0001"; -- refresh
	constant SdrCmd_ms_c	: std_logic_vector(3 downto 0) := "0000"; -- mode regiser set
	-- SD-RAM control signals
	signal SdrCmd_s		: std_logic_vector(3 downto 0);
	signal SdrBa_s			: std_logic_vector(1 downto 0);
	signal SdrUdq_s		: std_logic;
	signal SdrLdq_s		: std_logic;
	signal SdrAdr_s		: std_logic_vector(11 downto 0);
	signal SdrDat_s		: std_logic_vector(15 downto 0);
	
	signal ram_req_s		: std_logic;
	signal ram_ack_s		: std_logic;
	signal ram_addr_s		: std_logic_vector(22 downto 0);
	signal ram_din_s		: std_logic_vector( 7 downto 0);
	signal ram_dout_s		: std_logic_vector( 7 downto 0);
	signal ram_we_s		: std_logic;

begin

	-- Detect request
	process (reset_i, clock_i)
		variable pcs_v		: std_logic_vector(1 downto 0);
		variable acess_v	: std_logic;
	begin
		if reset_i = '1' then
			data_o			<= (others => '1');
			ram_we_s		<= '0';
			ram_req_s		<= '0';
			pcs_v			:= "11";
		elsif rising_edge(clock_i) then
			if ram_req_s = '1' and ram_ack_s = '1' then
				if ram_we_s = '0' then
					data_o <= ram_dout_s;
				end if;
				ram_req_s <= '0';
			end if;

			if pcs_v = "10" then
				ram_addr_s	<= addr_i;
				ram_req_s	<= '1';
				if we_n_i = '0' then
					ram_din_s	<= data_i;
					ram_we_s		<= '1';
				else
					ram_we_s		<= '0';
				end if;
			end if;

			acess_v	:= cs_n_i or (oe_n_i and we_n_i);
			pcs_v		:= pcs_v(0) & acess_v;

		end if;
	end process;

	----------------------------
	process (clock_i)

		type typSdrRoutine_t is ( SdrRoutine_Null, SdrRoutine_Init, SdrRoutine_Idle, SdrRoutine_RefreshAll, SdrRoutine_ReadOne, SdrRoutine_WriteOne );
		variable SdrRoutine_v				: typSdrRoutine_t			:= SdrRoutine_Null;
		variable SdrRoutineSeq_v			: unsigned( 7 downto 0)	:= X"00";
		variable refreshDelayCounter_v	: unsigned(23 downto 0)	:= x"000000";
		variable SdrRefreshCounter_v		: unsigned(15 downto 0)	:= X"0000";
		variable SdrAddress_v				: std_logic_vector(22 downto 0);
		
	begin
	
		if rising_edge(clock_i) then
			
			ram_ack_s	<= '0';

			case SdrRoutine_v is

				when SdrRoutine_Null =>
					SdrCmd_s <= SdrCmd_xx_c;
					SdrDat_s <= (others => 'Z');

					if refreshDelayCounter_v = 0 then
						SdrRoutine_v := SdrRoutine_Init;
					end if;

				when SdrRoutine_Init =>
					if SdrRoutineSeq_v = X"00"  then
						SdrCmd_s				<= SdrCmd_pr_c;
						SdrAdr_s				<= (others => '1');
						SdrBa_s				<= "00";
						SdrUdq_s				<= '1';
						SdrLdq_s				<= '1';
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"04" or SdrRoutineSeq_v = X"0C" then
						SdrCmd_s				<= SdrCmd_re_c;
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"14" then
						SdrCmd_s				<= SdrCmd_ms_c;
						SdrAdr_s				<= "00" & "1" & "00" & "010" & "0" & "000";				-- Single, Standard, CAS Latency=2, WT=0(seq), BL=1
						SdrRoutineSeq_v := SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"17" then
						SdrCmd_s <= SdrCmd_xx_c;
						SdrRoutineSeq_v := X"00";
						SdrRoutine_v := SdrRoutine_Idle;
					else
						SdrCmd_s <= SdrCmd_xx_c;
						SdrRoutineSeq_v := SdrRoutineSeq_v + 1;
					end if;

				when SdrRoutine_Idle =>
					SdrCmd_s <= SdrCmd_xx_c;
					SdrDat_s <= (others => 'Z');

					if ram_req_s = '1' and ram_ack_s = '0' then
						SdrAddress_v	:= ram_addr_s;
						if ram_we_s = '1' then
							SdrRoutine_v := SdrRoutine_WriteOne;
						else
							SdrRoutine_v := SdrRoutine_ReadOne;
						end if;
					elsif SdrRefreshCounter_v < rfsh_cycles_g and refresh_i = '1' then
						SdrRoutine_v			:= SdrRoutine_RefreshAll;
						SdrRefreshCounter_v	:= SdrRefreshCounter_v + 1;
					end if;
				when SdrRoutine_RefreshAll =>
					if SdrRoutineSeq_v = X"00" then
						SdrCmd_s				<= SdrCmd_re_c;
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"06" then
						SdrCmd_s				<= SdrCmd_xx_c;
						SdrRoutineSeq_v	:= X"00";
						SdrRoutine_v		:= SdrRoutine_Idle;
					else
						SdrCmd_s				<= SdrCmd_xx_c;
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;
					end if;

				when SdrRoutine_ReadOne =>	
					if SdrRoutineSeq_v = X"00" then
						SdrCmd_s				<= SdrCmd_ac_c;
						SdrBa_s				<= SdrAddress_v(22 downto 21);
						SdrAdr_s				<= SdrAddress_v(20 downto 9);				-- Row (12 bits)
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"02" then
						SdrCmd_s						<= SdrCmd_rd_c;
						SdrAdr_s(11 downto 8)	<= "0100";								-- A10 = '1' => Auto Pre-charge
						SdrAdr_s(7 downto 0)		<= SdrAddress_v(8 downto 1);		-- Col (8 bits)
						SdrUdq_s						<= '0';
						SdrLdq_s						<= '0';
						SdrRoutineSeq_v			:= SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"05" then
						if SdrAddress_v(0) = '0' then
							ram_dout_s	<= mem_data_io(7 downto 0);
						else
							ram_dout_s	<= mem_data_io(15 downto 8);
						end if;
						ram_ack_s	<= '1';
						SdrCmd_s				<= SdrCmd_xx_c;
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;					
					elsif SdrRoutineSeq_v = X"06" then
						SdrRoutineSeq_v	:= X"00";
						SdrRoutine_v		:= SdrRoutine_Idle;
					else
						SdrCmd_s				<= SdrCmd_xx_c;
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;					
					end if;
					
				when SdrRoutine_WriteOne =>	
					if SdrRoutineSeq_v = X"00" then
						SdrCmd_s				<= SdrCmd_ac_c;
						SdrBa_s				<= SdrAddress_v(22 downto 21);
						SdrAdr_s				<= SdrAddress_v(20 downto 9);
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"02" then
						SdrCmd_s						<= SdrCmd_wr_c;
						SdrAdr_s(11 downto 8)	<= "0100";									-- A10 = '1' => Auto Pre-charge
						SdrAdr_s(7 downto 0)		<= SdrAddress_v(8 downto 1);
						SdrUdq_s						<= not SdrAddress_v(0);
						SdrLdq_s						<=     SdrAddress_v(0);
						SdrDat_s						<= ram_din_s & ram_din_s;
						SdrRoutineSeq_v := SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"03" then
						ram_ack_s			<= '1';
						SdrCmd_s				<= SdrCmd_xx_c;
						SdrDat_s				<= (others => 'Z');
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;
					elsif SdrRoutineSeq_v = X"05" then						
						SdrRoutineSeq_v := X"00";
						SdrRoutine_v := SdrRoutine_Idle;
					else
						SdrCmd_s				<= SdrCmd_xx_c;
						SdrRoutineSeq_v	:= SdrRoutineSeq_v + 1;					
					end if;
			end case;
			
			refreshDelayCounter_v := refreshDelayCounter_v + 1;
			
			if refreshDelayCounter_v >= ( freq_g * 1000 * rfsh_period_g ) then
				refreshDelayCounter_v	:= x"000000";
				SdrRefreshCounter_v		:= x"0000";
			end if;
		end if;
	end process;

	mem_cke_o		<= '1';
	mem_cs_n_o		<= SdrCmd_s(3);
	mem_ras_n_o		<= SdrCmd_s(2);
	mem_cas_n_o		<= SdrCmd_s(1);
	mem_we_n_o		<= SdrCmd_s(0);
	mem_udq_o		<= SdrUdq_s;
	mem_ldq_o		<= SdrLdq_s;
	mem_ba_o			<= SdrBa_s;
	mem_addr_o		<= SdrAdr_s;
	mem_data_io		<= SdrDat_s;

end architecture;

