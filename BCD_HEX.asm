;------------------------------------------ MACRO DEFININTION---------------------------------------
%macro read 2
MOV rax,0
MOV rdi,0
MOV rsi,%1
MOV rdx,%2
syscall
%endmacro

%macro write 2
MOV rax,1
MOV rdi,1
MOV rsi,%1
MOV rdx,%2
syscall
%endmacro
;----------------------------------------------------------------------------------------------------

section .data
msg_new db "",10
msg_nL equ $-msg_new

nummm dw 0FFFFh
ansss dw 0

msg db "1)HEX TO BCD",10
msgL equ $-msg

msgq db "2)BCD TO HEX",10
msgqL equ $-msgq


msge db "3)EXIT",10
msgeL equ $-msge
;-----------------------------------------------------------------------------------------------------

section .bss
number resb 05
ans resw 01
choice resb 02
count resb 01
dispbuff resb 04
dispbufff resb 04
number1 resb 06

;-----------------------------------------------------------------------------------------------------


section .text
global _start
_start:
		

AGGG:		write msg_new,msg_nL				;menu driven display 
		write msg,msgL
		write msgq,msgqL
		write msge,msgeL
		read choice,02					;accept choice for conversion
		MOV al,byte[choice]
		cmp al,"1"
		je HEX_BCD

		
		cmp al,"2"
		je BCD_HEX


		cmp al,"3"
		je EXIT



;-----------------------------------------------HEX_BCD CONVERT-----------------------------------------------------------
HEX_BCD:	read number,05					;take input for Hex number
		call accept					;convert number
		MOV ax,bx
		MOV rbx,0AH

back:		XOR rdx,rdx
		div rbx						;divide number by 10
		push dx						;push quotient on stack
		inc byte[count]
		cmp rax,0H
		jne back



pop_again:	pop dx						;pop contents of stack 
		add dl,30h					;add 30H to number popped
		MOV [dispbuff],dl			
		write dispbuff,01				;display digit by digit
		dec byte[count]
		jnz pop_again 
		jmp AGGG
;------------------------------------------------BCD-HEX CONVERT-----------------------------------------------------------
BCD_HEX:	read number1,06					;take input for BCD number
		MOV rsi,number1
		XOR rax,rax
		MOV rbx,10
		MOV rcx,05
				

back2:         	XOR rdx,rdx
		mul rbx						;multiply number by 10
		XOR rdx,rdx
		MOV dl,[rsi]
		sub dl,30H					;sub number by 30H
		add rax,rdx					;add number to previous number

		inc rsi
		dec rcx
		jnz back2


		MOV word[ansss],ax
		MOV bx,word[ansss]
		call display					;display Hex number
		jmp AGGG

EXIT:


		MOV rax,60
		MOV rdi,1
		syscall					;accept procedure i.e. convert
;-----------------------------------------------------------------------------------------------------

accept: 	MOV rsi,number
		MOV rcx,04
		MOV rbx,00
again:  	rol bx,04		
		MOV al,[rsi]
		cmp al,39H
		jg sub_37H
		sub al,30H
		jmp skip
sub_37H: 	sub al,37H			
skip: 		add bl,al
	        inc rsi
	  	dec rcx
	  	jnz again
	  	ret					;display procedure 
;-----------------------------------------------------------------------------------------------------
display:	MOV rdi,dispbufff
		MOV rcx,04
up:     	rol bx,04		
		MOV al,bl
		and al,0FH
		cmp al,09H
		jg add_37H
		add al,30H
		jmp skip1

add_37H:	add al,37H
skip1:		MOV [rdi],al
	  	inc rdi
	 	 dec rcx
	  	jnz up
	  	write dispbufff,04
	  	ret
;-----------------------------------------------------------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 BCD_HEX.asm
;[Jackson97@localhost Mp]$ ld -o P BCD_HEX.o
;[Jackson97@localhost Mp]$ ./P

;1)HEX TO BCD
;2)BCD TO HEX
;3)EXIT
;1
;FFFF
;65535
;1)HEX TO BCD
;2)BCD TO HEX
;3)EXIT
;2
;65535
;FFFF
;1)HEX TO BCD
;2)BCD TO HEX
;3)EXIT
;3
;---------------------------------------------------------------------------------------------------------

