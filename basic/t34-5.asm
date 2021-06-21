;例子：写一个16进制数字码转换成为对应的七段代码的程序
;查表法
;程序结构：顺序结构
;----------------------------------------------------------
assume cs:code, ds:data

data segment
tab				db 1000000b,1111001b,0100100b,0110000b
				db 0011001b,0010010b,0000010b,1111000b
				db 0000000b,0010000b,0001000b,0000011b
				db 1000110b,0100001b,0001110b,0001110b
xcode	db 2	;待转换的16进制的数字码	
ycode	db ?	;存放对应的七段代码
data ends

code segment
start:
	;不能直接给段寄存器赋值，借助ax转一下
	mov ax, data
	mov ds, ax

	mov bl, xcode
	xor bh, bh		;高4位清零
	and bl, 0fh		;取低4位

	mov al, tab[bx]	;去tab表中的偏移，对应的是数码管的8
	mov ycode, al


	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start
