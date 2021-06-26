;例子：不使用乘法指令实现乘法运算
;循环结构
;方法一算法：16位加法运算
;----------------------------------------------------------
assume cs:code, ds:data

data segment
xxx db 234 	;被乘数 
yyy db 125 	;乘数
zzz dw ? 	;存放积
data ends

code segment
start:
	mov ax, 0040h
	mov ds, ax

	mov ax, 0 	;累加器
	xor dx, dx	;高16位
	mov bl, xxx 	
	xor bh, bh
	
	mov cl, yyy
	xor ch, ch

next1:	
	add ax, bx 
	adc dx, 0
	loop next1


	mov zzz, ax

	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start