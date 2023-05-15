;
; ASMprogram.asm
;
; Created: 11/05/2023 10:59:19 AM
; Author : jkdow
;
.def temp = r16	 ; temp register
.def KPret = r17  ; the return for reading key press

.equ SP = 0xDF
.equ RP = 0xE0

.org 0x00
	rjmp start
.org 0x0E
	rjmp TIMER1_COMPA_ISR

start:
	cli 
    ldi temp, SP
	out 0x3D, temp

	call initGPIO
	call initTimer1
	sei 
	jmp loop

initGPIO:	; sets up the config for the program
	LDI TEMP, 0xF0
	OUT DDRC, TEMP
	LDI TEMP, 0xFF
	OUT PORTC, TEMP
	OUT DDRB, TEMP	
	LDI TEMP, 0x01
	OUT PORTB, TEMP
	ldi YL, RP
	clr YH 
	ret

initTimer1:
	;setup timer 1 (16 bit)
	;TCCR1A	0100 0000
	ldi temp, 0x40
	out TCCR1A, temp
	;TCCR1B 0000 1(000) () is prescaler - 0 is stop, 1=raw, 2=8, 3=64, 4=256, 5=1024
	;0x08 = off, 0x0C = on
	ldi temp, 0x0C
	out TCCR1B, temp
	// enable ISR
	in temp, TIMSK
	ori temp, 0b00010000
	out TIMSK, temp
	;OCR1AH, OCR1AL
	ldi temp, 0xF4
	out OCR1AH, temp
	ldi temp, 0x24
	out OCR1AL, temp
	;TIFR - OCF1A(bit 4) flag for compare  
  	RET

loop:
	; check for key press 
	call ReadKey
	; if not 0xFF then checkKP
	ldi temp, 0xFF
	cpse KPret, temp	; compare and skip if equal
	call checkKP
    jmp loop

checkKP:
	; if a number then enter into ram and inc ramPrt
	cpi KPret, 0xA
	brlo gotNum
	; if astrix then clear selection 
	cpi KPret, 0xA
	breq clearMem
	; if hash then changeFreq
	cpi KPret, 0xB
	breq changeFreq
	; else ignore press 
	ret

gotNum:
	; push to ram and inc pointer
	st Y+, kpRet
	ret

changeFreq:	; r16 = temp, r17 = ram counter, r18 = total_low, r19 = total_high
	; read from ram 
	clr r18
	clr r19
	ldi r17, 0x1 ; r17 will be counter
	cpi YH, 0
	brne changeFreqLoop
	cpi YL, RP
	brne changeFreqLoop
	;if you just hit # then stop clock
	ldi temp, 0x08
	out TCCR1B, temp
	ret
changeFreqLoop:
	ld temp, -Y
	mul temp, r17
	; add r1/r0 to total count
	add r18, r0
	adc r19, r1
	; multiply r17 by 10
	ldi temp, 10
	mul r17, temp
	mov r17, r0
	; check if we made it back
	cpi YH, 0
	brne changeFreqLoop
	cpi YL, RP
	brne changeFreqLoop
	; stop timer
	ldi temp, 0x08
	out TCCR1B, temp
	; update OCR
	call OCRdiv
	; start timer
	ldi temp, 0x0C
	out TCCR1B, temp
	ret

clearMem:
	clr YH
	ldi YL, RP
	ret

ReadKey:
	; check column 1
	LDI	temp, 0xEF			//load value to multiplex
	OUT PORTC, temp	
	RCALL Delay		//delay to allow time to show 
	IN R18, PINC	//check pinC
	CP temp, r18	//if not equal to port c then we found a key
	BRNE debounce	//call find key
	// col 2
	LDI	temp, 0xDF			
	OUT PORTC, temp
	RCALL Delay
	IN R18, PINC
	CP temp, r18
	BRNE debounce
	//compare
	LDI	temp, 0xBF			
	OUT PORTC, temp
	RCALL Delay
	IN R18, PINC
	CP temp, r18
	BRNE debounce
	//compare
	LDI	temp, 0x7F			
	OUT PORTC, temp
	RCALL Delay
	IN R18, PINC
	CP temp, r18
	BRNE debounce


findKey: 
	LDI ZH, high(codes << 1)		//load table address	
	LDI ZL, low(codes << 1)	
	ADD ZL, r18 	//add offset
	BRCS Zoverflow	//if overflow then also increment ZH
back:
	LPM KPret, Z	//load value form table
	RET
Zoverflow:
	INC ZH
	JMP back

debounce:
	in temp, pinc
	cp r18, temp
	breq debounce
	jmp findKey

OCRdiv: ;62500/(r18 and r19) and sets OCR
	push r20
	push r21
	push r22
	push r23
	push r24
	clr r20 ;counter low
	clr r21 ;counter high
	clr r24
OCRdivLoop:
	clr temp
	add r22, r18
	adc r23, r19
	adc r24, temp
	ldi temp, 1
	add r20, temp
	ldi temp, 0
	adc r21, temp 
	; check if we have hit condition 
	cpi r24, 0x00
	brne OCRdone
	cpi r23, 0xF4
	brlo OCRdivLoop
	cpi r22, 0x24
	brlo OCRdivLoop
OCRdone:
	in r18, SREG
	cli
	; update OCR
	out OCR1AH, r21
	out OCR1AL, r20
	clr temp
	out TCNT1H, temp
	out TCNT1L, temp
	out SREG, r18
	; pop registers and return
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	ret

ReadKeySim:
	ldi temp, 0
	in KPret, portc
	ret

delay:
	; a delay using timer 0 
	PUSH R16			; Save R16 and 17 as we're going to use them
	PUSH R17			; as loop counters
	PUSH R0			; we'll also use R0 as a zero value
	CLR R0
	CLR R16			; Init inner counter
	CLR R17			; and outer counter
L1: 
	DEC R16         ; Counts down from 0 to FF to 0
	CPSE R16, R0    ; equal to zero?
	RJMP L1			; If not, do it again
	CLR R16			; reinit inner counter
L2: 
	DEC R17
    CPSE R17, R0    ; Is it zero yet?
    RJMP L1			; back to inner counter

	POP R0          ; Done, clean up and return
	POP R17
	POP R16
    RET

TIMER1_COMPA_ISR:
	cli 
	push temp
	;clear timer finish bit 
	in temp, TIFR
	ori temp, 0b00010000
	out TIFR, temp
	;update LEDs
	in temp, PORTB
	lsl temp
	brcc ledOut
	ldi temp, 0x01
ledOut:
	out PORTB, temp
	pop temp
	sei 
	reti

codes:
	//	 0		1	  2	   3     4      5    6     7      8    9     A      B     C    D     E     F
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //0
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //1
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //2
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //3
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //4
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //5
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //6
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 15  , 0xff, 0xff, 0xff, 14  , 0xff, 13  , 12  , 0xff //7
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //8
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //9
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //A
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 11  , 0xff, 0xff, 0xff, 9   , 0xff, 6   , 3   , 0xff //B
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //C
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0   , 0xff, 0xff, 0xff, 8   , 0xff, 5   , 2   , 0xff //D
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 10  , 0xff, 0xff, 0xff, 7   , 0xff, 4   , 1   , 0xff //E
	.DB 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff //F
		
