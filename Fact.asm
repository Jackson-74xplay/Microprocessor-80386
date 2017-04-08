;------------------------------------------ MACRO DEFININTION---------------------------------------
%macro read 2
MOV rax,0
MOV rdi,0
MOV rsi,%1
MOV rdx,%2
syscall
%endmacro
;---------------------------------------------------------------------------------------------------

%macro write 2
MOV rax,1
MOV rdi,1
MOV rsi,%1
MOV rdx,%2
syscall
%endmacro
;---------------------------------------------------------------------------------------------------

%macro fread 3
MOV rax,0
MOV rdi,%1
MOV rsi,%2
MOV rdx,%3
syscall 
%endmacro
;---------------------------------------------------------------------------------------------------

%macro fopen 1
MOV rax,2
MOV rdi,%1
MOV rsi,2
MOV rdx,0777o
syscall 
%endmacro
;---------------------------------------------------------------------------------------------------

section .data
num_oo db "Factorial is One",10
num_ms equ $-num_oo


msg db "ss",10
msgl equ $-msg


newl db "",10
newlen equ $-newl


factorial dq 1
count db 0
;---------------------------------------------------------------------------------------------------

section .bss
number resb 02
number2 resb 02

dispbufff resb 04
;---------------------------------------------------------------------------------------------------

section .text
global _start
_start:
		pop rcx				;pop the number of command line arguments
		pop rsi				;pop address of .exe file 
		pop rsi				;pop the number whose factorial to be calculated

		MOV al,[rsi]			;convert the number 
		cmp al,39H
		jg sub_37H
		sub al,30H
		jmp skip
sub_37H:	sub al,37H
		
  
skip:
		call facto
		MOV bx,[factorial]		;display factorial
		call display
		
		MOV rax,60
		MOV rdi,1
		syscall
;---------------------------------------DISPLAY PROC------------------------------------------------------------


display:	MOV rdi,dispbufff
		MOV rcx,04
up3:    	rol bx,04		
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
	  	jnz up3
	  	write dispbufff,04
	  	ret

;---------------------------------------------------------------------------------------------------

facto: 
		push ax					;push the number on system stack
		inc byte[count]				
		cmp ax,01H				;compare the number with 01H
		jne ahead				;till number does not become 01H if number 01H jump to mult
		jmp mult
ahead:     	dec ax					;decrement number till it becomes 01H
		jmp facto		

			
mult:
		pop ax					;pop the number from system stack
		MUL qword[factorial]			;multiply factorial with the number 
		MOV qword[factorial],rax		;store result again in factorial
		dec byte[count]
		jnz mult
		ret
;------------------------------------------------------------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 Fact.asm
;[Jackson97@localhost Mp]$ ld -o P Fact.o
;[Jackson97@localhost Mp]$ ./P 3
;0006
;-------------------------------------------------------------------------------------------------------
