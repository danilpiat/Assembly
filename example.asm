.model small
.stack 100h
.486
.data
m db 4
n db 5
matrix  db -1, 2, 3, 4, 5
	db 6, 7, 8, 9, 10
	db 11, 12, -13, 14, 15
	db -16, 17, 18, 19, -20
vector  dw 0,0,0,0

.code

	mov ax, @data
	mov ds, ax


	mov si,offset matrix
   	mov di,offset vector
	xor dx,dx
	mov dl,m

cicle0:

	xor cx,cx
	mov cl,n
	xor ax,ax
	xor bx,bx
cicle1:
	lodsb
	cbw
	add bx,ax
	loop cicle1
	mov [di],bx
	add di,2	
	dec dx
	test dx,dx
	jnz cicle0

sort:
	mov dx,0
	xor cx,cx
	mov cl,m
	dec cx
	mov si,offset vector
cicle2:
        lodsw 
        mov bx,[si]
        cmp bx,ax
        jg skipswap
        mov [si],ax       
	mov [si-2],bx 
	inc dx
skipswap:
        
        loop cicle2
        test dx,dx
	jnz sort

	
	mov ax,4C00h
	int 21h	
 end 	

