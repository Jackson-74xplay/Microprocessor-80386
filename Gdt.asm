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
gdt resb 100
idt resb 100
msw resb 08
ldt resb 100
tr resb 100
dispbuff resb 04
;----------------------------------------------------------------------------------------------------

section .data

msg db "MAchine In Protected Mode",10
msglen equ $-msg

msgr db "MAchine In Real Mode",10
msglenr equ $-msgr

msg_gdt db "Contents of Gdt Are",10
msg_gdtL equ $-msg_gdt

msg_ldt db "Contents of Ldt Are",10
msg_ldtL equ $-msg_ldt

msg_idt db "Contents of Idt Are",10
msg_idtL equ $-msg_idt

msgc db ","
msgc_l equ $-msgc

msgb db "",10
msgb_l equ $-msgb

msg_tr db "Contents of Task Register Are",10
msg_trL equ $-msg_tr
;----------------------------------------------------------------------------------------------------
							;check status of machine

section .text
global _start
_start:
		smsw [msw]				;store machine status word
		MOV rax,[msw]
		ror rax,1				
		jc protected_mode     			;check if in protected mode
		write msgr,msglenr 
		jmp skip 
protected_mode: write msg,msglen


skip:  							;display the contents of GDTR
	   ;--------------------------------------------------------------------------
	   write msg_gdt,msg_gdtL
	   sgdt [gdt]
	   MOV bx,[gdt+4]
	   call display

	   MOV bx,[gdt+2]
	   call display

	   write msgc,msgc_l
	   MOV bx,[gdt]
	   call display
	   write msgb,msgb_l
	   						;display the contents of TR
	   ;--------------------------------------------------------------------------
	   write msg_tr,msg_trL
	   str [tr]
	   MOV bx,[tr]
	   call display
	   write msgb,msgb_l
	   						 ;display the contents of LDTR
	   ;--------------------------------------------------------------------------
	   write msg_ldt,msg_ldtL
	   sldt [ldt]
	   MOV bx,[ldt]
	   call display
	   write msgb,msgb_l
	  						 ;display the contents of IDT
	   ;--------------------------------------------------------------------------
	   write msg_idt,msg_idtL
	   sidt [idt]
	   MOV bx,[idt+4]
	   call display

	   MOV bx,[idt+2]
	   call display

	   write msgc,msgc_l
	   MOV bx,[idt]
	   call display
	   ;--------------------------------------------------------------------------


	   MOV rax,60
	   MOV rdi,1
	   syscall


;----------------------------------------------------------------------------------------------------
display:	MOV rdi,dispbuff  				;procedure to display count
		MOV rcx,04					;take number of digits to print as counter
up:     	rol bx,04					;rotate bx by 4
		MOV al,bl
		and al,0FH
		cmp al,09H					;compare al with 09h
		jg add_37H					;add 37H if greater else add 30H
		add al,30H
		jmp skip1
add_37H:	add al,37H
skip1:		MOV [rdi],al
	  	inc rdi
	  	dec rcx
	  	jnz up

	  	write dispbuff,04				;display count stored in dispbuff
	  	ret
;-----------------------------------------------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 Gdt.asm
;[Jackson97@localhost Mp]$ ld -o P Gdt.o
;[Jackson97@localhost Mp]$ ./P
;MAchine In Protected Mode
;Contents of Gdt Are
;02449000,007F
;Contents of Task Register Are
;0040
;Contents of Ldt Are
;0000
;Contents of Idt Are
;FF57B000,0FFF
;-------------------------------------------------------------------------------------------
