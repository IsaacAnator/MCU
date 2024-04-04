
.EQU SDA = 0
.EQU SCL = 2

.ORG 0x0000

I2C_INIT:   LDI R16, (1<<USIWM1)
            ORI R16, (1<<USICS1)
            ORI R16, (1<<USICLK)
            OUT USICR, R16
            LDI R16, 0xFF
            OUT DDRB, R16
            LDI R16, (1<<SDA)
            ORI R16, (1<<SCL)
            OUT PORTB, R16
            RET
	 
I2C_START:
            CBI PORTB, SDA  ;SDA low
            RCALL DELAY
            CBI PORTB, SCL  ;SCL low
            RCALL DELAY
            RET

I2C_TRANSFER:
            LDI R31, 8
        BIT:
            SBI USICR, USITC    ;release CLK
        WAIT1:
            SBIS PORTB, SCL
            RJMP WAIT1
            RCALL DELAY
            SBI USICR, USITC    ;pull CLK low
            RCALL DELAY
            DEC R31
            BRNE BIT
            SBI USICR, USITC    ;release CLK
        ACK:
            IN R20, PINB
            CPI R20, (1<<SCL)
            ORI R20, (0<<SDA)
            BRNE ACK
            RCALL DELAY
            SBI USICR, USITC    ;pull CLK low
            CBI PORTB, SDA      ;SDA low
            RET

I2C_STOP:   SBI PORTB, SCL
            RCALL DELAY
            SBI PORTB, SDA
            RCALL DELAY
            RET

DELAY:      nop
            nop
            nop
            nop
            nop
            RET

.MACRO SEND
    RCALL I2C_INIT
    OUT USIDR, @0       ;address
    RCALL I2C_START
    RCALL I2C_TRANSFER
    OUT USIDR, @1       ;data
    RCALL I2C_TRANSFER
    RCALL I2C_STOP
.ENDMACRO

