.model small
.stack 100h
.data
	str1 db 'eee  ;ee  ', 0                 
	db 'ra,r,r,c',0                         
	db '  ',0
	db ' Mama;mwwwwwwwwwwu  ram rami  ',0
	db 'mi mi mii bu bu', 0
	db '  erew  r arf r', 0
	db 'ee rr wer;rr', 0
	db ';aa a aa yyyy',0
	db 'ramayu',0,30                        
	db 1000 dup(0)                          
	db 30
	str2 db 0, 30, 1000 dup(0)                     
	buf db 5000 dup(0)                      
	path db 100 dup(0)                      


	mSize equ 7 

	mExit   db 'Exit', 0                   
	mMenu   db 'Menu', 0                    
	mPrint  db 'Print strings', 0           
	mCreate db 'Create new strings', 0      
	mInput  db 'Input strings', 0           
	mRead   db 'Read file',0                
	mSave   db 'Save file',0               
	

	strChoose   db 'Choose item',0          
	strPath     db 'Enter path to file',0   
	strNot      db 'File not found',0      
	strOpen     db 'File opened',0          
	strClose    db 'File closed',0         
	strCreate   db 'File created',0        
	strOld      db 'Old strings:',0        
	strNew      db 'New strings:',0         
	strEnter db 13, 10, 0                       
	
	msgs dw offset mExit, offset mMenu, offset mPrint, offset mCreate, offset mInput, offset mRead, offset mSave
	
	func dw offset Exit, offset Menu, offset Print, offset Create, offset Input, offset Read, offset Save
	quit dw ?                               
	count dw ?                              
	file dw 0                               
	
.code
.486
	mov ax, @data
	mov ds, ax
	mov es, ax

	pusha
	push ax
	call Menu                               ;
	pop ax
	popa


ml: pusha
	lea ax, strChoose
	push ax
	call puts                               
	pop ax
	popa

	push ax
	call getchar                           
	pop ax

	sub al, '0'
	movsx si, al                           
	cmp al, 0
	jl ml                                   
	cmp al, mSize
	jg ml                                  
	sal si, 1                               

	pusha                                   
	push cx                                 
	call func[si]
	pop cx
	mov quit, cx                           
	popa
	mov cx, quit

	jcxz ml                                 

	mov ah, 4ch
	int 21h


proc Exit near                              
	push bp
	mov bp, sp
	mov word ptr [bp+4], 1                  
	pop bp
	ret
endp

proc Menu near                             
	push bp
	mov bp, sp
	mov word ptr [bp+4], 0                  

	mov ax, '0'                             
	mov di, 0                              
	mov bx, ' '                           


lp: pusha
	push ax
	call putc                               
	popa

	pusha
	push bx
	call putc                              
	popa

	pusha
	push msgs[di]                          
	call puts
	pop ax
	popa

	add di, 2
	inc ax
	cmp di, 2*mSize                         
	jne lp

	mov bx, 13
	pusha
	push bx
	call putc                              
	popa	   
	mov bx, 10
	pusha
	push bx
	call putc                              
	popa

	pop bp
	ret
endp


proc Print near                            
	push bp
	mov bp, sp
	mov word ptr [bp+4], 0                 

	lea ax, strOld
	pusha
	push ax
	call puts                               
	pop ax
	popa


	lea di, str1
lprint:
	pusha
	push di
	call puts                               
	pop si
	mov count, si                          
	popa
	add di, count
	inc di
	cmp byte ptr[di], 30                   
	jne lprint

	lea ax, strNew
	pusha
	push ax
	call puts
	pop di
	popa

	lea di, str2
lprint2:
	pusha
	push di
	call puts                             
	pop si
	mov count, si
	popa
	add di, count                          
	inc di
	cmp byte ptr[di], 30
	jne lprint2

	mov bx, 13
	pusha
	push bx
	call putc                              
	popa		   

	mov bx, 10
	pusha
	push bx
	call putc                             
	popa


	pop bp
	ret
endp

proc Create near                            
	push bp
	mov bp, sp
	mov word ptr [bp+4], 0
	lea di, str2
	lea si, str1
	pusha
	push di
	push si
	call reorg                             
	popa


	pop bp
	ret
endp

proc Input near                            
	push bp
	mov bp, sp
	mov word ptr [bp+4], 0

	lea di, str1                            
	mov cx, 250
	xor ax, ax
	rep stosd


	lea di, str1
iml:pusha
	push di
	call gets                              
	pop di
	mov count, di                          
	popa

	cmp word ptr count, -1                  
	je ine
	add di, count
	inc di
	jmp iml
