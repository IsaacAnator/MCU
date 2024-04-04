#define DDRB (*(volatile unsigned char*) 0x37)
#define PORTB (*(volatile unsigned char*) 0x38)

void delay(volatile long time) {
    while (time >0) {
        time--;
    }
}

int main(void) {
    DDRB |= (1<<1); //Blinks PORTB pin 1

    while (1) {
        PORTB ^= (1<<1);
        delay(10000);
    }
    return 0;
}
