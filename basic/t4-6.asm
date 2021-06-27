;功能：显示内存单元内容
;允许用户按16进制数的形式输入指定内存单元的段值和偏移
;十六进制显示指定自己单元的内容
;分析：
;第一步、接收段值和偏移
;第二步、指定单元内容转换为2位16进制的ascci码，边转换边显示
;设子程序getadr接收用户输入的十六进制数串，并转换为二进制数
;派生2个子程序getstr和htobin
;getstr接收长度为4的十六进制字符串，htobin负责转换为二进制
;字符串的长度可以从0AH号功能调用的出口参数中取得
;功能：用十六进制数的形式显示指定内存字节单元的内容
;----------------------------------------------------------
;符号常量定义
cr=0dh 			;回车符
lf=0ah			;换行符
backspace=08h	;退格符
bellch=07h		;响铃符
assume cs:code, ds:data

data segment
segoff 	db  ?				;存放指定单元的段值和偏移
mess1	db	'segment:$'
mess2	db	'offset$'
buffer	db	5 dup(0)
data ends

code segment
start:
	mov ax, data
	mov ds, ax

	;接收段值
	;显示提示信息
	mov dx, offset mess1
	call dispmess
	call getadr 				;返回值是ax
	mov word ptr segoff + 2, ax
	call newline

	;接收偏移
	mov dx, offset mess2
	call dispmess
	call getadr 				;返回值是ax
	mov word ptr segoff ax
	call newline

	les di, segoff
	mov al, es:[di]
	call showal
	call newline



	mov ax, 4c00h 
	int 21h


;=======================================================
;子程序： showal
;子程序转换并显示该单元内容
;入口参数al，存储单元内容
;出口参数：无
showal proc

	push ax		;保存寄存器
	mov cl, 4 
	rol al, cl 
	call htoasc
	call putch
	pop ax
	call htoasc
	call putch

	ret
showal endp

;=======================================================
;二进制转ascii码
htoasc proc
	and al, 0fh
	add al, 30h
	cmp al, 39h
	jbe htoasc1
	add al, 7h 
htoasc1
	ret
htoasc endp



;=======================================================
;显示提示信息
dispmess proc
	mov ah, 09h
	int 21h
	ret
dispmess endp

;=======================================================
;getadr
;接收段值和偏移
;入口参数：无
;出库参数：ax=转换后的二进制地址
getadr	proc
getadr1:
	call getstr			;接收一个字符
	cmp buffer, cr		;判断是否为空
	jnz getadr2			;不为空则转换
	call bell 			;为空响铃
	jmp getadr1			;重新接收

getadr2:
	mov dx, offset buffer
	call htobin				;负责转换为二进制数
	call newline			;另起一行
	ret
getadr endp



;=======================================================
;接收一个字符
;入口参数：无
;出口参数：buffer缓冲区
getstr proc
	mov di, offset buffer 
	mov bx, 0 				;接收字符串计数器
getstr1:
	call getch
	cmp al, cr
	jz getstr5
	cmp al, backspace
	jnz getstr4
	cmp bx, 0 				;判断是否有字符可擦除
	jz getstr2				;没有字符可擦除，响铃
	dec bx					;没有字符可擦除
	call putch				;光标回移al=backspace
	mov al, 20h				;空格
	call putch				;显示空格，擦除原字符
	mov al, backspace
	call putch
	jmp getstr1

getstr2:
	call bell
	jmp getstr1

getstr4:
	cmp bx, 4 				;一般建处理
	jz getstr2				;满4个字符，响铃
	call ishex				;判断是否为十六进制数
	jc getstr2				;否，响铃
	mov [bx][di], al 		;是，一次保存
	inc bx
	call putch				;显示
	jmp getstr1

getstr5:
	mov [bx][si], al 		;保存回车符
	ret
getstr endp


;=======================================================
;判断是否是16进制数
;入口参数：al
;出口参数：
ishex proc
	cmp al, '0'
	jb ishex2
	cmp al, '9'+1
	jb ishex1
	cmp al, 'A'
	jb ishex2
	cmp al, 'F'
	jbe ishex1
	cmp al, 'a'
	jb ishex2
	cmp al, 'f' + 1
ishex1:	
	cmc					;cf取反
ishex2:
	ret					;cf=1
ishex endp


;=======================================================
;得到一个字符
;入口参数：无
;出口参数：al
getch proc
	mov ah, 8
	int 21h
	ret
getch endp


;=======================================================
;接收到的字符转换为二进制数
;入口参数：dx，缓冲区首地址
;出口参数：dx
;x*16 + y迭代转换
;循环次数ch，移位cl，si指针
htobin proc

	push dx
	push cx
	push si
	mov si, dx
	xor dx, dx
	mov ch, 4
	mov cl, 4
htobin1:
	mov al, [si]
	inc si
	cmp al, cr
	jz htobin2
	call atobin
	shl dx, cl 
	or dl, al 
	dec ch 
	jnz htobin1
htobin2:
	mov ax, dx
	pop si
	pop cx
	pop dx
	ret

htobin endp

;=======================================================
;十六进制转成值
;入口参数：al
;出口参数：al
atobin proc
	sub al, 30h
	cmp al, 9
	jbe atobin1
	sub al, 7h 
	cmp al, 15
	jbe atobin1
	sub al, 20h
atobin1:
	ret

atobin endp

;=======================================================
;屏幕显示al内容：退格，空格，响铃，2号调用功能
;入口参数：al
;出口参数：无
putch proc
	push dx
	mov dl, dl 
	mov ah, 2
	int 21h
	pop dx
	ret
putch endp



;=======================================================
;响铃
;入口参数：al
;出口参数：无
putch proc
	mov al, bellch		;al赋值07h
	call putch
	ret
putch endp


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