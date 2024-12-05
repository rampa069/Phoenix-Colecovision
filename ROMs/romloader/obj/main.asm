;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _swapin_real_cart
	.globl _joystick_read
	.globl _cart_detect
	.globl _sd_card_detect
	.globl _sd_read_block
	.globl _sd_card_init
	.globl _sd_send_cmd
	.globl _sd_send_cmd_ex
	.globl _disp_hex
	.globl _print_setxy
	.globl _print_str_nl
	.globl _print_nl
	.globl _print_str_sp
	.globl _print_str
	.globl _strlen
	.globl _vdp_memcpy
	.globl _vdp_memset
	.globl _vdp_wtr
	.globl _vdp_wr_addr
	.globl _vdp_rd_addr
	.globl _nmi_handler
	.globl _CMDARGS
	.globl _g_sd_type
	.globl _g_sd_status
	.globl _g_sd_addr_size
	.globl _g_sd_type_name
	.globl _print_loc
	.globl _nmi_count_g
	.globl _hex
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_SD_CTRL_PORT	=	0x0056
_SD_DATA_PORT	=	0x0057
_CONT_KEY_PORT	=	0x0080
_CONT_JOY_PORT	=	0x00c0
_CONT1_DATA_PORT	=	0x00fc
_CONT2_DATA_PORT	=	0x00ff
_VDP_DATA_PORT	=	0x00be
_VDP_CTRL_PORT	=	0x00bf
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_sd_card_detect_state_65536_87:
	.ds 1
_sd_card_detect_delay_65536_87:
	.ds 1
_cart_detect_state_65536_98:
	.ds 1
_cart_detect_delay_65536_98:
	.ds 1
_joystick_read_state_65536_107:
	.ds 1
_joystick_read_delay_65536_107:
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_nmi_count_g::
	.ds 1
_print_loc::
	.ds 2
_g_sd_type_name::
	.ds 8
_g_sd_addr_size::
	.ds 1
_g_sd_status::
	.ds 1
_g_sd_type::
	.ds 1
_CMDARGS::
	.ds 4
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;src/main.c:923: static uint8_t state = SD_ST_NOTFOUND;
	ld	iy, #_sd_card_detect_state_65536_87
	ld	0 (iy), #0x00
;src/main.c:924: static uint8_t delay = 0;
	ld	iy, #_sd_card_detect_delay_65536_87
	ld	0 (iy), #0x00
;src/main.c:1015: static uint8_t state = CART_ST_NOTFOUND;
	ld	iy, #_cart_detect_state_65536_98
	ld	0 (iy), #0x00
;src/main.c:1016: static uint8_t delay = 0;
	ld	iy, #_cart_detect_delay_65536_98
	ld	0 (iy), #0x00
;src/main.c:1093: static uint8_t state = JOY_ST_NONE;
	ld	iy, #_joystick_read_state_65536_107
	ld	0 (iy), #0x00
;src/main.c:1094: static uint8_t delay = 0;
	ld	iy, #_joystick_read_delay_65536_107
	ld	0 (iy), #0x00
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/main.c:58: nmi_handler(void) __critical __interrupt __naked
;	---------------------------------
; Function nmi_handler
; ---------------------------------
_nmi_handler::
;src/main.c:73: __endasm;
	push	af
	ld	a, (_nmi_count_g)
	inc	a
	ld	(_nmi_count_g), a
	pop	af
	retn
;src/main.c:74: }
;src/main.c:89: vdp_rd_addr(uint16_t addr)
;	---------------------------------
; Function vdp_rd_addr
; ---------------------------------
_vdp_rd_addr::
;src/main.c:92: VDP_CTRL_PORT = (addr & 0xFF);
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	out	(_VDP_CTRL_PORT), a
;src/main.c:96: VDP_CTRL_PORT = ((addr >> 8) & 0x3F);
	ld	a, 1 (iy)
	and	a, #0x3f
	out	(_VDP_CTRL_PORT), a
;src/main.c:97: }
	ret
