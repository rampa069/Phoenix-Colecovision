//
// Phoenix ColecoVision Core
// Released under the 3-Clause BSD License:
// 
//
// Copyright 2019 - 2020
// Matthew Hagerty, Brian Burney
// Ported to altera by rampa
//
// This core started as a mix of the ColecoFPGA core and a CV core designed and
// written by Matthew.  By the time of the first release, this CV core has been
// completely rewritten several times over, and nothing of either original core
// remains. However, both systems provided information and a starting point for
// this implementation, and credit is always due.
//
// Attribution for the ColecoFPGA project:
//
///////////////////////////////////////////////////////////////////////////////
//
// ColecoFPGA project
//
// Copyright (c) 2006, Arnim Laeuger (arnim.laeuger@gmx.net)
// Copyright (c) 2016, Fabio Belavenuto (belavenuto@gmail.com)
//
// All rights reserved
//
// Redistribution and use in source and synthezised forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// Redistributions in synthesized form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// Neither the name of the author nor the names of other contributors may
// be used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Please report bugs to the author, but before you do so, please
// make sure that this is not a derivative work and that
// you have the latest version of this file.
//
////////////////////////////////////////////////////////////////////////////////////

`default_nettype none

module guest_top
(
	input         CLOCK_27,
`ifdef USE_CLOCK_50
   input         CLOCK_50,
`endif
	output        LED,
	output [VGA_BITS-1:0] VGA_R,
	output [VGA_BITS-1:0] VGA_G,
	output [VGA_BITS-1:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,

`ifdef USE_HDMI
	output        HDMI_RST,
	output  [7:0] HDMI_R,
	output  [7:0] HDMI_G,
	output  [7:0] HDMI_B,
	output        HDMI_HS,
	output        HDMI_VS,
	output        HDMI_PCLK,
	output        HDMI_DE,
	inout         HDMI_SDA,
	inout         HDMI_SCL,
	input         HDMI_INT,
`endif

`ifdef I2S_AUDIO_HDMI
	output        HDMI_MCLK,
	output        HDMI_BCK,
	output        HDMI_LRCK,
	output        HDMI_SDATA,
`endif

	input         SPI_SCK,
	inout         SPI_DO,
	input         SPI_DI,
	input         SPI_SS2,    // data_io
	input         SPI_SS3,    // OSD
	input         CONF_DATA0, // SPI_SS for user_io

`ifdef USE_QSPI
	input         QSCK,
	input         QCSn,
	inout   [3:0] QDAT,
`endif
`ifndef NO_DIRECT_UPLOAD
	input         SPI_SS4,
`endif

	output [12:0] SDRAM_A,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nWE,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nCS,
	output  [1:0] SDRAM_BA,
	output        SDRAM_CLK,
	output        SDRAM_CKE,

`ifdef DUAL_SDRAM
	output [12:0] SDRAM2_A,
	inout  [15:0] SDRAM2_DQ,
	output        SDRAM2_DQML,
	output        SDRAM2_DQMH,
	output        SDRAM2_nWE,
	output        SDRAM2_nCAS,
	output        SDRAM2_nRAS,
	output        SDRAM2_nCS,
	output  [1:0] SDRAM2_BA,
	output        SDRAM2_CLK,
	output        SDRAM2_CKE,
`endif

	output        AUDIO_L,
	output        AUDIO_R,
`ifdef I2S_AUDIO
	output        I2S_BCK,
	output        I2S_LRCK,
	output        I2S_DATA,
`endif
`ifdef SPDIF_AUDIO
	output        SPDIF,
`endif
`ifdef USE_AUDIO_IN
	input         AUDIO_IN,
`endif

`ifdef PIN_REFLECTION
	output        joy_clk,
   input         joy_xclk,
	
   output        joy_load,
   input         joy_xload,
   
	input         joy_data,
   output        joy_xdata,	
