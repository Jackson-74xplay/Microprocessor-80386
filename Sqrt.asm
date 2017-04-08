;------------------------------------------ MACRO DEFININTION---------------------------------------
%macro write 2
MOV rax,1
MOV rdi,1
MOV rsi,%1
MOV rdx,%2
syscall
%endmacro
;----------------------------------------------------------------------------------------------------
section .bss
res rest 01
temp resd 01
disbuff resd 01
;----------------------------------------------------------------------------------------------------
section .data
msg_new db "",10
msg_newL equ $-msg_new

msg_comp db "The Roots are Complex",10
msg_c equ $-msg_comp


msg_rootOne db "The First Root is",10
msg_rootL equ $-msg_rootOne

msg_rootTwo db "The Second Root is",10
msg_rootLt equ $-msg_rootTwo

a1 dd 1.0
b1 dd 5.0
c1 dd 6.0
b_sq dd 0.0
four_ac dd 0.0
hdec dq 100
four dd 4.0
two dd 2.0
minus_o dd -1.0
decimal_pt db '.'
;----------------------------------------------------------------------------------------------------


section .text
global _start
_start:
		finit  					;initialize the 80387 co-processor
		fld dword[b1]				;load b1 on top of stack
		fmul dword[b1]				;multiply b1 with b1 of top of stack
		
		fld dword[four]				;load four value on next position on stack
		fmul dword[a1]				;multiply a1 value at stack pointer
		fmul dword[c1]				;multiply c1 value at stack pointer
		
		fsub st1,st0   				;sub 4ac from b^2 i.e sub top of stack from next stack position
		fbstp tword[res]
		fst dword[temp]				;store b^2-4ac in res to be used later
		fsqrt 					;take square root of top of stack 
		fst dword[res]
		fadd dword[b1]				;add b1 to top of stack
		fmul dword[minus_o]			
		fdiv dword[two]				;divide by 2
		fdiv dword[a1]				;divide by a1
		fimul dword[hdec]
		fbstp tword[res]			;store final root in res 
		
		

		write msg_rootOne,msg_rootL

		XOR rcx,rcx				;display for root
		MOV rcx,09H
		MOV r8,res+9H				

		call display_dec


		
		fld dword[temp]				;same method to find second root
		fsub dword[b1]
		fdiv dword[two]
		fdiv dword[a1]
		fimul dword[hdec]
		fbstp tword[res]

		write msg_new,msg_newL
		write msg_rootTwo,msg_rootLt
		XOR rcx,rcx
		MOV rcx,09H
		MOV r8,res+9H

		call display_dec

MOV rax,60
MOV rdi,1
syscall
								;normal display procedure
;----------------------------------------------------------------------------------------------------
display:
		MOV rdi,disbuff
		MOV rcx,02
again:		rol bl,04
		MOV al,bl
		and al,0FH
		cmp al,09H
		jg add_37H
		add al,30H
		jmp skip


add_37H:	add al,37H
		

skip:   	MOV [rdi],al
		inc rdi
		dec rcx
		jnz again
		ret

								;display procedure for printing decimal number
;----------------------------------------------------------------------------------------------------
display_dec:
up_again:	push rcx					;display first numbers before decimal point
		MOV bl,[r8]


		call display
		write disbuff,02

		dec r8
		pop rcx
				
		dec rcx
		jnz up_again


		write decimal_pt,01				;display decimal point


		MOV bl,[res]					;display 2 digits after decimal point
		call display
		write disbuff,02
		ret
;----------------------------------------------------------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 Sqrt.asm
;[Jackson97@localhost Mp]$ ld -o P Sqrt.o
;[Jackson97@localhost Mp]$ ./P
;The First Root is
;800000000000000003.00
;The Second Root is
;800000000000000002.00
;----------------------------------------------------------------------------------------------------
