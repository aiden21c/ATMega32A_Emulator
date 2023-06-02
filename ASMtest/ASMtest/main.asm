;
; ASMtest.asm
;
; Created: 29/05/2023 2:11:43 AM
; Author : jkdow
;
.def temp = r16

; Replace with your application code
init:
    ldi r16, 0xff
	out DDRB, r16
	
    ldi temp, 0x40
	out TCCR1A, temp
	;TCCR1B 0000 1(000) () is prescaler - 0 is stop, 1=raw, 2=8, 3=64, 4=256, 5=1024
	;0x08 = off, 0x0C = on
	ldi temp, 0x0C
	out TCCR1B, temp
	;OCR1AH, OCR1AL
	ldi temp, 0xF4
	out OCR1AH, temp
	ldi temp, 0x24
	out OCR1AL, temp

loop:
	ldi r16, 0b00010000
	in r17, TIFR
	and r16, r17
	cpi r16, 0b00000000
	breq loop
	ldi r16, 0b00010000
	or r17, r16
	out TIFR, r17
	in r16, portb
	inc r16
	out portb, r16 
	rjmp loop
