;------------------------------------------ MACRO DEFININTION---------------------------------------
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
msg_newL equ $-msg_new

msg_mean db "The Mean is",10
msg_mLen equ $-msg_mean


msg_var db "The Variance is",10
msg_vL equ $-msg_var

msg_sd db "The Standard Deviation is",10
msg_dL equ $-msg_sd

data dd 102.59,198.21,100.67
array dd 0.0,0.0,0.0
datacnt dw 03
hdec dq 100
decimal_pt db '.'
;----------------------------------------------------------------------------------------------------

section .bss
number resd 01
disbuff resd 01
mean resd 01
res rest 01
sd rest 01
;----------------------------------------------------------------------------------------------------
section .text
global _start
_start:
;--------------------------------------------------MEAN----------------------------------------------
				write msg_mean,msg_mLen         
				finit					;initialize the 80387 co-processor
				fldz					
				MOV rbx,data				;rbx points to data array
				MOV rsi,00
				MOV rcx,[datacnt]			;take counter of number of elements 


up:				fadd dword[rbx+rsi*4]			;add all numbers in data together
				inc rsi
				dec cx
				jnz up



				fidiv word[datacnt]			;divide by number of elements
				fst dword[mean]				;store mean

				fimul dword[hdec]			;multiply mean with multiple of 10 with how many decimal points 
				fbstp tword[res]

				XOR rcx,rcx
				MOV rcx,09H
				MOV r8,res+9H

				call display_dec
;----------------------------------------------------------------------------------------------------
;----------------------------------------------VARIANCE----------------------------------------------				
				write msg_new,msg_newL    		;function to find variance
				write msg_var,msg_vL
				MOV rcx,[datacnt]
				MOV r8,array				;point r8 to array			
				MOV rbx,data				;point rbx to data
again2:				fldz 
				fld dword[rbx]				
				fsub dword[mean]			;sub number with mean calculated earlier
				fst dword[number]
				fmul dword[number]			;take square of result
				fst dword[r8]				;put number in array
				add rbx,4				;increment r8 to point to next position
				add r8,4				;increment rbx to point to next position
				dec cx
				jnz again2

				fldz 
				MOV rbx,array
				MOV rsi,00
				MOV rcx,[datacnt]

up3:				fadd dword[rbx+rsi*4]			;add all numbers in data together
				inc rsi
				dec cx
				jnz up3

				fidiv word[datacnt]			;divide by number of elements
				fst dword[mean]				;store Variance
				fimul dword[hdec]
				fbstp tword[res]

				XOR rcx,rcx
				MOV rcx,09H
				MOV r8,res+9H
				
				call display_dec

;----------------------------------------------------------------------------------------------------
;----------------------------------------------STANDARD DEVIATION------------------------------------
				write msg_new,msg_newL
				write msg_sd,msg_dL
				fldz								
				fld dword[mean]				;load variance on top of stack				
				fsqrt 					;take sqrt of variance to find standard deviation
				
				fimul dword[hdec]
				fbstp tword[res]

				XOR rcx,rcx
				MOV rcx,09H
				MOV r8,res+9H
				
				call display_dec






				MOV rax,60
				MOV rdi,1
				syscall

;----------------------------------------------------------------------------------------------------
display:								;display normal to print 2 digits at a time
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






;----------------------------------------------------------------------------------------------------
display_dec:								;display to print decimal number
up_again:		push rcx
			MOV bl,[r8]


			call display
			write disbuff,02

			dec r8
			pop rcx
				
			dec rcx
			jnz up_again


			write decimal_pt,01


			MOV bl,[res]
			call display
			write disbuff,02
			ret
;----------------------------------------------------------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 Mean.asm
;[Jackson97@localhost Mp]$ ld -o P Mean.o
;[Jackson97@localhost Mp]$ ./P
;The Mean is
;000000000000000133.82
;The Variance is
;000000000000002073.44
;The Standard Deviation is
;000000000000000045.54
;-------------------------------------------------------------------------------------------------------

