;例子：假设x和y都是无符号数，写一个表达式16x+y值的程序
;设x，y为16位无符号数，计算16x+y的值
;算法1：加法
;程序结构：顺序结构
;----------------------------------------------------------
assume cs:code, ds:data

data segment
x dw 1234h
y dw 5678h
z dd ?
data ends

code segment
start:
	;不能直接给段寄存器赋值，借助ax转一下
	mov ax, data
	mov ds, ax

	mov ax, ax
	xor dx, dx	;结果保存到dx:ax中，原来dx可能有值，先把dx清零

	;加法运算
	add ax, ax
	adc dx, 0

	add ax, ax
	adc dx, 0

	add ax, ax
	adc dx, 0

	add ax, ax
	adc dx, 0

	;16*X + y
	add ax, y
	adc dx, 0	;有可能有进位值

	;保存结果，低16位放ax，高16位放dx
	mov word ptr z, ax	;宽度不一致，用ptr转一下
	mov word ptr z + 2, dx

	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start
