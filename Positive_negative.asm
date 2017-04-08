;------------------------------------------ MACRO DEFININTION---------------------------------------
%macro write 2
		MOV rax,1
		MOV rdi,1
		MOV rsi,%1
		MOV rdx,%2
		syscall
%endmacro
;---------------------------------------------------------------------------------------------------
segment .bss
P_count db 0
N_count db 0
dispbufff resb 02

;---------------------------------------------------------------------------------------------------
section .data
msg_new db "",10
msg_nL equ $-msg_new

msg_p db "Positive Numbers Are",10
msg_pLen equ $-msg_p

msg_n db "Negative  Numbers Are",10
msg_nLen equ $-msg_n

array dq 1234567891234567h,0A123456789BCE123h,0ABCDEF1234567891h,1234567891234567h,0A123456789BCE123h,0ABCDEF1234567891h,

;---------------------------------------------------------------------------------------------------------
section .text
global _start
_start:
		MOV rsi,array				;Stores Address of array
		MOV rcx,06H				;Take counter as 6
addsd:		MOV rbx,[rsi]
		bt rbx,63				;Check positive or negative 
		jc negative				;jmp to increment negative if carry present i.e.negative number
		inc byte[P_count]			;increment positive counter
		jmp agg

negative:
		inc byte[N_count]			;increment negative counter

		
agg:
	add rsi,08H					;point to next number in array
	dec rcx						;decrement counter
	jnz addsd					;continue till elements present in array

	MOV bl,byte[P_count]
	write msg_p,msg_pLen
	call display					;display positive count
	
	write msg_new,msg_nL

	MOV bl,byte[N_count]
	write msg_n,msg_nLen
	call display					;display negative count

	write msg_new,msg_nL
	MOV rax,60
	MOV rdi,1
	syscall


;--------------------------------------------------------------------------------------------------------------
display:	MOV rdi,dispbufff			;procedure to display count
		MOV rcx,02				;take number of digits to print as counter
up:     	rol bl,04				;rotate bl by 4

		MOV al,bl
		and al,0FH
		cmp al,09H				;compare al with 09h
		jg add_37H				;add 37H if greater else add 30H
		add al,30H
		jmp skip1

add_37H:	add al,37H				
skip1:		MOV [rdi],al
		inc rdi
		dec rcx
		jnz up

		write dispbufff,02			;display count stored in dispbuff
		ret

;----------------------------------------------------------------------------------------------
;[Jackson97@localhost ~]$ nasm -f elf64 Positive_negative.asm
;[Jackson97@localhost ~]$ ld -o P Positive_negative.o
;[Jackson97@localhost ~]$ ./P
;Positive Numbers Are
;02
;Negative  Numbers Are
;04
;----------------------------------------------------------------------------------------------




	