ine:mov byte ptr[di], 30

	pop bp
	ret
endp

proc Read near                             
	push bp
	mov bp, sp
	mov word ptr [bp+4], 0

	lea di, str1
	mov cx, 250
	xor eax, eax
	rep stosd
	mov byte ptr str1[1], 30 
	pusha
	push offset strPath
	call puts                              
	pop ax
	popa

	pusha
	push offset path
	call gets                            
	pop ax
	mov count, di
	popa

	pusha
	push offset path
	push 'r'
	call fopen                            
	pop word ptr file
	popa

	cmp byte ptr file, 0
	jne rf

	pusha
	push offset strNot                     
	call puts
	pop ax
	popa

	jmp er

rf: lea di, str1
	pusha
	push di
	push word ptr file
	call fgets                            
	pop di
	popa

er: pop bp
	ret
endp

proc Save near                             
	push bp
	mov bp, sp
	mov word ptr [bp+4], 0

	pusha
	push offset strPath
	call puts                              
	pop ax
	popa

	pusha
	push offset path
	call gets                               
	pop ax
	mov count, di
	popa

	pusha
	push offset path
	push 'w'
	call fopen                             
	pop word ptr file
	popa

	lea di, str2

lsave:



	pusha
	push di
	push word ptr file
	call fputs                             
	pop count
	popa

	add di, count                           
	inc di
	cmp byte ptr[di], 30                    
	jne lsave



	pusha
	push word ptr file
	call fclose                            
	popa


	pusha
	push offset strClose
	call puts                              
	pop ax
	popa


	pop bp
	ret
endp

proc fclose near                            
	push bp
	mov bp, sp

	mov bx, [bp+4]                          
	mov ah, 3Eh
	int 21h
	pop bp
	ret 2
endp

proc fopen near                            
	push bp
	mov bp, sp

	cmp word ptr [bp+4], 'r'               
	je frd                                  
	mov ah, 3Dh
	mov al, 2
	xor cx, cx
	mov dx, word ptr [bp+6]                 
	int 21h
	mov bx, word ptr[bp+6]
	mov word ptr[bp+6], ax                 
	jnc foe

	mov word ptr[bp+6], bx                  
	pusha
	push offset strCreate
	call puts
	pop ax
	popa


	mov ah, 5Bh
	mov al, 2
	xor cx, cx
	mov dx, word ptr [bp+6]
	int 21h                                
	mov word ptr[bp+6], ax                 
	jnc foe

	mov word ptr[bp+6], 0                  
	pop bp
	ret 2

frd:mov ah, 3Dh                            
	mov al, 3
	xor cx, cx
	mov dx, word ptr [bp+6]
	int 21h
	jnc foe

	mov word ptr[bp+6], 0                  
	pop bp
	ret 2

foe:mov word ptr[bp+6], ax                  
	pop bp
	ret 2
endp

proc putc near                              
	push bp
	mov bp, sp

	mov ah, 06h
	mov dx, [bp+4]                          
	int 21h                               

	pop bp
	ret 2
endp

proc puts near                              
	push bp
	mov bp, sp

	xor ax, ax                             
	mov cx, -1                              
	mov di, [bp+4]                          
	repne scasb                             
	add cx, 2
	neg cx                                  
	push cx
	mov ah, 40h                            
	mov bx, 1                              
	pop cx
	mov dx, [bp+4]                          
	mov [bp+4], cx                         
	int 21h

	mov bx, 13
	pusha
	push bx
	call putc                               
	popa
	mov bx, 10
	pusha
	push bx
	call putc                               
	popa

	pop bp
	ret
endp

proc fputs near                             
	push bp
	mov bp, sp

	xor ax, ax                              
	mov cx, -1                             
	mov di, [bp+6]                          
	repne scasb                             
	add cx, 2
	neg cx                                 

	push cx
	mov ah, 40h                             
	mov bx, [bp+4]                         
	pop cx
	mov dx, [bp+6]                          
	mov [bp+6], cx                         
	push bx
	int 21h
	pop bx

	mov ah, 40h
	mov cx, 1
	mov dx, offset strEnter                 
	int 21h

	pop bp
	ret 2
endp


proc getchar near                           
	push bp
	mov bp, sp

	mov ah, 0Ch
	mov al, 01h
	int 21h
	mov [bp+4], ax                         

	mov bx, 13
	pusha
	push bx
	call putc                               
	popa
	mov bx, 10
	pusha
	push bx
	call putc                               
	popa

	pop bp
	ret
