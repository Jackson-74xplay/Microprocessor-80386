;------------------------------------------ MACRO DEFININTION--------------------------------------
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


%macro fopen 1
MOV rax,2
MOV rdi,%1
MOV rsi,2
MOV rdx,0777o
syscall
%endmacro

%macro fread 3
MOV rax,0
MOV rdi,%1
MOV rsi,%2
MOV rdx,%3
syscall
%endmacro


%macro fwrite 3
MOV rax,1
MOV rdi,%1
MOV rsi,%2
MOV rdx,%3
syscall
%endmacro


%macro fclose 1
mov rax,3
mov rdi,%1
syscall
%endmacro
;----------------------------------------------------------------------------------------------------
section .data
msg db "Enter the filename "
msglen equ $-msg


errmsg db "FIle NOt found" 
errmsgl equ $-errmsg

emsg db "FIle  found" 
emsgl equ $-emsg

nline db "",10
nlinel equ $-nline
;----------------------------------------------------------------------------------------------------

section .bss
filename resb 50
filehandle resq 1
buffer resb 4096
array resb 30


abuf_len resq 01
count resb 02
resbuffer resb 02
counter resb 02

;----------------------------------------------------------------------------------------------------

section .text
global _start
_start:
		write msg,msglen
		read filename,50					;take filename from user
		dec rax
		MOV byte[filename+rax],0				;add \0 at end of file

		fopen filename						;open file
		cmp rax,-1H						;check if file is open
		jle error
		MOV [filehandle],rax					;store filehandle from rax

		fread [filehandle],buffer,4096				;read the contents of the file and store in buffer
		MOV [abuf_len],rax					;store the count of the contents read from file 
		call buf_array						
		
		call sort
		fwrite [filehandle],array,[count]
		fclose [filehandle]

		call exit






error: 		write errmsg,errmsgl

exit:	
		MOV rax,60
		MOV rdi,1
		syscall
;----------------------------------------------------------------------------------------------------
							;procedure to store read contents in an array
buf_array:
		 
		  MOV rcx,[abuf_len]			;take count in rcx
		  MOV rsi,buffer			;point rsi to read content
		  MOV rdi,array				;point rdi to array


again:	  	  MOV al,[rsi]
		  MOV [rdi],al				;transfer contents from buffer to array
		  inc byte[count]

		  inc rsi
		  inc rsi
		  inc rdi


		  dec rcx
		  dec rcx
		  
		  jnz again

		  ret
;----------------------------------------------------------------------------------------------------
								;bubblesort procedure
sort:
	
	mov rbp,[count]						;take count in rbp use as n i.e.number of elements
	mov rcx,0						;use rcx as i i.e. index of outer loop 
	dec rbp
up4:								;continue outer loop till i becomes n(outer loop)
	mov rbx,0						;use rbx as j i.e. index of inner loop
	mov rsi,array
up3:								;continue inner loop till j becomes n(inner loop)
	mov rdi,rsi
	inc rdi

	mov al,[rsi]
	cmp al,[rdi]
	jle next

	mov dl,[rdi]
	mov [rdi],al
	mov [rsi],dl


next:
	inc rsi
	inc rbx
	cmp rbx,rbp
	jl up3							;(inner loop)

	inc rcx
	cmp rcx,rbp
	jle up4							;(outer loop)
	 write emsg,emsgl
	ret
;----------------------------------------------------------------------------------------------------
;--------------------------------------------TERMINAL------------------------------------------------
;[Jackson97@localhost Mp]$ nasm -f elf64 BubbleS.asm
;[Jackson97@localhost Mp]$ ld -o P BubbleS.o
;[Jackson97@localhost Mp]$ ./P 
;Enter the filename abc.txt
;FIle  found[Jackson97@localhost Mp]$ 
;--------------------------------------------FILE BEFORE----------------------------------------------
;1
;4
;2
;5
;7
;--------------------------------------------FILE AFTER-----------------------------------------------
;1
;4
;2
;5
;7
;12457
;-------------------------------------------------------------------------------------------------------