`endif

	
`ifdef USE_EXTBUS	
	output  [14:0]  BUS_A,
	inout   [7:0]   BUS_D,
	output        BUS_E80,
	output        BUS_EA0,
	output        BUS_EC0,
	output        BUS_EE0,
	input         BUS_nRESET,
	output        BUS_LED,
`endif
   input         UART_RX,
	output        UART_TX
);

`ifdef NO_DIRECT_UPLOAD
localparam bit DIRECT_UPLOAD = 0;
wire SPI_SS4 = 1;
`else
localparam bit DIRECT_UPLOAD = 1;
`endif

`ifdef USE_QSPI
localparam bit QSPI = 1;
assign QDAT = 4'hZ;
`else
localparam bit QSPI = 0;
`endif

`ifdef VGA_8BIT
localparam VGA_BITS = 8;
`else
localparam VGA_BITS = 6;
`endif

`ifdef USE_HDMI
localparam bit HDMI = 1;
assign HDMI_RST = 1'b1;
`else
localparam bit HDMI = 0;
`endif

`ifdef BIG_OSD
localparam bit BIG_OSD = 1;
`define SEP "-;",
`else
localparam bit BIG_OSD = 0;
`define SEP
`endif

// remove this if the 2nd chip is actually used
`ifdef DUAL_SDRAM
assign SDRAM2_A = 13'hZZZZ;
assign SDRAM2_BA = 0;
assign SDRAM2_DQML = 0;
assign SDRAM2_DQMH = 0;
assign SDRAM2_CKE = 0;
assign SDRAM2_CLK = 0;
assign SDRAM2_nCS = 1;
assign SDRAM2_DQ = 16'hZZZZ;
assign SDRAM2_nCAS = 1;
assign SDRAM2_nRAS = 1;
assign SDRAM2_nWE = 1;
`endif

`ifdef USE_HDMI
wire        i2c_start;
wire        i2c_read;
wire  [6:0] i2c_addr;
wire  [7:0] i2c_subaddr;
wire  [7:0] i2c_dout;
wire  [7:0] i2c_din;
wire        i2c_ack;
wire        i2c_end;
`endif



`include "build_id.v" 
parameter CONF_STR = {
	"PHOENIX;;",
	"S0U,VHD,Mount SD;",
	`SEP
	"O3,Joysticks swap,No,Yes;",
	`SEP
	"T0,Reset;",
	"V,v",`BUILD_DATE
};

/////////////////  CLOCKS  ////////////////////////

wire clk_sys,clk_ram;
wire pll_locked;


wire clk_100,clk_25;

