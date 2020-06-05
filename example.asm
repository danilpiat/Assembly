
	.model small
	.stack 100h
	.486
	.data
string db '  ; all those  ,,	moments   will be lost in time,like  tears  ; in rain; ', 0
delim db ' ,;', 0
newstring db 100 dup(?) ; for result
	
	.code
	mov ax, @data
	
	mov ds, ax
	mov es, ax
	cld
	lea si, string 
	lea di, newstring 
	
m1:	call space 
	cmp byte ptr [si], 0
	je fin
	call _word
	
	push ax
	call reverse
	inc sp
	inc sp
	cmp byte ptr [si], 0
	je fin
	mov al, ' '
	stosb
	jmp m1
	
fin:
	xor al, al
	stosb
	mov ax, 4c00h
	int 21h
; code: 
; 
reverse proc c uses ax bx cx;
	locals @@
	push bp
	mov bp, sp
	mov cx, [bp+10]
	sub cx, si
	mov bx, cx
	xor ax, ax
	
@@cycm1:	
	lodsb
	push ax
	loop @@cycm1
	mov cx, bx
	
@@cycm2:
	pop ax
	stosb
	loop @@cycm2
	pop bp
	ret
	endp

_word proc c uses si cx di
	locals @@
	lea di, delim
	push di
	xor al, al
	mov cx, 65535
	repne scasb
	neg cx
	push cx
	
@@m:	pop cx
	pop di
	push di
	push cx
	lodsb
	repne scasb
	jcxz @@m
	
	dec si
	mov ax, si
	add sp, 4
	ret
	endp

space proc c uses ax cx di
	locals @@
	lea di, delim
	push di
	
	xor al, al
	mov cx, 65535
	repne scasb
	neg cx
	dec cx
	push cx
	
@@m1:	pop cx
	pop di
	push di
	push cx
	lodsb
	repne scasb
	jcxz @@m2
	jmp @@m1
	
@@m2:	dec si
	add sp, 4 
	ret
	endp
	
	end
	