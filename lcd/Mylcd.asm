.include "/home/isaacwilkie/MCU/include/tn85def.inc"
.include "/home/isaacwilkie/MCU/include/i2cdef.asm"
.include "/home/isaacwilkie/MCU/include/delay.asm"

.EQU RS = 0
.EQU RW = 1
.EQU EN = 2
.EQU D4 = 4
.EQU D5 = 5
.EQU D6 = 6
.EQU D7 = 7

LDI R16, HIGH(RAMEND)
OUT SPH, R16
LDI R16, LOW(RAMEND)
OUT SPL, R16

; initialize address
.DEF ADDRESS = R25
LDI ADDRESS, 0x27  ;according to datasheet 0100 a1 a2 a3
LSL ADDRESS
ORI ADDRESS, 1              ;write = 1, read = 0

.MACRO SEND_DATA
    LDI R25, @0     ;4 bit high data
    ANDI R25, 0xF0
    ORI R25, @1      ;RS, RW, EN
    SEND ADDRESS, R25
    RCALL ENABLE
    RCALL DELAY_5ms
    LDI R25, @0     ;4 bit low data
    ANDI R25, 0x0F
    SWAP R25
    ORI R25, @1      ;*, EN, RW, RS
    SEND ADDRESS, R25
    RCALL ENABLE
    RCALL DELAY_5ms
.ENDMACRO

SEND_DATA (0x03<<4), 0x0
SEND_DATA (0x03<<4), 0x0
SEND_DATA (0x03<<4), 0x0
SEND_DATA (0x02<<4), 0x0

SEND_DATA 0x01, 0x0
SEND_DATA 0x02, 0x0
SEND_DATA 0x0c, 0x0

; send message
SEND_DATA 0X72, (1<<RS)     ;"H"
SEND_DATA 0x73, (1<<RS)     ;"I"

END: RJMP END

ENABLE:
    LDI R26, 0x00
    ORI R26, (1<<EN)

    SEND ADDRESS, R25
    RCALL DELAY_50us
    EOR R25, R26
    SEND ADDRESS, R25       ;enable bit set
    RCALL DELAY_50us
    EOR R25, R26
    SEND ADDRESS, R25        ;enable bit clear
    RCALL DELAY_50us
RET

DELAY_5ms:
    delay 0x4E, 0x03    ;counter = 78, prescaler = clk/64
RET

DELAY_50us:
    delay 0x32, 0x01    ;counter = 50, prescaler = no prescaler
RET
