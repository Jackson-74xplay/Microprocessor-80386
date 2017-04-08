;------------------------------------------ MACRO DEFININTION---------------------------------------

%macro print 2
mov rax,1
mov rdi,1
mov rsi, %1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro
;----------------------------------------------------------------------------------------------------
section .data

menu db " 1- Block transfer without string ",10
     db " 2- Block transfer with string instuction ",10
     db " 3- Block transfer without string with replacement",10
     db " 4- Block transfer with string with replacement",10
     db " 5- Exit",10

menulen equ $-menu


msgg db "Error",10
msglll equ $-msgg

source dq 1234567890ABCDEFH,2345678901ABCDEFH,0AB234567891CDEF1H,9807654321ABCEFDH,8907124356ABCEFDH
dest dq 0000000000000000H, 0000000000000000H, 0000000000000000H, 0000000000000000H, 0000000000000000H
msgll db "IN 3",10
msglel equ $-msgll

position db 02
arrcnt db 05
colon db ':'
newline db 0AH
;----------------------------------------------------------------------------------------------------
section .bss						
dispbuff resb 16
choice resb 2

;----------------------------------------------------------------------------------------------------
section .text
global _start
_start:
menuu:	print menu,menulen


	read choice,2
	MOV al,byte[choice]
	cmp al,"1"
	je aa

	cmp al,"2"
	je b

	cmp al,"3"
	je c

	cmp al,"4"
	je d

	cmp al,"5"
	je EXIT




;-----------------------------------------------------------------------------------------------
aa:

	mov byte[arrcnt], 5
	mov rsi,source

again:
	mov rbx,rsi
	mov r8, rsi
	call display
	print dispbuff,16                             		; display source address
	print colon, 1

	mov rsi, r8
	mov rbx,[rsi]
	call display
	print dispbuff,16                                	 ; display source content
	print newline,1 	
	mov rsi,r8
	add rsi,08
	dec byte[arrcnt]
	jnz again



	mov rsi, source
	mov rdi, dest
	mov byte[arrcnt], 05


here: 	mov rax, [rsi]
	mov [rdi], rax                           		; copy contents of rsi to rdi
	add rsi, 08H						; increment by 8 to point to next number
	add rdi, 08H
	dec byte[arrcnt]
	jnz here

	mov rdi, dest
	mov byte[arrcnt], 05
	onceagain:mov rbx,rdi
	mov r8, rdi
	call display
	print dispbuff,16					; display destination addresses
	print colon, 1

 	mov rdi, r8
	mov rbx,[rdi]
	call display
	print dispbuff,16					; display destination contents
	print newline,1
	mov rdi,r8
	add rdi,08
	dec byte[arrcnt]
	jnz onceagain

	jmp menuu
;-------------------------------------------------------------------------------------------------------------------------------------------

b:
	mov byte[arrcnt], 5
	mov rsi,source

again2:
	mov rbx,rsi
	mov r8, rsi
	call display
	print dispbuff,16                            		 ; display source address
	print colon, 1

	mov rsi, r8
	mov rbx,[rsi]
	call display
	print dispbuff,16                                 	; display source content
	print newline,1
	mov rsi,r8	
	add rsi,08
	dec byte[arrcnt]
	jnz again2

	mov rsi, source
	mov rdi, dest
	mov byte[arrcnt], 05
	MOV rcx,05
	cld
	rep movsq
	;print msgll,msglel 
	


	MOV rdi,dest
	MOV byte[arrcnt],05


onceagain2:
	mov rbx,rdi
	mov r8, rdi
	call display
	print dispbuff,16					; display destination addresses
	print colon, 1
	
	 mov rdi, r8
	mov rbx,[rdi]
	call display
	print dispbuff,16					; display destination contents
	print newline,1
	mov rdi,r8
	add rdi,08
	dec byte[arrcnt]
	jnz onceagain2
	jmp menuu
;-----------------------------------------------------------------------------------------------------------------------------------------

c:



 
	mov byte[arrcnt], 5
	mov rsi,source

again3:
	mov rbx,rsi
	mov r8, rsi
	call display
	print dispbuff,16                             	   ; display source address
	print colon, 1

	mov rsi, r8
	mov rbx,[rsi]
	call display
	print dispbuff,16                                 ; display source content
	print newline,1
	mov rsi,r8
	add rsi,08
	dec byte[arrcnt]
	jnz again3

	MOV rdi,dest
	MOV rsi,source
	MOV al,00
	MOV rcx,05
	MOV byte[position],02



up6:	MOV rbx,[rsi]
	MOV [rdi],rbx
	
	
	add rsi,08H
	add rdi,08H
	inc al
	cmp byte[position],al
	jne cont
	MOV rsi,source

cont:	dec rcx
     	jnz up6


	mov rdi, dest
	mov byte[arrcnt], 05
