# AVR Assembler
ASSEMBLER := avra

# Source file
SOURCE := Mylcd.asm

all: $(OUTPUT)

$(OUTPUT): $(SOURCE)
	$(ASSEMBLER) $(SOURCE)
clean:
	rm -f *.cof *.eep.hex *.obj *.bin