endp

proc gets near                             
	push bp
	mov bp, sp

	lea di, buf
	mov cx, 60
	xor ax, ax
	rep stosd                              
	lea di, buf
	mov byte ptr [di], 254                  
	mov ah, 0Ah
	mov dx, di
	int 21h                                 
	mov cx, -1
	add di, 2
	mov al, 13
	repne scasb                             
	add cx, 2
	neg cx
	mov bx, cx
	lea si, buf
	add si, 2
	cmp byte ptr[si], 26                    
	je eof
	mov di, [bp+4]
	rep movsb
	mov [bp+4], bx                          
	jmp ent
eof:mov word ptr[bp+4], -1                 
ent:mov bx, 10
	pusha
	push bx
	call putc                               
	popa

	pop bp
	ret
endp

proc fgets near                             
	push bp
	mov bp, sp

	mov di, [bp+6]
	mov cx, 60
	xor ax, ax
	rep stosd                               

	mov cx, -1
	mov ah, 3Fh
	mov bx, [bp+4]                          
	mov dx, [bp+6]                         
	mov al, 2
	int 21h

	mov cx, ax
	mov di, [bp+6]
	xor bx, bx


fml:mov al, [di]
	cmp al, 13
	jne fg
	mov byte ptr[di], 0                     
fg: inc bx
	inc di
	loop fml
	inc di
	mov byte ptr[di], 30                    
	mov [bp+6], bx

	pop bp
	ret 2
endp


proc reorg near                            
	push bp
	mov bp, sp

	mov si, [bp+4]
	mov di, [bp+6]

	xor dx, dx      
	dec si
	mov ah, ' '
sl: inc si
	mov al, ','     
	cmp [si], al
	jne s2
	mov [si], ah
s2: mov al, ';'    
	cmp [si], al
	jne s3
	mov [si], ah
s3: mov al, 30      
	cmp [si], al
	jne sl


	mov di, [bp+6]
	mov cx, 50
	xor ax, ax
	rep stosd

	mov bl, 30
	xor ax, ax
	mov bh, ' '
	mov si, [bp+4]              
	mov di, [bp+6]              
	push di

	
s12:cmp[si], bl                
	je ext
	cmp [si], bh                
	jne s11                    
	inc si
	jmp s12                    
s11:cmp [si], ah
	je ex



	sw: pop di
		push di
		mov dx, si              
	ns: mov al, [si]
		cmp al, bh              
		je ew
		cmp al, ah              
		je ew
		cmp al, [di]            
		jne edw                 
		inc si
		inc di
		jmp ns                  

		
	ew: cmp [di], ah           
		je ewi
		cmp [di], bh            
		je ewi
	sp1:inc di                 
		cmp [di], ah           
		je ewc                 
		cmp [di], bh          
		jne sp1
		
	s10:inc di
		cmp [di], ah           
		je ewc
		cmp [di], bh            
		je s10                 
		mov si, dx              
		jmp ns                  

		
	edw:cmp [di], ah            
		je ewc                  
		cmp [di], bh            
		je sp3                  
	sp7:inc di                 
		cmp [di], ah            
		je ewc
		cmp [di], bh            
		je sp3                  
		jmp sp7                

	sp3:inc di
		cmp [di], ah           
		je ewc
		cmp [di], bh            
		je sp3
		mov si, dx              
		jmp ns                  
		
	ewi:cmp [si], ah          
		jne sp9
		mov cx, -1
		pop di
		push di
		xor ax, ax
		repne scasb            
		dec di                 
		jmp ex                 
	sp9:mov al, ' '
		mov cx, -1
		cmp [si], al           
		jne sw                  
		inc si                  
		jmp ewi                 

		
	ewc:mov cx, -1              
		xor ax, ax
		pop di                 
		push di
		repne scasb           
		dec di
		add cx, 2
		neg cx
		jcxz sp4
		mov [di], bh          
		inc di

		xor cx, cx
		mov si, dx            
	sp4:cmp [si], ah
		je sp5
		cmp[si], bh
		je sp5
		inc cx                 
		inc si
		jmp sp4

	sp5:mov si, dx
		rep movsb               


	sp8:cmp [si], bh           
		jne sp6
		inc si
		jmp sp8
	sp6:cmp [si], ah
		jne sw                 
	ex: mov [di], ah            
		inc di                 
		pop ax
		push di                 
		xor ax, ax
		inc si                  
		jmp s12

ext:mov[di], bl             
	pop di

	pop bp
	ret 4
endp



end