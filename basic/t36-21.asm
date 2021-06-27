;例子：设字符串1在数据段中，字符串在数据段2中，写一个程序判别字符串2是否是字符串1的子字符串，如果是把数据段中的flag单元置1，否则置0
;----------------------------------------------------------

assume cs:code,ds:data1, es:data2
data1 segment
str1	db 	'THIS IS A STRING!',0
data1 ends
data2 segment
str2	db 	'STRING!',0
flag	db 	?
data2 ends


code segment

start:
	mov ax, data1
	mov ds, ax

	mov ax, data2
	mov es, ax

	;测量字符串2的长度
	mov di, offset str2	;设置缓冲区首地址	
	mov bx, di
	xor cx, cx

	dec di

while1:			;获取str2的长度
	inc di 
	inc cx 
	cmp byte ptr es:[di], 0  
	jnz while1
	dec cx
	mov dx, cx		;保存str2的长度


	mov si, offset str1		;获取str1的首地址
	mov bp, si 

fori:
	mov cx, dx
	mov di, bx

forj:
	mov al, es:[di]
	cmp [si], al
	jnz nexti

nextj:
	inc di
	inc si
	loop fori
	mov flag, 1
	jmp over

nexti:
	cmp byte ptr[si], 0 
	jz notf
	jnc bp
	mov si, bp
	jmp fori

notf:
	mov flag,0  	;无子串，置0


over:
	;显示字符串
	;mov dx, offset buffer  
	;mov ah, 9
	;int 21h

	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start