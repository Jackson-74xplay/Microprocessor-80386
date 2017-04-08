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



%macro fopen 1
MOV rax,2
MOV rdi,%1
MOV rsi,2
MOV rdx,0777o
syscall
%endmacro
;---------------------------------------------------------------------------------------------------


%macro fwrite 3
MOV rax,1
MOV rdi,%1
MOV rsi,%2
MOV rdx,%3
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

%macro fclose 1
MOV rax,3
MOV rdi,%1
syscall 
%endmacro
;---------------------------------------------------------------------------------------------------

section .data
menu2 db "1)FIRST FILE 2)SECOND FILE"
menu2_len equ $-menu2

menu db "1)TYPE   2)WRITE   3)DELETE",10
menu_len equ $-menu

crrmsg db "File Opened",10
crrmsgl equ $-crrmsg


errmsg db "File Not Found",10
errmsg_l equ $-errmsg


msg db "correct",10
msglen equ $-msg

msgenter db "",10
msge_l equ $-msgenter
;---------------------------------------------------------------------------------------------------


section .bss
choice resb 02
choice2 resb 02

abuf_len1 resb 20
abuf_len2 resb 20
count resb 02

filename1 resb 40
filehandle1 resb 40
data resb 4096

filename2 resb 40
filehandle2 resb 40
data2 resb 4096
;---------------------------------------------------------------------------------------------------


section .text
global _start
_start:
			pop rcx
			pop rsi
			
			


next:			write menu,menu_len
			read choice,02
			MOV al,[choice]
			cmp al,'1'
			je TYPE


			cmp al,'2'
			je WRITE

			cmp al,'3'
			je DELETE

			jmp exit

;-------------------------------------------TYPE--------------------------------------------------------
TYPE:                  	pop rsi  					  ;pop the filename from system stack
			MOV rdi,filename1				  ;take entire filename in filename1
up1:			MOV al,[rsi]
			MOV [rdi],al
			inc rsi
			inc rdi
			cmp al,0
			jne up1
				           		
			

			fopen filename1                                   ;open file
			cmp rax,-1H 					  ;check if file is open
			jle errorm
			MOV [filehandle1],rax				  ;store filehandle from rax

			write crrmsg,crrmsgl

			fread [filehandle1],data,4096			  ;read the contents of the file and store in buffer
			MOV [abuf_len1],rax				  ;store the count of the contents read from file 
			write data,abuf_len1				  ;write the data to screen

			
			fclose filehandle1				  ;close file
			jmp exit
;----------------------------------------------WRITE-----------------------------------------------------

WRITE:			pop rsi						;pop the first filename from system stack
			MOV rdi,filename1				;take entire filename in filename1
up2:			MOV al,[rsi]
			MOV [rdi],al
			inc rsi
			inc rdi
			cmp al,0
			jne up2      		
			

			fopen filename1					;open file
			cmp rax,-1H					;check if file is open
			jle errorm
			MOV [filehandle1],rax				;store filehandle from rax
			fread [filehandle1],data,4096			;read the contents of the file and store in buffer
			MOV [abuf_len1],rax				;store the count of the contents read from file 
			
	
			
			pop rsi						;pop the second filename from system stack
			MOV rdi,filename2				;take entire filename in filename2
up3:			MOV al,[rsi]
			MOV [rdi],al
			inc rsi
			inc rdi
			cmp al,0
			jne up3  


			
			fopen filename2					;open file

			cmp rax,-1H					;check if file is open
			jle errorm
			MOV [filehandle2],rax				;store filehandle from rax
			fread [filehandle2],data2,4096			;read the contents of the file and store in buffer		
			MOV [abuf_len2],rax				;store the count of the contents read from file 
			
			fwrite [filehandle2],data,[abuf_len1]		;write contents from data to file 
			fclose filehandle2				;close file
			jmp exit
;-----------------------------------------------DELETE----------------------------------------------------
;---------------------------------------------------------------------------------------------------------
DELETE:                 write menu2,menu2_len
			read choice2,02
			MOV al,[choice2]
			cmp al,'1'
			je FILE1

			cmp al,'2'
			je FILE2

;-----------------------------------------------DELETE FILE 1----------------------------------------------------
FILE1:                  pop rsi
			MOV rdi,filename1
up4:			MOV al,[rsi]
			MOV [rdi],al
			inc rsi
			inc rdi
			cmp al,0
			jne up4     		
			
			fopen filename1
			MOV rax,87					;put 87 in rax 
			MOV rdi,filename1				;put the filename of the file you want to delete in rdi
			syscall
			jmp exit
;-----------------------------------------------DELETE FILE 2----------------------------------------------------

FILE2:                  pop rsi
			pop rsi
			MOV rdi,filename1
up5:			MOV al,[rsi]
			MOV [rdi],al
			inc rsi
			inc rdi
			cmp al,0
			jne up5
			
			pop rsi
			
			fopen filename1
			MOV rax,87
			MOV rdi,filename1
			syscall
			jmp exit

			
			           


errorm:
		write errmsg,errmsg_l

exit:
		MOV rax,60
		MOV rdi,1
		syscall
;---------------------------------------------------------------------------------------------------
;------------------------------------------TERMINAL---------------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 cmd.asm
;[Jackson97@localhost Mp]$ ld -o P cmd.o
;[Jackson97@localhost Mp]$ ./P abc.txt abc2.txt
;1)TYPE   2)WRITE   3)DELETE
;1
;File Opened
;qwertrtyu
;addddwwqwdwdw
;-----------------------------------------FILE BEFORE-----------------------------------------------------
;xczvsvswdwqqdqwdwdwqd
;vcaqwdwqwqqwd
;1)TYPE   2)WRITE   3)DELETE
;2
;-----------------------------------------FILE AFTER-------------------------------------------------------
;xczvsvswdwqqdqwdwdwqd
;vcaqwdwqwqqwd
;qwertrtyu
;addddwwqwdwdw
;-----------------------------------------------------------------------------------------------------------
;1)TYPE   2)WRITE   3)DELETE
;3
;1)FIRST FILE 2)SECOND FILE1
;First File Deleted
;-----------------------------------------------------------------------------------------------------------