pll_vdp pll_vdp
(
`ifdef USE_CLOCK_50
        .inclk0(CLOCK_50),
`else
        .inclk0(CLOCK_27),
`endif	
        .areset(0),
        .c0(clk_100),
		  .c1(clk_25),
		  .locked(pll_locked)
);

assign clk_sys=clk_25;
assign clk_ram=clk_100;

logic [2:0] counter;
logic clk_3m58_en;

    // Proceso secuencial
    always_ff @(posedge clk_25 or posedge reset) begin
        if (reset) begin
            counter <= 3'b000;      // Reinicia el contador
            clk_3m58_en <= 1'b0;   // Inicializa el clock enable en bajo
        end else begin
            if (counter == 3'd6) begin
                counter <= 3'b000;  // Reinicia el contador
                clk_3m58_en <= 1'b1; // Genera un pulso de habilitación
            end else begin
                counter <= counter + 1'b1; // Incrementa el contador
                clk_3m58_en <= 1'b0;       // Mantén el clock enable en bajo
            end
        end
    end



/////////////////  HPS  ///////////////////////////

wire [31:0] status;
wire  [1:0] buttons;


wire [31:0] joy0, joy1;

wire        ioctl_download;
wire  [7:0] ioctl_index;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;
wire        clkref;

wire        scandoubler_disable;
wire ypbpr;
wire no_csync;
wire  [1:0] switches;
wire        key_pressed;
wire [7:0]  key_code;
wire        key_strobe;
wire        key_extended;


`ifdef PIN_REFLECTION
assign joy_clk = joy_xclk;
assign joy_load = joy_xload;
assign joy_xdata = joy_data;
`endif


wire [10:0] ps2_key;
assign ps2_key = {key_strobe,key_pressed,key_extended,key_code}; 

wire [31:0] sd_lba;
wire  sd_rd;
wire  sd_wr;

wire        sd_ack;
wire  [8:0] sd_buff_addr;
wire  [7:0] sd_buff_dout;
wire  [7:0] sd_buff_din;
wire        sd_buff_wr;
wire        img_mounted;
wire [63:0] img_size;

wire        sd_ack_conf;
wire        sd_conf;
wire        sd_sdhc;

wire ps2k_c,ps2k_d,ps2k_c_i,ps2k_d_i;

user_io #(
	.STRLEN($size(CONF_STR)>>3),
	.FEATURES(32'h0 | (BIG_OSD << 13) | (HDMI << 14))) 
user_io
( 
    .clk_sys(clk_sys),
    .clk_sd(clk_sys),
    .SPI_SS_IO(CONF_DATA0),
    .SPI_CLK(SPI_SCK),
    .SPI_MOSI(SPI_DI),
    .SPI_MISO(SPI_DO),

	 `ifdef USE_HDMI
	 .i2c_start      (i2c_start      ),
	 .i2c_read       (i2c_read       ),
	 .i2c_addr       (i2c_addr       ),
	 .i2c_subaddr    (i2c_subaddr    ),
	 .i2c_dout       (i2c_dout       ),
	 .i2c_din        (i2c_din        ),
	 .i2c_ack        (i2c_ack        ),
	 .i2c_end        (i2c_end        ),
	`endif

	.ps2_kbd_clk(ps2k_c),
	.ps2_kbd_data(ps2k_d),
//	.ps2_kbd_clk_i(msx_ps2_kbd_clk),
//	.ps2_kbd_data_i(msx_ps2_kbd_data),

	.img_mounted(img_mounted),
	.img_size(img_size),
	.sd_conf(sd_conf),
	.sd_ack_conf(sd_ack_conf),
	.sd_sdhc(sd_sdhc),
	.sd_lba(sd_lba),
	.sd_rd(sd_rd),
	.sd_wr(sd_wr),
	.sd_ack(sd_ack),
	.sd_buff_addr(sd_buff_addr),
	.sd_din(sd_buff_din),
	.sd_dout(sd_buff_dout),
	.sd_dout_strobe(sd_buff_wr),
	
    .conf_str(CONF_STR),
    .status(status),
    .scandoubler_disable(scandoubler_disable),
    .ypbpr(ypbpr),
    .no_csync(no_csync),
    .buttons(buttons),
    .joystick_0(joy0),
    .joystick_1(joy1),
	 
    .key_strobe(key_strobe),
    .key_code(key_code),
    .key_pressed(key_pressed),
    .key_extended(key_extended),

	 .switches(switches)

);

data_io data_io (
    // SPI interface
    .SPI_SCK        ( SPI_SCK ),
    .SPI_SS2        ( SPI_SS2 ),
    .SPI_DI         ( SPI_DI  ),
    // ram interface
    .clk_sys        ( clk_sys ),
    .ioctl_download ( ioctl_download ),
    .ioctl_index    ( ioctl_index ),
    .ioctl_wr       ( ioctl_wr ),
    .ioctl_addr     ( ioctl_addr ),
    .ioctl_dout     ( ioctl_dout )
);


wire sd_miso_i;
wire sd_mosi_o;
wire sd_sclk_o;
wire sd_cs_n_o;


sd_card sd_card (
	.clk_sys         ( clk_100       ),   // at least 2xsd_sck
	// connection to io controller
	.sd_lba          ( sd_lba         ),
	.sd_rd           ( sd_rd          ),
	.sd_wr           ( sd_wr          ),
	.sd_ack          ( sd_ack         ),
	.sd_conf         ( sd_conf        ),
	.sd_ack_conf     ( sd_ack_conf    ),
	.sd_sdhc         ( sd_sdhc        ),
	.allow_sdhc      (1'b0            ),
	.sd_buff_dout    ( sd_buff_dout   ),
	.sd_buff_wr      ( sd_buff_wr     ),
	.sd_buff_din     ( sd_buff_din    ),
	.sd_buff_addr    ( sd_buff_addr   ),

   .img_mounted   (img_mounted),
	.img_size      (img_size),
	
	// connection to local CPU
	.sd_cs   		( sd_cs_n_o ),
	.sd_sck  		( sd_sclk_o ),
	.sd_sdi  		( sd_mosi_o ),
	.sd_sdo  		( sd_miso_i )
);

/////////////////  RESET  /////////////////////////

wire reset;

`ifdef USE_EXTBUS
	 assign reset = status[0] | buttons[1] | ioctl_download |  ~BUS_nRESET;
	 assign BUS_LED = status[2];
`else
	 assign reset =  status[0] | buttons[1] | ioctl_download ;
`endif
/////////////////  Memory  ////////////////////////

altddio_out
#(
        .extend_oe_disable("OFF"),
        .intended_device_family("Cyclone 10 LP"),
        .invert_output("OFF"),
        .lpm_hint("UNUSED"),
        .lpm_type("altddio_out"),
        .oe_reg("UNREGISTERED"),
        .power_up_high("OFF"),
        .width(1)
)


