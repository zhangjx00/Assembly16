;例子：3个无符号数，从大到小排序
;算法：三个无符号书两两比较，比较3次
;方法2：只使用一个寄存器
;----------------------------------------------------------
assume cs:code, ds:data

data segment
buffer	db 87, 234, 123
data ends

code segment
start:
	;不能直接给段寄存器赋值，借助ax转一下
	mov ax, data
	mov ds, ax

	mov si, offset buffer
	mov al, ds:[si]

	cmp al, [si+1]
	jae next1
	xchg al, [si+1]
	mov [si], al	;保存al值

next1:	;第二次比较
	cmp al, [si+2]
	jae next2
	xchg al, [si+2]
	mov [si+2], al

next2:	;第三次比较
	
	mov al, [si+1]
	cmp al, [si+2]
	jae next3
	xchg al, [si+2]
	mov [si+1], al

	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start