_msx1_font:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x42	; 66	'B'
	.db #0xa5	; 165
	.db #0x81	; 129
	.db #0xa5	; 165
	.db #0x99	; 153
	.db #0x42	; 66	'B'
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0xdb	; 219
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xdb	; 219
	.db #0x66	; 102	'f'
	.db #0x3c	; 60
	.db #0x6c	; 108	'l'
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0xfe	; 254
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x54	; 84	'T'
	.db #0xfe	; 254
	.db #0x54	; 84	'T'
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0xe7	; 231
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0xc7	; 199
	.db #0xbb	; 187
	.db #0x7d	; 125
	.db #0x7d	; 125
	.db #0x7d	; 125
	.db #0xbb	; 187
	.db #0xc7	; 199
	.db #0xff	; 255
	.db #0x0f	; 15
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x79	; 121	'y'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x38	; 56	'8'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x44	; 68	'D'
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x30	; 48	'0'
	.db #0x28	; 40
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x28	; 40
	.db #0x20	; 32
	.db #0xe0	; 224
	.db #0xc0	; 192
	.db #0x3c	; 60
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0xe4	; 228
	.db #0xdc	; 220
	.db #0x18	; 24
	.db #0x10	; 16
	.db #0x54	; 84	'T'
	.db #0x38	; 56	'8'
	.db #0xee	; 238
	.db #0x38	; 56	'8'
	.db #0x54	; 84	'T'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x7c	; 124
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x1f	; 31
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0xff	; 255
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x81	; 129
	.db #0x42	; 66	'B'
	.db #0x24	; 36
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x42	; 66	'B'
	.db #0x81	; 129
	.db #0x7e	; 126
	.db #0x81	; 129
	.db #0xbd	; 189
	.db #0xa1	; 161
	.db #0xa1	; 161
	.db #0xbd	; 189
	.db #0x81	; 129
	.db #0x7e	; 126
	.db #0x1f	; 31
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x44	; 68	'D'
	.db #0x6c	; 108	'l'
	.db #0x54	; 84	'T'
	.db #0x54	; 84	'T'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0xf8	; 248
	.db #0x50	; 80	'P'
	.db #0xf8	; 248
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x78	; 120	'x'
	.db #0xa0	; 160
	.db #0x70	; 112	'p'
	.db #0x28	; 40
	.db #0xf0	; 240
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0xc8	; 200
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x98	; 152
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0xa0	; 160
	.db #0x40	; 64
	.db #0xa8	; 168
	.db #0x90	; 144
	.db #0x98	; 152
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0xa8	; 168
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0xa8	; 168
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x98	; 152
	.db #0xa8	; 168
	.db #0xc8	; 200
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x60	; 96
	.db #0xa0	; 160
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x60	; 96
	.db #0x80	; 128
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x08	; 8
	.db #0x30	; 48	'0'
	.db #0x08	; 8
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x30	; 48	'0'
	.db #0x50	; 80	'P'
	.db #0x90	; 144
	.db #0xf8	; 248
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0xe0	; 224
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x78	; 120	'x'
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x18	; 24
	.db #0x30	; 48	'0'
	.db #0x60	; 96
	.db #0xc0	; 192
	.db #0x60	; 96
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x60	; 96
	.db #0x30	; 48	'0'
	.db #0x18	; 24
	.db #0x30	; 48	'0'
	.db #0x60	; 96
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x08	; 8
	.db #0x48	; 72	'H'
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x70	; 112	'p'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x50	; 80	'P'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x50	; 80	'P'
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x80	; 128
	.db #0xb8	; 184
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x90	; 144
	.db #0xa0	; 160
	.db #0xc0	; 192
	.db #0xa0	; 160
	.db #0x90	; 144
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0xd8	; 216
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0xc8	; 200
	.db #0xc8	; 200
	.db #0xa8	; 168
	.db #0x98	; 152
	.db #0x98	; 152
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0xa8	; 168
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0xf0	; 240
	.db #0xa0	; 160
	.db #0x90	; 144
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x80	; 128
	.db #0x70	; 112	'p'
	.db #0x08	; 8
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0xd8	; 216
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x08	; 8
	.db #0x78	; 120	'x'
	.db #0x88	; 136
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xb0	; 176
	.db #0xc8	; 200
	.db #0x88	; 136
	.db #0xc8	; 200
	.db #0xb0	; 176
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x80	; 128
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x68	; 104	'h'
	.db #0x98	; 152
	.db #0x88	; 136
	.db #0x98	; 152
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.db #0x98	; 152
	.db #0x98	; 152
	.db #0x68	; 104	'h'
	.db #0x08	; 8
	.db #0x70	; 112	'p'
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x90	; 144
	.db #0x60	; 96
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x48	; 72	'H'
	.db #0x50	; 80	'P'
	.db #0x60	; 96
	.db #0x50	; 80	'P'
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xd0	; 208
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xb0	; 176
	.db #0xc8	; 200
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xb0	; 176
	.db #0xc8	; 200
	.db #0xc8	; 200
	.db #0xb0	; 176
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.db #0x98	; 152
	.db #0x98	; 152
	.db #0x68	; 104	'h'
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xb0	; 176
	.db #0xc8	; 200
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x80	; 128
	.db #0x70	; 112	'p'
	.db #0x08	; 8
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0xf0	; 240
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x98	; 152
	.db #0x68	; 104	'h'
	.db #0x08	; 8
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0xa8	; 168
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x60	; 96
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x08	; 8
	.db #0x78	; 120	'x'
	.db #0x88	; 136
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x08	; 8
	.db #0x78	; 120	'x'
	.db #0x88	; 136
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x80	; 128
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x04	; 4
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0xff	; 255
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0xf0	; 240
	.db #0x80	; 128
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.db #0x12	; 18
	.db #0x7e	; 126
	.db #0x90	; 144
	.db #0x6e	; 110	'n'
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x50	; 80	'P'
	.db #0x90	; 144
	.db #0x9c	; 156
	.db #0xf0	; 240
	.db #0x90	; 144
	.db #0x9e	; 158
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x98	; 152
	.db #0x68	; 104	'h'
	.db #0x08	; 8
	.db #0x70	; 112	'p'
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x78	; 120	'x'
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x78	; 120	'x'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0xe2	; 226
	.db #0x5c	; 92
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x80	; 128
	.db #0x9c	; 156
	.db #0x84	; 132
	.db #0x88	; 136
	.db #0x90	; 144
	.db #0x7c	; 124
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x08	; 8
	.db #0x78	; 120	'x'
	.db #0x88	; 136
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0xb0	; 176
	.db #0xc8	; 200
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0xc8	; 200
	.db #0xa8	; 168
	.db #0x98	; 152
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x60	; 96
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x84	; 132
	.db #0x88	; 136
	.db #0x90	; 144
	.db #0xa8	; 168
	.db #0x54	; 84	'T'
	.db #0x84	; 132
	.db #0x08	; 8
	.db #0x1c	; 28
	.db #0x84	; 132
	.db #0x88	; 136
	.db #0x90	; 144
	.db #0xa8	; 168
	.db #0x58	; 88	'X'
	.db #0xa8	; 168
	.db #0x3c	; 60
	.db #0x08	; 8
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x12	; 18
	.db #0x24	; 36
	.db #0x48	; 72	'H'
	.db #0x90	; 144
	.db #0x48	; 72	'H'
	.db #0x24	; 36
	.db #0x12	; 18
	.db #0x00	; 0
	.db #0x90	; 144
	.db #0x48	; 72	'H'
	.db #0x24	; 36
	.db #0x12	; 18
	.db #0x24	; 36
	.db #0x48	; 72	'H'
	.db #0x90	; 144
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x08	; 8
	.db #0x78	; 120	'x'
	.db #0x88	; 136
	.db #0x78	; 120	'x'
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0xfc	; 252
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0xe8	; 232
	.db #0x08	; 8
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0xa0	; 160
	.db #0x00	; 0
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0xc0	; 192
	.db #0x44	; 68	'D'
	.db #0xc8	; 200
	.db #0x54	; 84	'T'
	.db #0xec	; 236
	.db #0x54	; 84	'T'
	.db #0x9e	; 158
	.db #0x04	; 4
	.db #0x10	; 16
	.db #0xa8	; 168
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc4	; 196
	.db #0xc8	; 200
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0xb6	; 182
	.db #0x36	; 54	'6'
	.db #0x00	; 0
	.db #0x7c	; 124
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0x68	; 104	'h'
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x30	; 48	'0'
	.db #0x08	; 8
	.db #0x70	; 112	'p'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0xc0	; 192
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0xfc	; 252
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x3f	; 63
	.db #0x11	; 17
	.db #0x22	; 34
	.db #0x44	; 68	'D'
	.db #0x88	; 136
	.db #0x11	; 17
	.db #0x22	; 34
	.db #0x44	; 68	'D'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x44	; 68	'D'
	.db #0x22	; 34
	.db #0x11	; 17
	.db #0x88	; 136
	.db #0x44	; 68	'D'
	.db #0x22	; 34
	.db #0x11	; 17
	.db #0xfe	; 254
	.db #0x7c	; 124
	.db #0x38	; 56	'8'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x38	; 56	'8'
	.db #0x7c	; 124
	.db #0xfe	; 254
	.db #0x80	; 128
	.db #0xc0	; 192
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0xe0	; 224
	.db #0xc0	; 192
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0x3c	; 60
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0xc3	; 195
	.db #0xe7	; 231
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xe7	; 231
	.db #0xc3	; 195
	.db #0x81	; 129
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x33	; 51	'3'
	.db #0x33	; 51	'3'
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x33	; 51	'3'
	.db #0x33	; 51	'3'
	.db #0xcc	; 204
	.db #0xcc	; 204
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0xa8	; 168
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x68	; 104	'h'
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x70	; 112	'p'
	.db #0x48	; 72	'H'
	.db #0x48	; 72	'H'
	.db #0x70	; 112	'p'
	.db #0xc0	; 192
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x98	; 152
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x78	; 120	'x'
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x60	; 96
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x68	; 104	'h'
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0xa0	; 160
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0x70	; 112	'p'
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0x70	; 112	'p'
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x88	; 136
	.db #0xf8	; 248
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0xd8	; 216
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x70	; 112	'p'
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0xa8	; 168
	.db #0x70	; 112	'p'
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0xf8	; 248
	.db #0x80	; 128
	.db #0x40	; 64
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xf8	; 248
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0x30	; 48	'0'
	.db #0x08	; 8
	.db #0x30	; 48	'0'
	.db #0xc0	; 192
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x60	; 96
	.db #0x80	; 128
	.db #0x60	; 96
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x28	; 40
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xa0	; 160
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0xa0	; 160
	.db #0x00	; 0
	.db #0x50	; 80	'P'
	.db #0xa0	; 160
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x24	; 36
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x78	; 120	'x'
	.db #0x78	; 120	'x'
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0xa0	; 160
	.db #0x60	; 96
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0xa0	; 160
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x50	; 80	'P'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x40	; 64
	.db #0xa0	; 160
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
_hex:
	.ascii "0123456789ABCDEF"
	.db 0x00
;src/main.c:105: vdp_wr_addr(uint16_t addr)
;	---------------------------------
; Function vdp_wr_addr
; ---------------------------------
_vdp_wr_addr::
;src/main.c:108: VDP_CTRL_PORT = (addr & 0xFF);
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	out	(_VDP_CTRL_PORT), a
;src/main.c:112: VDP_CTRL_PORT = ((addr >> 8) & 0x3F) | 0x40;
	ld	a, 1 (iy)
	and	a, #0x3f
	or	a, #0x40
	out	(_VDP_CTRL_PORT), a
;src/main.c:113: }
	ret
;src/main.c:121: vdp_wtr(uint8_t reg, uint8_t val)
;	---------------------------------
; Function vdp_wtr
; ---------------------------------
_vdp_wtr::
;src/main.c:124: VDP_CTRL_PORT = val;
	ld	iy, #3
	add	iy, sp
	ld	a, 0 (iy)
	out	(_VDP_CTRL_PORT), a
;src/main.c:128: VDP_CTRL_PORT = (reg & 0x3F) | 0x80;
	dec	iy
	ld	a, 0 (iy)
	and	a, #0x3f
	or	a, #0x80
	out	(_VDP_CTRL_PORT), a
;src/main.c:129: }
	ret
;src/main.c:137: vdp_memset(uint16_t dst, uint8_t val, uint16_t count)
;	---------------------------------
; Function vdp_memset
; ---------------------------------
_vdp_memset::
;src/main.c:143: vdp_wr_addr(dst);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_vdp_wr_addr
	pop	af
