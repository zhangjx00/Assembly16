;例子：假设x和y都是无符号数，写一个表达式16x+y值的程序
;设x，y为16位无符号数，计算16x+y的值
;算法2：移位
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

	mov ax, x
	xor dx, dx	;结果保存到dx:ax中，原来dx可能有值，先把dx清零

	;移位运算
	mov cl, 4
	shl ax, cl	;无符号数，逻辑左移4位，相当于乘以了16，此时ax=2340

	mov dx, x 
	mov cl, 12
	shr dx, cl	;1234右移12位，还剩1放到dx中


	;16 * x + y
	add ax, y
	adc dx, 0
	;保存结果，低16位放ax，高16位放dx
	mov word ptr z, 	;宽度不一致，用ptr转一下
	mov word ptr z + 2, dx

	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start
