;例子：求内存中从地址0040：0000H开始的1024个字的字检验和
;字检验和：按字节或字累计的和，通常用于传输数据的校验
;循环结构
;存储器指针SI，和计数器CX
;----------------------------------------------------------
assume cs:code

data segment
sum dw ?
data ends

code segment
start:
	;不能直接给段寄存器赋值，借助ax转一下
	mov ax, 0040h
	mov ds, ax

	mov si, 0 	;寻址
	xor ax, ax	;累加器
	mov cx, 1024

next1:	
	add ax, [si]	;add ax, ds:[si]的缩写
	inc si
	inc si
	loop next1

assume ds:data
	mov bx, data
	mov ds, bx

	mov sum, ax

	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start