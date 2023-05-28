;
; AssemblerApplication1.asm
;
; Created: 25/05/2023 5:21:06 AM
; Author : jkdow
;


; Replace with your application code
start:
nop
adc r1, r3
add r16, r16 
and r1, r20
brcc start
brcs start
breq start
brne start
brlo start
call start 
cli
clr r19
cp r15, r25
cpi r16, 0x55
cpse r11, r10 
dec r21
eor r1, r2
in r15, PORTB 
inc r15
jmp start
LD r22, Y+
ldi r16, 0x1f
lds r2, 0x003f
lpm r5, Z
lsl r15
lsr r16
mov r1, r2
mul r5, r7
or r5, r6
ori r17, 0x20
out PORTB, r15
pop r19
push r4
rcall start
ret 
reti 
rjmp start
rol r15
ror r19
sei 
st -Y, r6
sts 0x0050, r15
sub r4, r5
subi r18, 0x40
