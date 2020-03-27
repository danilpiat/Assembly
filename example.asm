.model small
.data

a dw 1
b dw 1
c dw 1
d dw 6
e dw 1

f dd ? 
o dd ? 

.CODE
.486
begin:
mov ax,@data 
mov ds, ax


movsx ecx,a
movsx eax,e
add ecx,eax
sal ecx,2

movsx ebx,c
sal ebx,1 
movsx eax,d 
imul eax
sub ebx,eax ;2c-d^2
movsx eax,a 
imul eax	;a^2
mov edx,eax 
imul ebx;a^2*(2c-d^2)

idiv ecx
mov f,eax
mov o,edx


	mov ah, 4ch
	int 21h
end