onceagain6:	mov rbx,rdi
		mov r8, rdi	
		call display
		print dispbuff,16				; display destination addresses
		print colon, 1

 	mov rdi, r8
	mov rbx,[rdi]
	call display
	print dispbuff,16					; display destination contents
	print newline,1
	mov rdi,r8
	add rdi,08
	dec byte[arrcnt]
	jnz onceagain6
	
	jmp menuu
;---------------------------------------------------------------------------------
d: 
	mov byte[arrcnt], 5
	mov rsi,source

again4:
	mov rbx,rsi
	mov r8, rsi	
	call display
	print dispbuff,16                            	 ; display source address
	print colon, 1

	mov rsi, r8	
	mov rbx,[rsi]
	call display
	print dispbuff,16                                 ; display source content
	print newline,1
	mov rsi,r8
	add rsi,08
	dec byte[arrcnt]
	jnz again4



	MOV rdi,dest
	MOV rsi,source
	MOV al,00
	MOV rcx,02
	MOV byte[position],02
up7:	cld
	rep movsq
	
	cmp al,01H
	je exitt
	inc al
	MOV rsi,source
	MOV rcx,03
	jmp up7

exitt:

	mov rdi, dest
	mov byte[arrcnt], 05
	onceagain7:mov rbx,rdi
	mov r8, rdi
	call display
	print dispbuff,16					; display destination addresses
	print colon, 1

	 mov rdi, r8
	mov rbx,[rdi]
	call display
	print dispbuff,16					; display destination contents
	print newline,1
	mov rdi,r8
	add rdi,08
	dec byte[arrcnt]
	jnz onceagain7
	jmp menuu
	
	EXIT:
	mov rax ,60
	MOV rdi,1
	syscall
	
display:
	mov rdi,dispbuff
	mov rcx,16
up:
	rol rbx,04					;rotate function
	mov dl ,bl
	and dl,0FH
	cmp dl,09H

	jg a

	add dl,30H					;making hexadecimal
	jmp skip1
a: 	add dl,37H

skip1:
	mov [rdi],dl
	inc rdi
	dec rcx

	jnz up

	ret
;----------------------------------------------------------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 Block_t.asm
;[Jackson97@localhost Mp]$ ld -o P Block_t.o
;[Jackson97@localhost Mp]$ ./P
; 1- Block transfer without string 
; 2- Block transfer with string instuction 
;3- Block transfer without string with replacement
; 4- Block transfer with string with replacement
; 5- Exit
;1
;0000000000600844:1234567890ABCDEF
;000000000060084C:2345678901ABCDEF
;0000000000600854:AB234567891CDEF1
;000000000060085C:9807654321ABCEFD
;0000000000600864:8907124356ABCEFD
;000000000060086C:1234567890ABCDEF
;0000000000600874:2345678901ABCDEF
;000000000060087C:AB234567891CDEF1
;0000000000600884:9807654321ABCEFD
;000000000060088C:8907124356ABCEFD
; 1- Block transfer without string 
; 2- Block transfer with string instuction 
; 3- Block transfer without string with replacement
;4- Block transfer with string with replacement
; 5- Exit
;2
;0000000000600844:1234567890ABCDEF
;000000000060084C:2345678901ABCDEF
;0000000000600854:AB234567891CDEF1
;000000000060085C:9807654321ABCEFD
;0000000000600864:8907124356ABCEFD
;000000000060086C:1234567890ABCDEF
;0000000000600874:2345678901ABCDEF
;000000000060087C:AB234567891CDEF1
;0000000000600884:9807654321ABCEFD
;000000000060088C:8907124356ABCEFD
 ;1- Block transfer without string 
 ;2- Block transfer with string instuction 
 ;3- Block transfer without string with replacement
 ;4- Block transfer with string with replacement
 ;5- Exit
;3
;0000000000600844:1234567890ABCDEF
;000000000060084C:2345678901ABCDEF
;0000000000600854:AB234567891CDEF1
;000000000060085C:9807654321ABCEFD
;0000000000600864:8907124356ABCEFD
;000000000060086C:1234567890ABCDEF
;0000000000600874:2345678901ABCDEF
;000000000060087C:1234567890ABCDEF
;0000000000600884:2345678901ABCDEF
;000000000060088C:AB234567891CDEF1
; 1- Block transfer without string 
; 2- Block transfer with string instuction 
; 3- Block transfer without string with replacement
; 4- Block transfer with string with replacement
; 5- Exit
;4
;0000000000600844:1234567890ABCDEF
;000000000060084C:2345678901ABCDEF
;0000000000600854:AB234567891CDEF1
;000000000060085C:9807654321ABCEFD
;0000000000600864:8907124356ABCEFD
;000000000060086C:1234567890ABCDEF
;0000000000600874:2345678901ABCDEF
;000000000060087C:1234567890ABCDEF
;0000000000600884:2345678901ABCDEF
;000000000060088C:AB234567891CDEF1
; 1- Block transfer without string 
; 2- Block transfer with string instuction 
; 3- Block transfer without string with replacement
; 4- Block transfer with string with replacement
; 5- Exit
;5
;------------------------------------------------------------------------------------------------------------------
[Jackson97@localhost Mp]
