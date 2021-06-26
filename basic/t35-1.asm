;例子：3个无符号数，从大到小排序
;程序结构：顺序结构
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
	mov bl, [si+1]
	mov cl, [si+2]

	cmp al, bl
	jae next1
	xchg al, bl

next1:	;第二次比较
	cmp al, cl
	jae next2
	xchg al, cl

next2:	;第三次比较
	cmp bl, cl
	jae next3
	xchg bl, cl

next3:	;保存结果
	mov [si], al
	mov [si+1], bl
	mov [si+2], cl


	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start
