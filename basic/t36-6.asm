;例子：把一个字符的所有大写字母改成小写字母，字符串以0结尾
;循环结构
;方法一：先指向再判断
;----------------------------------------------------------
assume cs:code, ds:data

data segment
string db 'HOW are yoU !', 0, 24h
data ends

code segment
start:
	;不能直接给段寄存器赋值，借助ax转一下
	mov ax, data
	mov ds, ax

	mov si, offset string
again:
	mov al, [si]
	inc si  
	cmp al, 0 	;先跟0比较
	jz over		;如果第一个字符就是0，跳转到over

	cmp al, 'A'
	jb again
	cmp al, 'Z'
	ja again
	or al, 00100000b; 加0x20 转换成小写字母
	mov [si-1], al	;保存到字符串
	jmp again


over:

	;显示字符串
	mov dx, offset string  
	mov ah, 9
	int 21h

	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start