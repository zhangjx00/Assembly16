;功能：二进制数形式显示所按键的ascii码
;分析：
;第一步、利用1号功能调用接受一个字符
;第二步、通过移位法从高到底依次吧其ascii码值的各位析出，再转换成ascii码
;第三步、利用2号功能调用显示输出
;----------------------------------------------------------

assume cs:code
code segment
start:
	;获取键盘输入的字符---回显
	mov ah, 1 		;调用1号功能，从输入设备读1个字符放到al中
	int 21h
	call newline
	;
	mov bl, al
	mov cx, 8

next:
	shl bl,1
	mov dl, 30h
	adc dl, 0
	;显示字符
	mov ah, 2 		;调用2号功能，显示dl中的字符
	int 21h
	loop next
	
	;显示数基
	mov dl, 'B'		;调用2号功能，显示dl中的字符，即：显示字符B
	mov ah, 2
	int 21h
	;
	mov al, 0
	mov ah, 4ch 
	int 21h


;=======================================================
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