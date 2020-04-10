.model   small
.stack   100h
.data 
string      dw   1010111010111010b
count      db   0
.code

begin:     
mov ax, @data
mov ds, ax

      mov   cx,string
      mov   bx,010b
      mov   dx,111b
      
p1:      
      push   cx
      and   cx,dx
      xor   cx,bx
      jnz   p2
      inc    count
p2:      
      pop   cx
      shl   bx,1
      shl   dx,1
      jnc   p1

	 mov ax,4c00h
	 int 21h

end      