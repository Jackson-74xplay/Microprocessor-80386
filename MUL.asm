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
;---------------------------------------------------------------------------------------------------
segment .bss

number resb 03
number_one resb 02
number_two resb 02
product resb 04
product2 resb 04
dispbuff resb 04
choice resb 02
;---------------------------------------------------------------------------------------------------
segment .data

msg_new db "",10
msg_nL equ $-msg_new

msg db "The product of two numbers is",10
msg_len equ $-msg

msgc_h db "Enter the choice"
msgc_hlen equ $-msgc_h

msgg db "1)Successive ADD 2)Shift ANd ADD 3)EXit",10
msgg_len equ $-msgg
count db 8
num1 db 12
num2 db 12
;---------------------------------------------------------------------------------------------------

segment .text
global _start
_start:

AGGG:		write msg_new,msg_nL
		write msgc_h,msgc_hlen
		write msgg,msgg_len
		read choice,02
		MOV al,byte[choice]
		cmp al,"1"
		je SA


		cmp al,"2"
		je SD

		cmp al,33H
		je EX

;--------------------------------------------------------------------------------------------------
SA:		read number,03						;take input for first number
		call accept
		MOV byte[number_one],bl
		

		

		read number,03						;take input for second number
		call accept
		MOV byte[number_two],bl
		

		XOR ax,ax
		XOR bx,bx
		MOV al,byte[number_one]
		MOv bl,byte[number_two]
		
aggg:		add word[product],ax					;add first number to itself till second number becomes zero
		dec bl
		jnz aggg

		MOV bx,word[product]					;take result in bx and display
		call display
		jmp AGGG
;------------------------------------------------------------------------------------------------------------		
SD:		read number,03						;take input for first number
		call accept
		MOV byte[number_one],bl
			
		read number,03						;take input for second number			
		call accept
		MOV byte[number_two],bl
		
		

		
		MOV al,byte[number_one]
		MOV bl,byte[number_two]
		
		

up2:		shr bl,01						;shift second number to right
		jnc a							;check for carry
		add word[product2],ax					;if carry present add else only left shift
		
a:              shl ax,01						;shift first number to the left
		dec byte[count]
		jnz up2
		

		
		MOV bx,word[product2]					;take result in bx and display			
		call display
		jmp AGGG

EX:





MOV rax,60
MOV rdi,1
syscall
;------------------------------------------------ACCEPT PROC-----------------------------------------------------------------




accept: 	MOV rsi,number
		MOV rcx,02
		MOV rbx,00
again:  	rol bl,04		
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
	  	ret
;--------------------------------------------------DISPLAY PROC----------------------------------------------------------------------


display:	MOV rdi,dispbuff
		MOV rcx,08
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
	  	write dispbuff,04
	  	ret
;---------------------------------------------------------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 MUL.asm
;[Jackson97@localhost Mp]$ ld -o P MUL.o
;[Jackson97@localhost Mp]$ ./P 

;Enter the choice1)Successive ADD 2)Shift ANd ADD 3)EXit
;1
;FF
;FF
;FE01
;Enter the choice1)Successive ADD 2)Shift ANd ADD 3)EXit
;2
;FF
;FF
;FE01
;Enter the choice1)Successive ADD 2)Shift ANd ADD 3)EXit
;3
;-------------------------------------------------------------------------------------------------------
