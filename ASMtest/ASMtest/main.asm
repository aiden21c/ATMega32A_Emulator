;
; ASMtest.asm
;
; Created: 29/05/2023 2:11:43 AM
; Author : jkdow
;


; Replace with your application code
start:
    ldi r16, 0xff
	out DDRB, r16
	ldi r16, 0b10101010
	out portb, r16
    rjmp start