;src/main.c:177: __endasm;
	ld	hl, #4
	add	hl, sp
	ld	d, (hl)
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	c, (hl)
	cp	#0
	jr	z, 001$
	inc	c
	    001$:
	ld	b, a
	ld	a, d
	    002$:
	out	(_VDP_DATA_PORT), a
	djnz	002$
	dec	c
	jr	nz, 002$
;src/main.c:178: }
	ret
;src/main.c:186: vdp_memcpy(uint16_t dst, uint8_t *src, uint16_t len)
;	---------------------------------
; Function vdp_memcpy
; ---------------------------------
_vdp_memcpy::
;src/main.c:192: vdp_wr_addr(dst);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_vdp_wr_addr
	pop	af
;src/main.c:229: __endasm;
	ld	hl, #4
	add	hl, sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	c, (hl)
	cp	#0
	jr	z, 001$
	inc	c
	    001$:
	ld	b, a
	ld	a, c
	ex	de, hl
	ld	c, #_VDP_DATA_PORT
	    002$:
	otir
	dec	a
	jr	nz, 002$
;src/main.c:230: }
	ret
;src/main.c:243: strlen(uint8_t *str)
;	---------------------------------
; Function strlen
; ---------------------------------
_strlen::
;src/main.c:246: while ( str[len] != 0 && len != 255 ) { len++; }
	ld	c, #0x00
00102$:
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, a
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z,00104$
	ld	a, c
	inc	a
	jr	Z,00104$
	inc	c
	jr	00102$
00104$:
;src/main.c:247: return len;
	ld	l, c
;src/main.c:248: }
	ret
;src/main.c:253: print_str(uint8_t *str)
;	---------------------------------
; Function print_str
; ---------------------------------
_print_str::
;src/main.c:255: uint8_t len = strlen(str);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_strlen
	pop	af
	ld	c, l
;src/main.c:256: vdp_memcpy(print_loc, str, len);
	ld	e, c
	ld	d, #0x00
	push	bc
	push	de
	ld	hl, #6
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	hl, (_print_loc)
	push	hl
	call	_vdp_memcpy
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	bc
;src/main.c:257: print_loc += len;
	ld	b, #0x00
	ld	hl, (_print_loc)
	add	hl, bc
	ld	(_print_loc), hl
;src/main.c:258: }
	ret
;src/main.c:263: print_str_sp(uint8_t *str)
;	---------------------------------
; Function print_str_sp
; ---------------------------------
_print_str_sp::
;src/main.c:265: print_str(str);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_print_str
	pop	af
;src/main.c:266: print_loc++;
	ld	hl, (_print_loc)
	inc	hl
	ld	(_print_loc), hl
;src/main.c:267: if ( print_loc > (32 * 24) ) {
	ld	hl, (_print_loc)
	xor	a, a
	cp	a, l
	ld	a, #0x03
	sbc	a, h
	jr	NC,00102$
;src/main.c:268: print_loc = 0;
	ld	hl, #0x0000
	ld	(_print_loc), hl
	ret
00102$:
;src/main.c:271: VDP_DATA_PORT = ' ';
	ld	a, #0x20
	out	(_VDP_DATA_PORT), a
;src/main.c:273: }
	ret
;src/main.c:278: print_nl(void)
;	---------------------------------
; Function print_nl
; ---------------------------------
_print_nl::
;src/main.c:280: print_loc += 32;
	ld	hl, (_print_loc)
	ld	bc, #0x0020
	add	hl, bc
;src/main.c:281: if ( print_loc > (32 * 24) ) {
	ld	(_print_loc), hl
	xor	a, a
	cp	a, l
	ld	a, #0x03
	sbc	a, h
	jr	NC,00102$
;src/main.c:282: print_loc = 0;
	ld	hl, #0x0000
	ld	(_print_loc), hl
	ret
00102$:
;src/main.c:286: print_loc &= 0xFFE0;
	ld	a, l
	and	a, #0xe0
	ld	l, a
	ld	(_print_loc), hl
;src/main.c:288: }
	ret
;src/main.c:293: print_str_nl(uint8_t *str)
;	---------------------------------
; Function print_str_nl
; ---------------------------------
_print_str_nl::
;src/main.c:295: print_str(str);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_print_str
	pop	af
;src/main.c:296: print_nl();
;src/main.c:297: }
	jp	_print_nl
;src/main.c:302: print_setxy(uint8_t x, uint8_t y)
;	---------------------------------
; Function print_setxy
; ---------------------------------
_print_setxy::
;src/main.c:304: print_loc = (y * 32) + x;
	ld	iy, #3
	add	iy, sp
	ld	l, 0 (iy)
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	dec	iy
	ld	c, 0 (iy)
	ld	b, #0x00
	add	hl, bc
	ld	(_print_loc), hl
;src/main.c:305: }
	ret
;src/main.c:310: disp_hex(uint8_t d)
;	---------------------------------
; Function disp_hex
; ---------------------------------
_disp_hex::
;src/main.c:312: VDP_DATA_PORT = hex[((d >> 4) & 0xF)];
	ld	bc, #_hex+0
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	rlca
	rlca
	rlca
	rlca
	and	a, #0x0f
	and	a, #0x0f
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	out	(_VDP_DATA_PORT), a
;src/main.c:313: VDP_DATA_PORT = hex[( d       & 0xF)];
	ld	a, 0 (iy)
	and	a, #0x0f
	ld	h, #0x00
	ld	l, a
	add	hl, bc
	ld	a, (hl)
	out	(_VDP_DATA_PORT), a
;src/main.c:314: VDP_DATA_PORT = ' ';
	ld	a, #0x20
	out	(_VDP_DATA_PORT), a
;src/main.c:315: }
	ret
;src/main.c:492: sd_send_cmd_ex(uint8_t cmd, uint8_t crc, uint8_t clk_speed)
;	---------------------------------
; Function sd_send_cmd_ex
; ---------------------------------
_sd_send_cmd_ex::
;src/main.c:497: SD_CTRL_PORT = clk_speed | CE_OFF;
	ld	iy, #4
	add	iy, sp
	ld	c, 0 (iy)
	ld	a, c
	or	a, #0x01
	out	(_SD_CTRL_PORT), a
;src/main.c:498: uint8_t d = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:500: SD_CTRL_PORT = clk_speed | CE_ON;
	ld	a, c
	out	(_SD_CTRL_PORT), a
;src/main.c:502: SD_DATA_PORT = cmd;
	dec	iy
	dec	iy
	ld	a, 0 (iy)
	out	(_SD_DATA_PORT), a
