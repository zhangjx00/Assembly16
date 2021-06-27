;功能：接受一个字符串，显示数字的个数，英文字母的个数和字符串的长度
;分析：利用0AH号功能调用接受一个字符串，然后分别统计个数，最后用十进制形式显示
;字符串的长度可以从0AH号功能调用的出口参数中取得
;----------------------------------------------------------
mlength=128 	;缓冲区长度
assume cs:code, ds:data

data segment
buff 	db  mlength			;符合0AH号功能调用所需的缓冲区
		db  ?				;实际键入的字符数
		db  mlength dup(0)
mess0	db	'Please input:$'
mess1	db	'Length = $'
mess2	db	'x = $'
mess3	db	'y = $'
data ends

code segment
start:
	mov ax, data
	mov ds, ax

	;显示提示信息
	mov dx, offset mess0
	mov ah, 9
	int 21h 

	;10号功能接收字符串存放到buff中
	mov dx, offset buff
	mov ah, 10
	int 21h
	call newline	;显示buff

	;计数器初始化
	mov bh, 0 	;数字符个数
	mov bl, 0 	;字母个数
	;取字符串长度
	mov cl, buff+1
	xor ch, ch 
	jcxz ok
	mov si, offset buff+2

again:
	mov al, [si]		;取字符
	inc si
	;判断字符串
	cmp al, '0'
	jb next
	cmp al, '9'
	ja notc
	inc bh
	jmp next

notc:	;判断字符串
	or al, 20h 		;第五位置1，大写转小写字母
	cmp al, 'a'
	jb next
	cmp al, 'z'
	ja next
	inc bl

next:
	loop again



ok:
	;显示
	mov dx, offset mess1
	mov ah, 9
	int 21h
	;显示字符串长度
	mov al, buff+1
	xor ah, ah
	call dispal 
	call newline		;换行

	;显示数字个数
	mov dx, offset mess2
	call dispmess
	mov al, bh
	xor ah, ah 
	call dispal
	call newline

	;显示字母个数
	mov dx, offset mess3
	call dispmess
	mov al, bl
	xor ah, ah 
	call dispal
	call newline

	mov ax, 4c00h 
	int 21h


;=======================================================
;子程序： dispal
;功能：用十进制的形式显示8位二进制
;入口参数：AL=8位二进制数
;出口参数：无
dispal proc

	mov cx, 3 		;8位二进制最多转换为3位十进制数
	mov dl, 10

disp1:
	div dl			;
	xchg ah, al 	;使al=余数，ah=商
	add al, '0'		;获取ascii码
	push ax
	xchg ah, al 
	mov ah, 0 		;扩转为16位
	loop disp1
	mov cx, 3
disp2:
	pop dx 			;弹出一位
	call echoch		;显示
	loop disp2		;继续
	ret
dispal endp


;显示有dx所指向的提示信息，其他子程序说明信息略
;9号子程序功能，在屏幕显示一个字符串
dispmess proc
	mov ah, 9
	int 21h
	ret
dispmess endp


;显示dl中的字符，其他子程序说明信息略
;2号子程序功能，显示输出
echoch proc
	mov ah, 2
	int 21h
	ret
echoch endp

;子程序：newline
;功能：形成回车和换行（光标移调下一行首）
;入口参数：无
;出口参数：无
;说明：通过显示回车符形成回车，通过显示换行符形成换行
newline proc
	push ax			;
	push dx			;
	mov dl, 0dh		;回车的ascii码
	mov ah, 2 		;调用2号功能，显示回车符
	int 21h

	mov dl, 0ah		;换行符的ascii码
	mov ah, 2 		;显示换行符
	int 21h

	pop dx
	pop ax
	ret
newline endp



code ends
	end start