;例子：压缩的bcd码转成十进制数字的ascii程序
;设x，y为、
;算法：BCD码+30h = ascii码
;程序结构：顺序结构
;----------------------------------------------------------
assume cs:code, ds:data

data segment
BCD DB 86H
ASCII db 2 DUP(0)
data ends

code segment
start:
	;不能直接给段寄存器赋值，借助ax转一下
	mov ax, data
	mov ds, ax

	;取低四位
	mov al, BCD
	and al, 0fh
	add al, 30h
	mov ASCII+1, al

	;取高四位
	mov al, BCD
	mov cl, 4
	shr al, cl
	add al, 30h
	mov ASCII, al


	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start
