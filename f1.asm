;----------------------------------------------FIRST PROGRAM------------------------------------------------------
;------------------------------------------ MACRO DEFININTION---------------------------------------
%macro read 2
	mov	rax,0
	mov	rdi,0
    mov	rsi,%1
    mov	rdx,%2
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro print 2
	mov	rax,1
	mov	rdi,1
	mov	rsi,%1
	mov	rdx,%2
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro fopen 1
	mov	rax,2
	mov	rdi,%1
	mov	rsi,2
	mov	rdx,0777o
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro fread 3
	mov	rax,0
    	mov	rdi,%1
	mov	rsi,%2
	mov	rdx,%3
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro fwrite 3
	mov	rax,1
	mov	rdi,%1
	mov	rsi,%2
	mov	rdx,%3
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro fclose 1
	mov	rax,3
	mov	rdi,%1
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------

Extern far_proc							;procedure defined in another file

global filename,filehandle,buf,abuf,char			;declared global can be used in another file
;---------------------------------------------------------------------------------------------------
section .data

filemsg db "Enter file name "
filemsglen equ $-filemsg

charmsh db "Enter char to search "
charl equ $-charmsh

errmsg db "error in opening file "
errmsglen equ $-errmsg
;---------------------------------------------------------------------------------------------------
section .bss

buf resb 4096
buflen equ $-buf

abuf resq 1

filename resb 50
filehandle resq 1
char resb 2
;---------------------------------------------------------------------------------------------------
section .text

global _start

_start:

    print filemsg,filemsglen
    read filename,50						;take filename from user
    dec rax
    mov byte[filename+rax],0					;add \0 at end of file

    fopen filename						;open file
    
    cmp rax,-1H							;check if file is open
    jle error
   
    mov [filehandle],rax					;store filehandle from rax

    print charmsh,charl
    read char,2							;take input of charachter to be searched
     
    fread [filehandle],buf, buflen				;read the contents of the file and store in buffer
    mov [abuf],rax						;store the count of the contents read from file 
     
    call far_proc						;written in another program
    jmp	exit

error:
    print errmsg, errmsglen

exit:
    mov rax,60
    MOV rdi,1
    syscall
;----------------------------------------------SECOND PROGRAM------------------------------------------------------
;------------------------------------------ MACRO DEFININTION---------------------------------------
%macro read 2
	mov	rax,0
	mov	rdi,0
    mov	rsi,%1
    mov	rdx,%2
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro print 2
	mov	rax,1
	mov	rdi,1
	mov	rsi,%1
	mov	rdx,%2
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro fopen 1
	mov	rax,2
	mov	rdi,%1
	mov	rsi,2
	mov	rdx,0777o
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro fread 3
	mov	rax,0
    mov	rdi,%1
	mov	rsi,%2
	mov	rdx,%3
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro fwrite 3
	mov	rax,1
	mov	rdi,%1
	mov	rsi,%2
	mov	rdx,%3
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------
%macro fclose 1
	mov	rax,3
	mov	rdi,%1
	syscall
%endmacro
;---------------------------------------------------------------------------------------------------


global	far_proc						;declared global can be used in another file

extern	filehandle, buf, abuf,char				;procedure defined in another file
;---------------------------------------------------------------------------------------------------

section .data
	nline		db	10,10
	nline_len:	equ	$-nline
	
	msgl db "FIle OPen"
	msgll equ $-msgl
	smsg		db	10,"No. of spaces are : "
	smsg_len:	equ	$-smsg

	nmsg		db	10,"No. of lines are : "
	nmsg_len:	equ	$-nmsg

	cmsg		db	10,"No. of character occurances are	: "
	cmsg_len:	equ	$-cmsg
;---------------------------------------------------------------------------------------------------
section .bss

    	scount	resb	04
	ncount	resb	04
	ccount	resb    04

	ans	resb	04
;---------------------------------------------------------------------------------------------------
section .text

global _str

_str:

    far_proc:
	
        xor rax,rax
        xor rbx,rbx
        xor rcx,rcx
        xor rsi,rsi
	
	mov bl,[char]
        mov rsi,buf							;rsi point to the content read from file
	
        mov rcx,[abuf]							;store the count of data read from file 

	
       again:	mov	al,[rsi]

	cmp	al,20h			;space : 32 (20H)		;compare the data from file with blank space
		jne	case_n						;if not equal jump else increment counter
		inc	byte[scount]
		jmp	next

case_n:	cmp	al,0Ah			;newline : 10(0AH)		;compare the data from file with newline
		jne	case_c						;if not equal jump else increment counter
		inc	byte[ncount]
		jmp	next

case_c:	cmp	al,bl			;character			;compare the data from file with charachter	
		jne	next						;if not equal jump else increment counter
		inc	byte[ccount]

next:		inc	rsi
		dec	rcx			
		jnz	again


        	print smsg,smsg_len
		mov	bx,[scount]
		call	display

		print nmsg,nmsg_len
		mov	bx,[ncount]
		call	display

		print cmsg,cmsg_len
		mov	bx,[ccount]
		call	display

		fclose	[filehandle]
		ret
;-----------------------------------DISPLAY PROC----------------------------------------------------------------

display:	MOV rdi,ans
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

		print ans,04
		ret
;---------------------------------------------------------------------------------------------------	
;[Jackson97@localhost Mp]$ nasm -f elf64 f1.asm
;[Jackson97@localhost Mp]$ nasm -f elf64 f2.asm
;[Jackson97@localhost Mp]$ ld -o P f1.o f2.o
;[Jackson97@localhost Mp]$ ./P 
;Enter file name abc2.txt 
;Enter char to search d
;
;No. of spaces are : 0000
;No. of lines are : 0004
;No. of character occurances are	: 000D
;-----------------------------------------------------------------------------------------------------