;src/main.c:506: for ( i = 0 ; i < sizeof(CMDARGS) ; i++ ) {
	ld	c, #0x00
00105$:
;src/main.c:507: SD_DATA_PORT = CMDARGS[i];
	ld	a, #<(_CMDARGS)
	add	a, c
	ld	e, a
	ld	a, #>(_CMDARGS)
	adc	a, #0x00
	ld	d, a
	ld	a, (de)
	out	(_SD_DATA_PORT), a
;src/main.c:508: CMDARGS[i] = 0;
	xor	a, a
	ld	(de), a
;src/main.c:506: for ( i = 0 ; i < sizeof(CMDARGS) ; i++ ) {
	inc	c
	ld	a, c
	sub	a, #0x04
	jr	C,00105$
;src/main.c:511: SD_DATA_PORT = crc;
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	out	(_SD_DATA_PORT), a
;src/main.c:515: for ( i = 255 ; i > 0 ; i-- )
	ld	c, #0xff
00107$:
;src/main.c:517: d = SD_DATA_PORT;
	in	a, (_SD_DATA_PORT)
;src/main.c:519: if ( d != NODATA ) {
	ld	b, a
	inc	a
	jr	NZ,00104$
;src/main.c:515: for ( i = 255 ; i > 0 ; i-- )
	dec	c
	ld	a, c
	jr	NZ,00107$
00104$:
;src/main.c:524: return d;
	ld	l, b
;src/main.c:525: }
	ret
;src/main.c:538: sd_send_cmd(uint8_t cmd, uint8_t crc, uint8_t clk_speed)
;	---------------------------------
; Function sd_send_cmd
; ---------------------------------
_sd_send_cmd::
;src/main.c:540: uint8_t d = sd_send_cmd_ex(cmd, crc, clk_speed);
	ld	iy, #4
	add	iy, sp
	ld	a, 0 (iy)
	push	af
	inc	sp
	dec	iy
	ld	a, 0 (iy)
	push	af
	inc	sp
	dec	iy
	ld	a, 0 (iy)
	push	af
	inc	sp
	call	_sd_send_cmd_ex
	pop	af
	inc	sp
	ld	c, l
;src/main.c:541: SD_CTRL_PORT = clk_speed | CE_OFF;
	ld	hl, #4+0
	add	hl, sp
	ld	a, (hl)
	or	a, #0x01
	out	(_SD_CTRL_PORT), a
;src/main.c:545: uint8_t eop = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:547: return d;
	ld	l, c
;src/main.c:548: }
	ret
;src/main.c:558: sd_card_init(void)
;	---------------------------------
; Function sd_card_init
; ---------------------------------
_sd_card_init::
;src/main.c:636: g_sd_addr_size = ADDR_BLOCK;
	ld	hl,#_g_sd_addr_size + 0
	ld	(hl), #0x01
;src/main.c:637: g_sd_type = SD_IS_UNKNOWN;
	ld	hl,#_g_sd_type + 0
	ld	(hl), #0x03
;src/main.c:640: SD_CTRL_PORT = CK_SLOW | CE_OFF;
	ld	a, #0x03
	out	(_SD_CTRL_PORT), a
;src/main.c:643: for ( i = 10 ; i > 0 ; i-- ) {
	ld	c, #0x0a
00140$:
;src/main.c:644: d = SD_DATA_PORT;
	in	a, (_SD_DATA_PORT)
;src/main.c:643: for ( i = 10 ; i > 0 ; i-- ) {
	dec	c
	ld	a, c
	jr	NZ,00140$
;src/main.c:648: d = sd_send_cmd(CMD0, CRC0, CK_SLOW);
	ld	de, #0x0295
	push	de
	ld	a, #0x40
	push	af
	inc	sp
	call	_sd_send_cmd
	pop	af
	inc	sp
;src/main.c:649: if ( d != R1_IDLE ) {
	dec	l
	jr	Z,00103$
;src/main.c:650: return SD_SPI_MODE_FAILED;
	ld	l, #0x02
	ret
00103$:
;src/main.c:656: CMDARGS[2] = VHS; CMDARGS[3] = CKPTRN;
	ld	hl, #(_CMDARGS + 0x0002)
	ld	(hl), #0x01
	ld	hl, #(_CMDARGS + 0x0003)
	ld	(hl), #0xaa
;src/main.c:657: d = sd_send_cmd_ex(CMD8, CRC8, CK_SLOW);
	ld	de, #0x0287
	push	de
	ld	a, #0x48
	push	af
	inc	sp
	call	_sd_send_cmd_ex
	pop	af
	inc	sp
;src/main.c:658: if ( d == R1_IDLE )
	dec	l
	jr	NZ,00114$
;src/main.c:663: d = SD_DATA_PORT; // don't care
	in	a, (_SD_DATA_PORT)
;src/main.c:664: d = SD_DATA_PORT; // don't care
	in	a, (_SD_DATA_PORT)
;src/main.c:665: i = SD_DATA_PORT; // echo VHS
	in	a, (_SD_DATA_PORT)
	ld	b, a
;src/main.c:666: d = SD_DATA_PORT; // echo Check Pattern
	in	a, (_SD_DATA_PORT)
	ld	c, a
;src/main.c:667: SD_CTRL_PORT = CK_SLOW | CE_OFF;
	ld	a, #0x03
	out	(_SD_CTRL_PORT), a
;src/main.c:668: eop = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:670: if ( i != VHS || d != CKPTRN ) {
	djnz	00104$
	ld	a, c
	sub	a, #0xaa
	jr	Z,00105$
00104$:
;src/main.c:671: return SD_BAD_CMD8_VOLTAGE;
	ld	l, #0x03
	ret
00105$:
;src/main.c:674: g_sd_type = SD_IS_SDHC;
	ld	hl,#_g_sd_type + 0
	ld	(hl), #0x01
	jr	00115$
00114$:
;src/main.c:682: d = sd_send_cmd_ex(CMD58, CRCX, CK_SLOW);
	ld	de, #0x0201
	push	de
	ld	a, #0x7a
	push	af
	inc	sp
	call	_sd_send_cmd_ex
	pop	af
	inc	sp
;src/main.c:683: if ( d > R1_IDLE ) {
	ld	a, #0x01
	sub	a, l
	jr	NC,00108$
;src/main.c:684: SD_CTRL_PORT = CK_SLOW | CE_OFF;
	ld	a, #0x03
	out	(_SD_CTRL_PORT), a
;src/main.c:685: eop = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:686: return SD_BAD_OCR_READ;
	ld	l, #0x04
	ret
00108$:
;src/main.c:694: i = SD_DATA_PORT; // don't care
	in	a, (_SD_DATA_PORT)
;src/main.c:695: i = SD_DATA_PORT; // bits 23..16
	in	a, (_SD_DATA_PORT)
	ld	b, a
;src/main.c:696: d = SD_DATA_PORT; // bit 15, 0x80 or 0x00
	in	a, (_SD_DATA_PORT)
;src/main.c:697: d &= 0x80; // make sure reserved bits don't interfere.
	and	a, #0x80
	ld	c, a
;src/main.c:698: if ( i == 0xFF ) {
	inc	b
	jr	NZ,00110$
;src/main.c:699: d++;
	inc	c
00110$:
;src/main.c:701: i = SD_DATA_PORT; // don't care
	in	a, (_SD_DATA_PORT)
;src/main.c:702: SD_CTRL_PORT = CK_SLOW | CE_OFF;
	ld	a, #0x03
	out	(_SD_CTRL_PORT), a
;src/main.c:703: eop = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:705: if ( d != 0x81 ) {
	ld	a, c
	sub	a, #0x81
	jr	Z,00112$
;src/main.c:706: return SD_BAD_OCR_VOLTAGE;
	ld	l, #0x05
	ret
00112$:
;src/main.c:709: g_sd_addr_size = ADDR_BYTE;
	ld	hl,#_g_sd_addr_size + 0
	ld	(hl), #0x00
;src/main.c:710: g_sd_type = SD_IS_SDSC;
	ld	hl,#_g_sd_type + 0
	ld	(hl), #0x00
00115$:
;src/main.c:717: i = sd_send_cmd(CMD55, CRCX, CK_SLOW);
	ld	de, #0x0201
	push	de
	ld	a, #0x77
	push	af
	inc	sp
	call	_sd_send_cmd
	pop	af
	inc	sp
	ld	b, l
;src/main.c:718: if ( g_sd_addr_size == ADDR_BLOCK ) {
	ld	a,(#_g_sd_addr_size + 0)
	dec	a
	jr	NZ,00117$
;src/main.c:721: CMDARGS[0] = HCS_YES;
	ld	hl, #_CMDARGS
	ld	(hl), #0x40
00117$:
;src/main.c:723: d = sd_send_cmd(ACMD41, CRCX, CK_SLOW);
	push	bc
	ld	de, #0x0201
	push	de
	ld	a, #0x69
	push	af
	inc	sp
	call	_sd_send_cmd
	pop	af
	inc	sp
	ld	a, l
	pop	bc
	ld	c, a
;src/main.c:725: if ( i > R1_IDLE || d > R1_IDLE )
	ld	a,#0x01
	cp	a,b
	jr	C,00120$
	sub	a, c
	jr	NC,00164$
00120$:
;src/main.c:728: d = sd_send_cmd(CMD1, CRCX, CK_SLOW);
	ld	de, #0x0201
	push	de
	ld	a, #0x41
	push	af
	inc	sp
	call	_sd_send_cmd
	pop	af
	inc	sp
	ld	c, l
;src/main.c:729: if ( d > R1_IDLE ) {
	ld	a, #0x01
	sub	a, c
	jr	NC,00119$
;src/main.c:730: return SD_MMC_FAILED;
	ld	l, #0x06
	ret
00119$:
;src/main.c:733: g_sd_type = SD_IS_MMC;
	ld	hl,#_g_sd_type + 0
	ld	(hl), #0x02
;src/main.c:739: for ( wait = 25000 ; wait > 0 && d == R1_IDLE ; wait-- )
00164$:
	ld	de, #0x61a8
00144$:
	ld	a, d
	or	a, e
	jr	Z,00126$
	ld	a, c
	dec	a
	jr	NZ,00126$
;src/main.c:741: if ( g_sd_type == SD_IS_MMC ) {
	ld	a,(#_g_sd_type + 0)
	sub	a, #0x02
	jr	NZ,00124$
;src/main.c:742: d = sd_send_cmd(CMD1, CRCX, CK_SLOW);
	push	de
	ld	de, #0x0201
	push	de
	ld	a, #0x41
	push	af
	inc	sp
	call	_sd_send_cmd
	pop	af
	inc	sp
	ld	a, l
	pop	de
	ld	c, a
	jr	00145$
00124$:
;src/main.c:744: d = sd_send_cmd(CMD55, CRCX, CK_SLOW);
	push	de
	ld	de, #0x0201
	push	de
	ld	a, #0x77
	push	af
	inc	sp
	call	_sd_send_cmd
	pop	af
	inc	sp
	ld	de, #0x0201
	push	de
	ld	a, #0x69
	push	af
	inc	sp
	call	_sd_send_cmd
	pop	af
	inc	sp
	ld	a, l
	pop	de
	ld	c, a
00145$:
;src/main.c:739: for ( wait = 25000 ; wait > 0 && d == R1_IDLE ; wait-- )
	dec	de
	jr	00144$
00126$:
;src/main.c:749: if ( wait == 0 ) {
	ld	a, d
	or	a, e
	jr	NZ,00128$
;src/main.c:750: return SD_INIT_TIMEOUT;
	ld	l, #0x07
	ret
00128$:
;src/main.c:753: if ( d != R1_READY ) {
	ld	a, c
	or	a, a
	jr	Z,00130$
;src/main.c:754: return SD_INIT_FAILED;
	ld	l, #0x08
	ret
00130$:
;src/main.c:762: if ( g_sd_addr_size == ADDR_BLOCK )
	ld	a,(#_g_sd_addr_size + 0)
	dec	a
	jr	NZ,00138$
;src/main.c:765: d = sd_send_cmd_ex(CMD58, CRCX, CK_SLOW);
	ld	de, #0x0201
	push	de
	ld	a, #0x7a
	push	af
	inc	sp
	call	_sd_send_cmd_ex
	pop	af
	inc	sp
;src/main.c:766: if ( d > R1_IDLE ) {
	ld	a, #0x01
	sub	a, l
	jr	NC,00132$
;src/main.c:767: return SD_BAD_SSC_READ;
	ld	l, #0x09
	ret
00132$:
;src/main.c:771: d = SD_DATA_PORT; // CSS is bit 0x40
	in	a, (_SD_DATA_PORT)
	ld	c, a
;src/main.c:772: i = SD_DATA_PORT; // don't care
	in	a, (_SD_DATA_PORT)
;src/main.c:773: i = SD_DATA_PORT; // don't care
	in	a, (_SD_DATA_PORT)
;src/main.c:774: i = SD_DATA_PORT; // don't care
	in	a, (_SD_DATA_PORT)
;src/main.c:775: SD_CTRL_PORT = CK_SLOW | CE_OFF;
	ld	a, #0x03
	out	(_SD_CTRL_PORT), a
;src/main.c:776: eop = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:778: if ( (d & CSS_BIT) == 0 ) {
	bit	6, c
	jr	NZ,00139$
;src/main.c:779: g_sd_addr_size = ADDR_BYTE;
	ld	hl,#_g_sd_addr_size + 0
	ld	(hl), #0x00
;src/main.c:780: g_sd_type = SD_IS_SDSC;
	ld	hl,#_g_sd_type + 0
	ld	(hl), #0x00
	jr	00139$
00138$:
;src/main.c:787: CMDARGS[2] = 0x02;
	ld	hl, #(_CMDARGS + 0x0002)
	ld	(hl), #0x02
;src/main.c:788: d = sd_send_cmd(CMD16, CRCX, CK_SLOW);
	ld	de, #0x0201
	push	de
	ld	a, #0x50
	push	af
	inc	sp
	call	_sd_send_cmd
	pop	af
	inc	sp
;src/main.c:789: if ( d > R1_IDLE ) {
	ld	a, #0x01
	sub	a, l
	jr	NC,00139$
;src/main.c:790: return SD_SET_BSIZE_FAILED;
	ld	l, #0x0a
	ret
00139$:
;src/main.c:794: return SD_CARD_OK;
	ld	l, #0x01
;src/main.c:795: }
	ret
;src/main.c:817: sd_read_block(uint32_t block_addr, uint8_t *dst)
;	---------------------------------
; Function sd_read_block
; ---------------------------------
_sd_read_block::
;src/main.c:819: if ( g_sd_addr_size == ADDR_BYTE ) {
	ld	a,(#_g_sd_addr_size + 0)
	or	a, a
	jr	NZ,00102$
;src/main.c:820: block_addr *= 512;
	ld	b, #0x09
00184$:
	ld	iy, #2
	add	iy, sp
	sla	0 (iy)
	rl	1 (iy)
	rl	2 (iy)
	rl	3 (iy)
	djnz	00184$
00102$:
;src/main.c:823: CMDARGS[0] = (uint8_t)(block_addr >> 24);
	ld	iy, #2
	add	iy, sp
	ld	c, 3 (iy)
	ld	hl, #_CMDARGS
	ld	(hl), c
;src/main.c:824: CMDARGS[1] = (uint8_t)(block_addr >> 16);
	inc	hl
	ld	c, 2 (iy)
	ld	(hl), c
;src/main.c:825: CMDARGS[2] = (uint8_t)(block_addr >>  8);
	ld	hl, #_CMDARGS + 2
	pop	de
	pop	bc
	push	bc
	push	de
	ld	(hl), b
;src/main.c:826: CMDARGS[3] = (uint8_t) block_addr;
	ld	bc, #_CMDARGS + 3
	ld	a, 0 (iy)
	ld	(bc), a
;src/main.c:830: d = sd_send_cmd_ex(CMD17, CRCX, CK_FAST);
	xor	a, a
	ld	d,a
	ld	e,#0x01
	push	de
	ld	a, #0x51
	push	af
	inc	sp
	call	_sd_send_cmd_ex
	pop	af
	inc	sp
	ld	a, l
;src/main.c:831: if ( d != R1_READY ) {
	or	a, a
	jr	Z,00135$
;src/main.c:832: SD_CTRL_PORT = CK_FAST | CE_OFF;
	ld	a, #0x01
	out	(_SD_CTRL_PORT), a
;src/main.c:833: eop = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:834: return SD_READ_BLOCK_FAILED;
	ld	l, #0x0b
	ret
;src/main.c:853: for ( count = 25000 ; count > 0 ; count-- )
00135$:
	ld	de, #0x61a8
00116$:
;src/main.c:855: d = SD_DATA_PORT;
	in	a, (_SD_DATA_PORT)
;src/main.c:857: if ( d == SD_START_TOKEN ||
	ld	b, a
	sub	a, #0xfe
	ld	a, #0x01
	jr	Z,00191$
	xor	a, a
00191$:
	ld	c, a
	or	a, a
	jr	NZ,00108$
;src/main.c:858: (d & SD_ERROR_TOKEN_TEST) == SD_ERROR_TOKEN ) {
	ld	a, b
	and	a, #0xf0
	jr	Z,00108$
;src/main.c:853: for ( count = 25000 ; count > 0 ; count-- )
	dec	de
	ld	a, d
	or	a, e
	jr	NZ,00116$
00108$:
;src/main.c:863: if ( d != SD_START_TOKEN ) {
	bit	0, c
	jr	NZ,00110$
;src/main.c:864: SD_CTRL_PORT = CK_FAST | CE_OFF;
	ld	a, #0x01
	out	(_SD_CTRL_PORT), a
;src/main.c:865: eop = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:866: return SD_TOKEN_TIMEOUT;
	ld	l, #0x0c
	ret
00110$:
;src/main.c:873: if ( dst == 0 )
	ld	hl, #6+1
	add	hl, sp
	ld	a, (hl)
	dec	hl
	or	a, (hl)
	jr	NZ,00141$
;src/main.c:876: for ( count = 512 ; count > 0 ; count-- )
	ld	bc, #0x0200
00118$:
;src/main.c:878: d = SD_DATA_PORT;
	in	a, (_SD_DATA_PORT)
	out	(_VDP_DATA_PORT), a
;src/main.c:876: for ( count = 512 ; count > 0 ; count-- )
	dec	bc
	ld	a, b
	or	a, c
	jr	NZ,00118$
	jr	00115$
;src/main.c:886: for ( count = 512 ; count > 0 ; count--, dst++ )
00141$:
	ld	bc, #0x0200
	ld	hl, #6
	add	hl, sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
00120$:
;src/main.c:888: d = SD_DATA_PORT;
	in	a, (_SD_DATA_PORT)
;src/main.c:889: *dst = d;
	ld	(de), a
;src/main.c:886: for ( count = 512 ; count > 0 ; count--, dst++ )
	dec	bc
	inc	de
	ld	a, b
	or	a, c
	jr	NZ,00120$
00115$:
;src/main.c:894: d = SD_DATA_PORT;
	in	a, (_SD_DATA_PORT)
;src/main.c:895: d = SD_DATA_PORT;
	in	a, (_SD_DATA_PORT)
;src/main.c:897: SD_CTRL_PORT = CK_FAST | CE_OFF;
	ld	a, #0x01
	out	(_SD_CTRL_PORT), a
;src/main.c:898: eop = SD_DATA_PORT; // required end-of-op 8-clocks
	in	a, (_SD_DATA_PORT)
;src/main.c:900: return SD_CARD_OK;
	ld	l, #0x01
;src/main.c:901: }
	ret
;src/main.c:921: sd_card_detect(uint8_t frame_tick)
;	---------------------------------
; Function sd_card_detect
; ---------------------------------
_sd_card_detect::
;src/main.c:927: uint8_t sample = (SD_CTRL_PORT & 0x80);
	in	a, (_SD_CTRL_PORT)
	and	a, #0x80
	ld	c, a
;src/main.c:929: switch ( state ) {
	ld	a, #0x04
	ld	iy, #_sd_card_detect_state_65536_87
	sub	a, 0 (iy)
	jr	C,00119$
	ld	e, 0 (iy)
	ld	d, #0x00
	ld	hl, #00152$
	add	hl, de
	add	hl, de
;src/main.c:930: case SD_ST_NOTFOUND :
	jp	(hl)
00152$:
	jr	00101$
	jr	00110$
	jr	00114$
	jr	00116$
	jr	00116$
00101$:
;src/main.c:931: if ( sample == 0x80 )
	ld	a, c
	sub	a, #0x80
	jr	NZ,00108$
;src/main.c:934: if ( frame_tick != 0 )
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z,00119$
;src/main.c:936: if ( delay > 20 ) {
	ld	a, #0x14
	ld	iy, #_sd_card_detect_delay_65536_87
	sub	a, 0 (iy)
	jr	NC,00103$
;src/main.c:937: delay = 0;
	ld	0 (iy), #0x00
;src/main.c:938: state = SD_ST_INIT;
	ld	hl,#_sd_card_detect_state_65536_87 + 0
	ld	(hl), #0x01
	jr	00119$
00103$:
;src/main.c:941: delay++;
	ld	hl, #_sd_card_detect_delay_65536_87+0
	inc	(hl)
	jr	00119$
00108$:
;src/main.c:948: delay = 0;
	ld	hl,#_sd_card_detect_delay_65536_87 + 0
	ld	(hl), #0x00
;src/main.c:951: break;
	jr	00119$
;src/main.c:953: case SD_ST_INIT :
00110$:
;src/main.c:955: g_sd_status = sd_card_init();
	call	_sd_card_init
	ld	a, l
	ld	(_g_sd_status+0), a
;src/main.c:956: if ( g_sd_status == SD_CARD_OK ) {
	ld	a,(#_g_sd_status + 0)
	dec	a
	jr	NZ,00112$
;src/main.c:957: state = SD_ST_FOUND;
	ld	hl,#_sd_card_detect_state_65536_87 + 0
	ld	(hl), #0x02
	jr	00119$
00112$:
;src/main.c:960: state = SD_ST_INITFAIL;
	ld	hl,#_sd_card_detect_state_65536_87 + 0
	ld	(hl), #0x03
;src/main.c:963: break;
	jr	00119$
;src/main.c:965: case SD_ST_FOUND :
00114$:
;src/main.c:970: state = SD_ST_READY;
	ld	hl,#_sd_card_detect_state_65536_87 + 0
	ld	(hl), #0x04
;src/main.c:971: break;
	jr	00119$
;src/main.c:983: case SD_ST_READY :
00116$:
;src/main.c:984: if ( sample != 0x80 )
	ld	a, c
	sub	a, #0x80
	jr	Z,00119$
;src/main.c:987: delay = 0;
	ld	hl,#_sd_card_detect_delay_65536_87 + 0
	ld	(hl), #0x00
;src/main.c:988: state = SD_ST_NOTFOUND;
	ld	hl,#_sd_card_detect_state_65536_87 + 0
	ld	(hl), #0x00
;src/main.c:992: }
00119$:
;src/main.c:994: return state;
	ld	iy, #_sd_card_detect_state_65536_87
	ld	l, 0 (iy)
;src/main.c:995: }
	ret
;src/main.c:1013: cart_detect(uint8_t frame_tick)
;	---------------------------------
; Function cart_detect
; ---------------------------------
_cart_detect::
;src/main.c:1021: uint8_t sample = peek(0x8000);
	ld	hl, #0x8000
	ld	c, (hl)
	inc	hl
	ld	a, (hl)
;src/main.c:1023: switch ( state ) {
	ld	iy, #_cart_detect_state_65536_98
	ld	a, 0 (iy)
	or	a, a
	jr	Z,00101$
	ld	a, 0 (iy)
	dec	a
	jr	Z,00111$
	jr	00115$
;src/main.c:1024: case CART_ST_NOTFOUND :
00101$:
;src/main.c:1025: if ( sample == 0x55 || sample == 0xAA )
	ld	a,c
	cp	a,#0x55
	jr	Z,00107$
	sub	a, #0xaa
	jr	NZ,00108$
00107$:
;src/main.c:1028: if ( frame_tick != 0 )
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z,00115$
;src/main.c:1030: if ( delay > 40 ) {
	ld	a, #0x28
	ld	iy, #_cart_detect_delay_65536_98
	sub	a, 0 (iy)
	jr	NC,00103$
;src/main.c:1031: delay = 0;
	ld	0 (iy), #0x00
;src/main.c:1032: state = CART_ST_FOUND;
	ld	hl,#_cart_detect_state_65536_98 + 0
	ld	(hl), #0x01
	jr	00115$
00103$:
;src/main.c:1035: delay++;
	ld	hl, #_cart_detect_delay_65536_98+0
	inc	(hl)
	jr	00115$
00108$:
;src/main.c:1043: delay = 0;
	ld	hl,#_cart_detect_delay_65536_98 + 0
	ld	(hl), #0x00
;src/main.c:1046: break;
	jr	00115$
;src/main.c:1048: case CART_ST_FOUND :
00111$:
;src/main.c:1049: if ( sample != 0x55 && sample != 0xAA )
	ld	a,c
	cp	a,#0x55
	jr	Z,00115$
	sub	a, #0xaa
	jr	Z,00115$
;src/main.c:1053: delay = 0;
	ld	hl,#_cart_detect_delay_65536_98 + 0
	ld	(hl), #0x00
;src/main.c:1054: state = CART_ST_NOTFOUND;
	ld	hl,#_cart_detect_state_65536_98 + 0
	ld	(hl), #0x00
;src/main.c:1058: }
00115$:
;src/main.c:1060: return state;
	ld	iy, #_cart_detect_state_65536_98
	ld	l, 0 (iy)
;src/main.c:1061: }
	ret
;src/main.c:1091: joystick_read(uint8_t frame_tick)
;	---------------------------------
; Function joystick_read
; ---------------------------------
_joystick_read::
;src/main.c:1096: uint8_t sample = CONT1_DATA_PORT;
	in	a, (_CONT1_DATA_PORT)
;src/main.c:1097: sample = ~sample;
	cpl
;src/main.c:1098: sample &= 0x4F;
	and	a, #0x4f
	ld	c, a
;src/main.c:1100: vdp_wr_addr(30);
	push	bc
	ld	hl, #0x001e
	push	hl
	call	_vdp_wr_addr
	pop	af
	pop	bc
;src/main.c:1101: VDP_DATA_PORT = hex[((sample&0xF0)>>4)];
	ld	e, c
	ld	a, e
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	sra	h
	rr	l
	sra	h
	rr	l
	sra	h
	rr	l
	sra	h
	rr	l
	ld	a, #<(_hex)
	add	a, l
	ld	l, a
	ld	a, #>(_hex)
	adc	a, h
	ld	h, a
	ld	a, (hl)
	out	(_VDP_DATA_PORT), a
;src/main.c:1102: VDP_DATA_PORT = hex[(sample&0x0F)];
	ld	a, e
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	ld	hl, #_hex
	add	hl, de
	ld	a, (hl)
	out	(_VDP_DATA_PORT), a
;src/main.c:1110: switch ( state ) {
	ld	iy, #_joystick_read_state_65536_107
	ld	a, 0 (iy)
	or	a, a
	jr	Z,00101$
	ld	a, 0 (iy)
	dec	a
	jr	Z,00110$
	ld	a, 0 (iy)
	sub	a, #0x02
	jr	Z,00125$
	jp	00128$
;src/main.c:1111: case JOY_ST_NONE :
00101$:
;src/main.c:1112: if ( sample != 0 )
	ld	a, c
	or	a, a
	jr	Z,00108$
;src/main.c:1115: if ( frame_tick != 0 )
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z,00129$
;src/main.c:1117: if ( delay > 4 ) {
	ld	a, #0x04
	ld	iy, #_joystick_read_delay_65536_107
	sub	a, 0 (iy)
	jr	NC,00103$
;src/main.c:1118: delay = 0;
	ld	0 (iy), #0x00
;src/main.c:1119: state = JOY_ST_SCAN;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x01
	jr	00129$
00103$:
;src/main.c:1122: delay++;
	ld	hl, #_joystick_read_delay_65536_107+0
	inc	(hl)
	jr	00129$
00108$:
;src/main.c:1129: delay = 0;
	ld	hl,#_joystick_read_delay_65536_107 + 0
	ld	(hl), #0x00
;src/main.c:1132: break;
	jr	00129$
;src/main.c:1134: case JOY_ST_SCAN :
00110$:
;src/main.c:1137: state = JOY_ST_WAIT;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x02
;src/main.c:1139: if ( (sample & 0x01) != 0 ) {
	bit	0, c
	jr	Z,00123$
;src/main.c:1140: state = JOY_ST_UP;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x03
	jr	00129$
00123$:
;src/main.c:1142: else if ( (sample & 0x04) != 0 ) {
	bit	2, c
	jr	Z,00120$
;src/main.c:1143: state = JOY_ST_DN;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x04
	jr	00129$
00120$:
;src/main.c:1145: else if ( (sample & 0x08) != 0 ) {
	bit	3, c
	jr	Z,00117$
;src/main.c:1146: state = JOY_ST_LT;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x05
	jr	00129$
00117$:
;src/main.c:1148: else if ( (sample & 0x02) != 0 ) {
	bit	1, c
	jr	Z,00114$
;src/main.c:1149: state = JOY_ST_RT;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x06
	jr	00129$
00114$:
;src/main.c:1151: else if ( (sample & 0x40) != 0 ) {
	bit	6, c
	jr	Z,00129$
;src/main.c:1152: state = JOY_ST_FIRE;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x07
;src/main.c:1155: break;
	jr	00129$
;src/main.c:1157: case JOY_ST_WAIT :
00125$:
;src/main.c:1160: if ( sample == 0 ) {
	ld	a, c
	or	a, a
	jr	NZ,00129$
;src/main.c:1161: delay = 0;
	ld	hl,#_joystick_read_delay_65536_107 + 0
	ld	(hl), #0x00
;src/main.c:1162: state = JOY_ST_NONE;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x00
;src/main.c:1165: break;
	jr	00129$
;src/main.c:1167: default :
00128$:
;src/main.c:1169: state = JOY_ST_WAIT;
	ld	hl,#_joystick_read_state_65536_107 + 0
	ld	(hl), #0x02
;src/main.c:1171: }
00129$:
;src/main.c:1173: return state;
	ld	iy, #_joystick_read_state_65536_107
	ld	l, 0 (iy)
;src/main.c:1174: }
	ret
;src/main.c:1179: swapin_real_cart(void)
;	---------------------------------
; Function swapin_real_cart
; ---------------------------------
_swapin_real_cart::
;src/main.c:1184: vdp_wtr(0x01, 0xC0);
	ld	de, #0xc001
	push	de
	call	_vdp_wtr
	pop	af
;src/main.c:1206: __endasm;
	ld	hl, #001$
	ld	de, #0x6000
	ld	bc, #002$ - #001$
	ldir
	jp	0x6000
	    001$:
	in	a, (0x55)
	jp	0x0000
	    002$:
	nop
;src/main.c:1207: }
	ret
;src/main.c:1212: main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	af
;src/main.c:1214: uint8_t nmi_last_cnt = 0;
;src/main.c:1218: uint8_t cursor = 1;
	ld	bc, #0x0100
;src/main.c:1224: vdp_wtr(0x00, 0x00);    // VR0 GM1
	push	bc
	xor	a, a
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_vdp_wtr
	pop	af
	ld	de, #0xc001
	push	de
	call	_vdp_wtr
	pop	af
	xor	a, a
	ld	d,a
	ld	e,#0x02
	push	de
	call	_vdp_wtr
	pop	af
	ld	de, #0x1003
	push	de
	call	_vdp_wtr
	pop	af
	ld	de, #0x0104
	push	de
	call	_vdp_wtr
	pop	af
	ld	de, #0x0a05
	push	de
	call	_vdp_wtr
	pop	af
	ld	de, #0x0206
	push	de
	call	_vdp_wtr
	pop	af
	ld	de, #0x1a07
	push	de
	call	_vdp_wtr
	ld	hl, #0x0020
	ex	(sp),hl
	ld	a, #0x1a
	push	af
	inc	sp
	ld	hl, #0x0400
	push	hl
	call	_vdp_memset
	pop	af
	inc	sp
	ld	hl,#0x0800
	ex	(sp),hl
	ld	hl, #_msx1_font
	push	hl
	ld	hl, #0x0800
	push	hl
	call	_vdp_memcpy
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	bc
;src/main.c:1240: CONT_JOY_PORT = 0;  // Any write selects the joystick
	ld	a, #0x00
	out	(_CONT_JOY_PORT), a
;src/main.c:1243: vdp_memset(0x0000, ' ', 32*24);
	push	bc
	ld	hl, #0x0300
	push	hl
	ld	a, #0x20
	push	af
	inc	sp
	ld	h, #0x00
	push	hl
	call	_vdp_memset
	pop	af
	pop	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_print_setxy
	ld	hl, #___str_1
	ex	(sp),hl
	call	_print_str_nl
	pop	af
	ld	de, #0xe001
	push	de
	call	_vdp_wtr
	pop	af
	pop	bc
;src/main.c:1252: while ( 1 )
00129$:
;src/main.c:1257: if ( nmi_last_cnt != nmi_count_g )
	ld	iy, #_nmi_count_g
	ld	a, 0 (iy)
	sub	a, c
	jr	Z,00129$
;src/main.c:1261: nmi_last_cnt = VDP_CTRL_PORT;
	in	a, (_VDP_CTRL_PORT)
;src/main.c:1262: nmi_last_cnt = nmi_count_g;
	ld	c, 0 (iy)
;src/main.c:1271: print_setxy(2, 1);
	push	bc
	ld	de, #0x0102
	push	de
	call	_print_setxy
	ld	hl, #___str_2
	ex	(sp),hl
	call	_print_str_sp
	ld	h,#0x01
	ex	(sp),hl
	inc	sp
	call	_sd_card_detect
	inc	sp
	pop	bc
	ld	iy, #1
	add	iy, sp
	ld	0 (iy), l
;src/main.c:1275: switch ( rtn ) {
	ld	a, #0x04
	sub	a, 0 (iy)
	jp	C, 00110$
	ld	e, 0 (iy)
	ld	d, #0x00
	ld	hl, #00204$
	add	hl, de
	add	hl, de
	add	hl, de
	jp	(hl)
00204$:
	jp	00104$
	jp	00105$
	jp	00107$
	jp	00106$
	jp	00109$
;src/main.c:1276: case SD_ST_NOTFOUND :
00104$:
;src/main.c:1277: print_str("NONE     "); break;
	push	bc
	ld	hl, #___str_3
	push	hl
	call	_print_str
	pop	af
	pop	bc
	jp	00110$
;src/main.c:1278: case SD_ST_INIT :
00105$:
;src/main.c:1279: print_str("INIT...  "); break;
	push	bc
	ld	hl, #___str_4
	push	hl
	call	_print_str
	pop	af
	pop	bc
	jp	00110$
;src/main.c:1280: case SD_ST_INITFAIL :
00106$:
;src/main.c:1281: print_str("ERROR:  ");
	push	bc
	ld	hl, #___str_5
	push	hl
	call	_print_str
	pop	af
	pop	bc
;src/main.c:1284: VDP_DATA_PORT = hex[(g_sd_status&0x0F)];
	ld	de, #_hex+0
	ld	a,(#_g_sd_status + 0)
	and	a, #0x0f
	ld	h, #0x00
	ld	l, a
	add	hl, de
	ld	a, (hl)
	out	(_VDP_DATA_PORT), a
;src/main.c:1285: break;
	jr	00110$
;src/main.c:1286: case SD_ST_FOUND :
00107$:
;src/main.c:1287: print_str("READING.."); 
	push	bc
	ld	hl, #___str_6
	push	hl
	call	_print_str
	ld	hl, #0x00a0
	ex	(sp),hl
	call	_vdp_wr_addr
	ld	hl, #0x6400
	ex	(sp),hl
	ld	hl, #0x0000
	push	hl
	ld	hl, #0x0800
	push	hl
	call	_sd_read_block
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	bc
;src/main.c:1295: for ( lp = 512 ; lp > 0 ; lp--, src++ ) {
	ld	de, #0x0200
	ld	hl, #0x6400
	ex	(sp), hl
00131$:
;src/main.c:1296: VDP_DATA_PORT = *src;
	pop	hl
	push	hl
	ld	a, (hl)
	out	(_VDP_DATA_PORT), a
;src/main.c:1295: for ( lp = 512 ; lp > 0 ; lp--, src++ ) {
	dec	de
	ld	iy, #0
	add	iy, sp
	inc	0 (iy)
	jr	NZ,00205$
	inc	1 (iy)
00205$:
	ld	a, d
	or	a, e
	jr	NZ,00131$
;src/main.c:1298: break;
	jr	00110$
;src/main.c:1299: case SD_ST_READY :
00109$:
;src/main.c:1300: print_str("YES: ");
	push	bc
	ld	hl, #___str_7
	push	hl
	call	_print_str
	pop	af
	pop	bc
;src/main.c:1301: print_str(g_sd_type_name[g_sd_type]);
	ld	de, #_g_sd_type_name+0
	ld	iy, #_g_sd_type
	ld	l, 0 (iy)
	ld	h, #0x00
	add	hl, hl
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	bc
	push	de
	call	_print_str
	pop	af
	pop	bc
;src/main.c:1303: }
00110$:
;src/main.c:1307: print_setxy(2, 2);
	push	bc
	ld	de, #0x0202
	push	de
	call	_print_setxy
	ld	hl, #___str_8
	ex	(sp),hl
	call	_print_str_sp
	ld	h,#0x01
	ex	(sp),hl
	inc	sp
	call	_cart_detect
	inc	sp
	ld	a, l
	pop	bc
;src/main.c:1310: if ( rtn == 0 ) {
	or	a, a
	jr	NZ,00112$
;src/main.c:1311: print_str("NONE");
	push	bc
	ld	hl, #___str_9
	push	hl
	call	_print_str
	ld	hl, #0x003a
	ex	(sp),hl
	ld	a, #0x20
	push	af
	inc	sp
	ld	hl, (_print_loc)
	push	hl
	call	_vdp_memset
	pop	af
	pop	af
	inc	sp
	pop	bc
;src/main.c:1313: have_cart = 0;
	xor	a, a
	ld	iy, #0
	add	iy, sp
	ld	0 (iy), a
	jr	00113$
00112$:
;src/main.c:1317: vdp_memcpy(print_loc, bp, 54);
	push	bc
	ld	hl, #0x0036
	push	hl
	ld	hl, #0x8024
	push	hl
	ld	hl, (_print_loc)
	push	hl
	call	_vdp_memcpy
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
	pop	bc
;src/main.c:1318: have_cart = 1;
	ld	iy, #0
	add	iy, sp
	ld	0 (iy), #0x01
00113$:
;src/main.c:1323: rtn = joystick_read(frame_tick);
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	call	_joystick_read
	inc	sp
	pop	bc
	ld	iy, #1
	add	iy, sp
	ld	0 (iy), l
;src/main.c:1325: if ( rtn == JOY_ST_UP ) {
	ld	a, 0 (iy)
	sub	a, #0x03
	jr	NZ,00117$
;src/main.c:1326: cursor--;
	dec	b
	jr	00118$
00117$:
;src/main.c:1328: else if ( rtn == JOY_ST_DN ) {
	ld	hl, #1+0
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ,00118$
;src/main.c:1329: cursor++;
	inc	b
00118$:
;src/main.c:1332: if ( cursor > 2 ) { cursor = 1; }
	ld	a, #0x02
	sub	a, b
	jr	NC,00120$
	ld	b, #0x01
00120$:
;src/main.c:1333: if ( cursor < 1 ) { cursor = 2; }
	ld	a, b
	sub	a, #0x01
	jr	NC,00122$
	ld	b, #0x02
00122$:
;src/main.c:1335: vdp_wr_addr(32); VDP_DATA_PORT = ' ';
	push	bc
	ld	hl, #0x0020
	push	hl
	call	_vdp_wr_addr
	pop	af
	pop	bc
	ld	a, #0x20
	out	(_VDP_DATA_PORT), a
;src/main.c:1336: vdp_wr_addr(64); VDP_DATA_PORT = ' ';
	push	bc
	ld	hl, #0x0040
	push	hl
	call	_vdp_wr_addr
	pop	af
	pop	bc
	ld	a, #0x20
	out	(_VDP_DATA_PORT), a
;src/main.c:1337: vdp_wr_addr((32 * cursor)); VDP_DATA_PORT = '>';
	ld	l, b
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	bc
	push	hl
	call	_vdp_wr_addr
	pop	af
	pop	bc
	ld	a, #0x3e
	out	(_VDP_DATA_PORT), a
;src/main.c:1339: if ( rtn == JOY_ST_FIRE )
	ld	iy, #1
	add	iy, sp
	ld	a, 0 (iy)
	sub	a, #0x07
	jp	NZ,00129$
;src/main.c:1341: if ( cursor == 2 && have_cart == 1 ) {
	ld	a, b
	sub	a, #0x02
	jp	NZ,00129$
	dec	iy
	ld	a, 0 (iy)
	dec	a
	jp	NZ,00129$
;src/main.c:1342: swapin_real_cart();
	push	bc
	call	_swapin_real_cart
	pop	bc
	jp	00129$
;src/main.c:1346: }
	pop	af
	ret
___str_1:
	.ascii "Devices Detected:"
	.db 0x00
___str_2:
	.ascii "SDCARD:"
	.db 0x00
___str_3:
	.ascii "NONE     "
	.db 0x00
___str_4:
	.ascii "INIT...  "
	.db 0x00
___str_5:
	.ascii "ERROR:  "
	.db 0x00
___str_6:
	.ascii "READING.."
	.db 0x00
___str_7:
	.ascii "YES: "
	.db 0x00
___str_8:
	.ascii "CART  :"
	.db 0x00
___str_9:
	.ascii "NONE"
	.db 0x00
	.area _CODE
___str_10:
	.ascii "SDSC"
	.db 0x00
___str_11:
	.ascii "SDHC"
	.db 0x00
___str_12:
	.ascii "MMC "
	.db 0x00
___str_13:
	.ascii "????"
	.db 0x00
	.area _INITIALIZER
__xinit__nmi_count_g:
	.db #0x00	; 0
__xinit__print_loc:
	.dw #0x0000
__xinit__g_sd_type_name:
	.dw ___str_10
	.dw ___str_11
	.dw ___str_12
	.dw ___str_13
__xinit__g_sd_addr_size:
	.db #0x01	; 1
__xinit__g_sd_status:
	.db #0x00	; 0
__xinit__g_sd_type:
	.db #0x03	; 3
__xinit__CMDARGS:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.area _CABS (ABS)
