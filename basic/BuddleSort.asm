;例子：冒泡排序
;buffer缓冲区有10个单字节无符号整数，写一个程序将他们有小到大排序
;二重循环，简单选择法
;si为外层循环控制变量i，di为内层循环变量j，因为i从1开始循环9次
;所以buffer地址减一，[bx+si]取第一个数
;时间复杂度是n二次方
;----------------------------------------------------------


assume cs:code,ds:dasg
data segment
buffer	db 	23,12,45,32,127,3,9,58,81,72
n 		equ	10
data ends
code segment

start:
	mov ax, data
	mov ds, ax

	mov bx, offset buffer-1	;设置缓冲区首地址	
	mov si, 1
fori:
	mov di, si
	inc di			;di=2

forj:
	mov al, [bx+si]	;取出第一个数
	cmp al, [bx+di]	;与第二个数比较
	jbe nextj		;小于等于跳转到 nextj
	xchg al, [bx+di]	;xchg [bx+si], [bx+di]，不能操作2个内存地址，用al转一下
	mov [bx+si], al

nextj:			
	;现将j加1，如果小于10跳转到 forj
	inc di
	cmp di, n 
	jbe forj

nexti:
	inc si
	cmp si, n-1 
	jbe fori

over:

	;显示字符串
	mov dx, offset buffer  
	mov ah, 9
	int 21h

	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start