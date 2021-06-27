;功能：先接收一个字符串，然后抽去其中的空格，最后按相反的顺序显示
;请注意删除空格的方法和方向标志的变化
;REPZ和CMPZ指令配合使用
;----------------------------------------------------------
;常量定义
maxlen=16		;字符串最大长度
space=' '		;空格
cr=0dh			;回车符
lf=0ah			;换行符

assume cs:code, ds:data

data segment
buffer 	db 	maxlen+1,0,maxlen+1 dup(0)
string 	db	maxlen+3 dup(0)
data ends


code segment
start:
	
	mov ax, data
	mov ds, ax 
	mov es, ax 

	;接收字符串
	mov dx, offset buffer
	mov ah, 10
	int 21h

	;获取字符串长度
	mov cl, buffer+1
	xor ch, ch  
	jcxz ok

	;
	mov si, offset buffer+2
	mov di, offset string

	mov al, 0
	stosb

	;去掉空格
	mov al, space

pp1:	
	xchg si, di
	repz scasb
	xchg si, di
	jcxz pp3
	dec si  
	inc cx 

pp2:
	cmp byte ptr[si], space
	jz pp1
	movsb
	loop pp2


pp3:
	mov al, cr 
	stosb
	mov al, lf
	mov [di], al

	std
	mov si, di

pp4:	
	lodsb
	or al, al
	jz ok
	mov dl, al 
	mov ah, 2
	int 21h
	jmp pp4



ok:
	mov ax, 4c00h 
	int 21h



code ends

	end start