sdramclk_ddr
(
        .datain_h(1'b0),
        .datain_l(1'b1),
        .outclock(clk_100),
        .dataout(SDRAM_CLK),
        .aclr(1'b0),
        .aset(1'b0),
        .oe(1'b1),
        .outclocken(1'b1),
        .sclr(1'b0),
        .sset(1'b0)
);

////////////////  Console  ////////////////////////

wire [15:0] audio;
wire [15:0] DAC_L, DAC_R;
assign DAC_L = audio;
assign DAC_R = audio;

`ifdef I2S_AUDIO

wire [31:0] clk_rate =  32'd42_666_000;

i2s i2s (
        .reset(reset),
        .clk(clk_sys),
        .clk_rate(clk_rate),

        .sclk(I2S_BCK),
        .lrclk(I2S_LRCK),
        .sdata(I2S_DATA),

        .left_chan (DAC_L),
        .right_chan(DAC_R)
);

`ifdef I2S_AUDIO_HDMI
assign HDMI_MCLK = 0;
always @(posedge clk_sys) begin
	HDMI_BCK <= I2S_BCK;
	HDMI_LRCK <= I2S_LRCK;
	HDMI_SDATA <= I2S_DATA;
end
`endif
`endif

`ifdef SPDIF_AUDIO
spdif spdif (
	.clk_i(clk_sys),
	.rst_i(1'b0),
	.clk_rate_i(clk_rate),
	.spdif_o(SPDIF),
	.sample_i({DAC_L,DAC_R})
);
`endif

dac #(
   .c_bits	(14))
audiodac_l(
   .clk_i	(clk_sys	),
   .res_n_i	(1	),
   .dac_i	(audio),
   .dac_o	(AUDIO_L)
  );

dac #(
   .c_bits	(16))
audiodac_r(
   .clk_i	(clk_sys	),
   .res_n_i	(1	),
   .dac_i	(audio),
   .dac_o	(AUDIO_R)
  );

  

wire CLK_VIDEO = clk_100;

wire [1:0] ctrl_p1;
wire [1:0] ctrl_p2;
wire [1:0] ctrl_p3;
wire [1:0] ctrl_p4;
wire [1:0] ctrl_p5;
wire [1:0] ctrl_p6;
wire [1:0] ctrl_p7 = 2'b11;
wire [1:0] ctrl_p8;
wire [1:0] ctrl_p9 = 2'b11;

wire [3:0] R,G,B;
wire HBlank, VBlank;
wire HSync, VSync;

wire [31:0] joya = status[3] ? joy1 : joy0;
wire [31:0] joyb = status[3] ? joy0 : joy1;

colecovision console
(
	.clk_100m0_i  (clk_100),
   .clk_25m0_i   (clk_25),
	.clk_3m58_en_i(clk_3m58_en),
	
	.reset_i      (reset),
   .por_n_i      (~reset),


	.ctrl_p1_i	(ctrl_p1),
	.ctrl_p2_i	(ctrl_p2),
	.ctrl_p3_i	(ctrl_p3),
	.ctrl_p4_i	(ctrl_p4),
	.ctrl_p5_o	(ctrl_p5),
	.ctrl_p6_i	(ctrl_p6),
	.ctrl_p7_i	(ctrl_p7),
	.ctrl_p8_o	(ctrl_p8),
	.ctrl_p9_i	(ctrl_p9),

	.SDRAM_A 	(SDRAM_A),
	.SDRAM_DQ 	(SDRAM_DQ),
	.SDRAM_nCS 	(SDRAM_nCS),
	.SDRAM_nRAS (SDRAM_nRAS),
	.SDRAM_nCAS (SDRAM_nCAS),
	.SDRAM_nWE 	(SDRAM_nWE),
	.SDRAM_CKE 	(SDRAM_CKE),
	.SDRAM_DQMH (SDRAM_DQMH),
	.SDRAM_DQML (SDRAM_DQML),
	.SDRAM_BA 	(SDRAM_BA),


`ifdef USE_EXTBUS
	.cart_addr_o (BUS_A),
	.cart_data_io(BUS_D),
`else
   .cart_data_io(),
`endif
	
`ifdef USE_EXTBUS
  	.cart_en_80_n_o (BUS_E80),
   .cart_en_a0_n_o (BUS_EA0),
   .cart_en_c0_n_o (BUS_EC0),
   .cart_en_e0_n_o (BUS_EE0),
`endif
	
	.red_o		(R),
	.grn_o		(G),
	.blu_o		(B),
	.hsync_n_o	(HSync),
	.vsync_n_o	(VSync),
	.hblank_o 	(HBlank),
	.vblank_o 	(VBlank),
   .sd_miso_i 	(sd_miso_i),
	.sd_mosi_o	(sd_mosi_o),
	.sd_sclk_o	(sd_sclk_o),
	.sd_cs_n_o	(sd_cs_n_o),
	.sd_cd_n_i	(~|img_size),
	.led_o    	( tmp_led ),
	.pcm16_o   (audio)
);

logic tmp_led;
assign LED=~tmp_led;




mist_dual_video 
   #(.COLOR_DEPTH(4),
	.SD_HCNT_WIDTH(10),
	.OUT_COLOR_DEPTH(VGA_BITS),
	.USE_BLANKS(1'b1),
	.BIG_OSD(BIG_OSD)
	)
mist_video
(
	.clk_sys        ( CLK_VIDEO        ),
	.SPI_SCK        ( SPI_SCK          ),
	.SPI_SS3        ( SPI_SS3          ),
	.SPI_DI         ( SPI_DI           ),
	.R              ( R                ),
	.G              ( G                ),
	.B              ( B                ),
	.HBlank         ( HBlank           ),
	.VBlank         ( VBlank           ),
	.HSync          ( HSync            ),
	.VSync          ( VSync            ),
	.VGA_R          ( VGA_R            ),
	.VGA_G          ( VGA_G            ),
	.VGA_B          ( VGA_B            ),
	.VGA_VS         ( VGA_VS           ),
	.VGA_HS         ( VGA_HS           ),
`ifdef USE_HDMI
	.HDMI_R         ( HDMI_R           ),
	.HDMI_G         ( HDMI_G           ),
	.HDMI_B         ( HDMI_B           ),
	.HDMI_VS        ( HDMI_VS          ),
	.HDMI_HS        ( HDMI_HS          ),
	.HDMI_DE        ( HDMI_DE          ),
`endif

	.ce_divider     ( 4'h3             ),
	.rotate         ( 2'b00            ),
	.rotate_screen  ( 1'b0             ),
	.rotate_hfilter ( 1'b0             ),
	.rotate_vfilter ( 1'b0             ),
	.blend          (                  ),
	.scandoubler_disable( 1'b1         ),
	.scanlines      (                  ),
	.ypbpr          (                  ),
	.no_csync       ( 1'b1             )
	);

	
`ifdef USE_HDMI
i2c_master #(100_000_000) i2c_master (
	.CLK         (clk_100),
	.I2C_START   (i2c_start),
	.I2C_READ    (i2c_read),
	.I2C_ADDR    (i2c_addr),
	.I2C_SUBADDR (i2c_subaddr),
	.I2C_WDATA   (i2c_dout),
	.I2C_RDATA   (i2c_din),
	.I2C_END     (i2c_end),
	.I2C_ACK     (i2c_ack),

	//I2C bus
	.I2C_SCL     (HDMI_SCL),
	.I2C_SDA     (HDMI_SDA)
);	
assign HDMI_PCLK = CLK_VIDEO;

`endif

//////////////// Keypad emulation (by Alan Steremberg) ///////

wire       pressed = ps2_key[9];
wire [8:0] code    = ps2_key[8:0];
always @(posedge clk_sys) begin
	reg old_state;
	old_state <= ps2_key[10];

	if(old_state != ps2_key[10]) begin
		casex(code)

			'hX16: btn_1     <= pressed; // 1
			'hX1E: btn_2     <= pressed; // 2
			'hX26: btn_3     <= pressed; // 3
			'hX25: btn_4     <= pressed; // 4
			'hX2E: btn_5     <= pressed; // 5
			'hX36: btn_6     <= pressed; // 6
			'hX3D: btn_7     <= pressed; // 7
			'hX3E: btn_8     <= pressed; // 8
			'hX46: btn_9     <= pressed; // 9
			'hX45: btn_0     <= pressed; // 0

			'hX69: btn_1     <= pressed; // 1
			'hX72: btn_2     <= pressed; // 2
			'hX7A: btn_3     <= pressed; // 3
			'hX6B: btn_4     <= pressed; // 4
			'hX73: btn_5     <= pressed; // 5
			'hX74: btn_6     <= pressed; // 6
			'hX6C: btn_7     <= pressed; // 7
			'hX75: btn_8     <= pressed; // 8
			'hX7D: btn_9     <= pressed; // 9
			'hX70: btn_0     <= pressed; // 0

			'hX7C: btn_star  <= pressed; // *
			'hX59: btn_shift <= pressed; // Right Shift
			'hX12: btn_shift <= pressed; // Left Shift
			'hX7B: btn_minus <= pressed; // - on keypad


		endcase
	end
end

reg btn_1 = 0;
reg btn_2 = 0;
reg btn_3 = 0;
reg btn_4 = 0;
reg btn_5 = 0;
reg btn_6 = 0;
reg btn_7 = 0;
reg btn_8 = 0;
reg btn_9 = 0;
reg btn_0 = 0;

reg btn_star = 0;
reg btn_shift = 0;
reg btn_minus = 0;


////////////////  Control  ////////////////////////
//	"J1,dir,dir,dir,dir,Fire 1,Fire 2,*,#,[8]0,1,2,3,4,5,6,7,8,9,Purple Tr,Blue Tr;",
//        0   1   2   3   4      5     6 7 8 9 10 11 12 


wire [0:19] keypad0 = {joya[8],joya[9],joya[10],joya[11],joya[12],joya[13],joya[14],joya[15],joya[16],joya[17],joya[6],joya[7],joya[18],joya[19],joya[3],joya[2],joya[1],joya[0],joya[4],joya[5]};
wire [0:19] keypad1 = {joyb[8],joyb[9],joyb[10],joyb[11],joyb[12],joyb[13],joyb[14],joyb[15],joyb[16],joyb[17],joyb[6],joyb[7],joyb[18],joyb[19],joyb[3],joyb[2],joyb[1],joyb[0],joyb[4],joyb[5]};
wire [0:19] keyboardemu = { btn_0, btn_1, btn_2, btn_3, btn_4, btn_5, btn_6, btn_7, btn_8, btn_9, btn_star | (btn_8&btn_shift), btn_minus | (btn_shift & btn_3), 8'b0};
wire [0:19] keypad[2] = '{keypad0|keyboardemu,keypad1|keyboardemu};

reg [3:0] ctrl1[2] = '{'0,'0};
assign {ctrl_p1[0],ctrl_p2[0],ctrl_p3[0],ctrl_p4[0]} = ctrl1[0];
assign {ctrl_p1[1],ctrl_p2[1],ctrl_p3[1],ctrl_p4[1]} = ctrl1[1];

localparam cv_key_0_c        = 4'b0011;
localparam cv_key_1_c        = 4'b1110;
localparam cv_key_2_c        = 4'b1101;
localparam cv_key_3_c        = 4'b0110;
localparam cv_key_4_c        = 4'b0001;
localparam cv_key_5_c        = 4'b1001;
localparam cv_key_6_c        = 4'b0111;
localparam cv_key_7_c        = 4'b1100;
localparam cv_key_8_c        = 4'b1000;
localparam cv_key_9_c        = 4'b1011;
localparam cv_key_asterisk_c = 4'b1010;
localparam cv_key_number_c   = 4'b0101;
localparam cv_key_pt_c       = 4'b0100;
localparam cv_key_bt_c       = 4'b0010;
localparam cv_key_none_c     = 4'b1111;

generate
        genvar i;
        for (i = 0; i <= 1; i++) begin : ctl
                always_comb begin
                        reg [3:0] ctl1, ctl2;
                        reg p61,p62;

                        ctl1 = 4'b1111;
                        ctl2 = 4'b1111;
                        p61 = 1;
                        p62 = 1;

                        if (~ctrl_p5[i]) begin
                                casex(keypad[i][0:13])
                                        'b1xxxxxxxxxxxxx: ctl1 = cv_key_0_c;
                                        'b01xxxxxxxxxxxx: ctl1 = cv_key_1_c;
                                        'b001xxxxxxxxxxx: ctl1 = cv_key_2_c;
                                        'b0001xxxxxxxxxx: ctl1 = cv_key_3_c;
                                        'b00001xxxxxxxxx: ctl1 = cv_key_4_c;
                                        'b000001xxxxxxxx: ctl1 = cv_key_5_c;
                                        'b0000001xxxxxxx: ctl1 = cv_key_6_c;
                                        'b00000001xxxxxx: ctl1 = cv_key_7_c;
                                        'b000000001xxxxx: ctl1 = cv_key_8_c;
                                        'b0000000001xxxx: ctl1 = cv_key_9_c;
                                        'b00000000001xxx: ctl1 = cv_key_asterisk_c;
                                        'b000000000001xx: ctl1 = cv_key_number_c;
                                        'b0000000000001x: ctl1 = cv_key_pt_c;
                                        'b00000000000001: ctl1 = cv_key_bt_c;
                                        'b00000000000000: ctl1 = cv_key_none_c;
                                endcase
                                p61 = ~keypad[i][19]; // button 2
                        end

                        if (~ctrl_p8[i]) begin
                                ctl2 = ~keypad[i][14:17];
                                p62 = ~keypad[i][18];  // button 1
                        end

                        ctrl1[i] = ctl1 & ctl2;
                        ctrl_p6[i] = p61 & p62;
                end
        end
endgenerate



endmodule
