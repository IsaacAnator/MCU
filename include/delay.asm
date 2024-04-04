; inlcude this file using .include "/home/isaacwilkie/MCU/include/delay.asm"
; to call, use "delay 0x00, 0x00" where the first number is the number of clk
; cycles and the second sets the prescaling in CTC mode


.MACRO DELAY
PUSH R20
LDI R20, 0
OUT TCNT0, R20
LDI R20, @0
OUT OCR0A, R20
LDI R20, (1<<WGM01) ;sets CTC mode     ;
OUT TCCR0A, R20
LDI R20, @1     ;sets clock prescaling
OUT TCCR0B, R20
AGAIN:
    IN R20, TIFR
    SBRC R20, OCF0A
    RJMP AGAIN
LDI R20, 0X0            ;stop timer0
OUT TCCR0B, R20
LDI R20, (1<<OCF0A)     ;clear ocf0a flag
OUT TIFR, R20
POP R20
.ENDMACRO

