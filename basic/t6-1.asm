;功能：字符串操作指令lods
;字符串中的大写字母转换为小写字母（字母以0结尾）
;----------------------------------------------------------

assume cs:code, ds:data

data segment
strl 	db 	'TFhltVdhaa',0,'$'
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov si, offset strl
	call strlwr

	mov dx, offset strl
	mov ah, 9
	int 21h

	mov ax, 4c00h 
	int 21h


;=======================================================
;子程序： strlwr
;功能： 字符串中的大写字母转换为小写字母（字符以0结尾）
;入口参数： ds:si=字符串首地址的段值:偏移
;出口参数： 无
strlwr proc

	push si
	cld				;清方向位

next:
	lodsb
	cmp al, 0
	jz over
	cmp al, 'A'
	jz next
	cmp al, 'Z'
	ja next
	add al, 20h		;或者or al, 20h
	mov [si-1], al
	jmp next

over:
	pop si
	ret

strlwr endp
code ends

	end start