.model small
.data
;операнды
a dw 2
b dw 2
c dw 10
d dw 2
e dw 2
;числитель и знаменатель -51/4
f dw ? ;-12 F4 FF FF FF
o dw ? ;-3  FD FF FF FF

.CODE
.486
begin:
mov ax,@data 
mov ds, ax


mov cx,a
add cx,e
sal cx,2

mov bx,c
sal bx,1 
mov ax,d 
imul ax
sub bx,ax ;2c-d^2
mov ax,a 
imul ax	;a^2
mov dx,ax 
imul bx
idiv cx
mov f,ax
mov o,dx




	mov ah, 4ch
	int 21h
end