;功能：比较两个字符串是否相等
;REPZ和CMPZ指令配合使用
;----------------------------------------------------------

assume cs:code, ds:data1, es:data2

data1 segment
str1 	db 	'Please get up!',0
mess1 	db	'Yes!$'
mess2 	db	'NO!$'
data1 ends

data2 segment
str2 	db	'Please get up!',0
data2 ends


code segment
start:
	mov ax, data1
	mov ds, ax 
	mov si, offset str1

	mov ax, data2
	mov es, ax
	mov di, offset str2

	call strcmp

	cmp ax, 0 	;根据ax判断是否相同
	jz next1
	mov dx, offset mess2
	mov ah, 9
	int 21h
	jmp over


next1:
	mov dx, offset mess1
	mov ah, 9
	int 21h


over:
	mov ax, 4c00h 
	int 21h


;=======================================================
;子程序： strcmp
;功能： 比较两个字符串是否相同
;入口参数 DS:DI=字符串1首地址, ES:DI=字符串2首地址
;出口参数： AX=0表示两字符串相同，否则字符串不同
;说明： 字符串以0结尾
strcmp proc

	cld				;清方向位
	push di
	xor al, al		;测量字符串2的长度，用0与字符串2比较，扫描到结尾符0时结束
	mov cx, 0ffffh	;假设长度为FFFF

subnext:
	scasb			;扫描字符串2
	loopnz subnext	;zf不等于0，未到结尾0时，继续扫描
	not cx			;zf等于0时，cx值取反，即得到字符串2的长度
	pop di
	repz cmpsb		;两个串比较（包括结束符在内），cx=0或zf=0时（即字符串不相等时）
	mov al, [si-1]
	mov bl, es:[di-1]
	xor ah, ah 		;如果两个字符串相同，则ax=0
	mov bh, ah   
	sub ax, bx 
	ret

strcmp endp

code ends

	end start