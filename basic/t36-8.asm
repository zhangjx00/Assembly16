;例子：判断从地址0040：0000H开始的2048个内存单元中是否含有字符'A',
;如果有，把第一个(按地址从小到大为序)含此指定字符的存储单元的地址偏移到0000:03FEH单元，
;如果没有则把特征值0FFFFFH送上述指定单元
;循环结构
;功能：有计数和条件双重控制的循环
;----------------------------------------------------------

;常量定义
segaddr=40h 	;开始地址段值
offaddr=0 		;开始地址偏移
count=2048		;长度计数
keychar='A'		;指定字符
segresu=0 		;结果保存单元段值
offresu=3feh	;结果保存单元偏移

assume cs:code

code segment
start:
	mov ax, segaddr
	mov ds, ax


	mov si, 0 
	mov cx, count

next1:
	mov al, [si]
	cmp al, 'A'		;如果等于A，跳转到ok
	jz ok
	inc si
	loop next1
	mov si, offffh	;如果到最后都没找到，赋值-1

OK:
	mov ax, segresu	;存储单元的地址偏移到0000:03FEH单元，
	mov ds, ax
	mov di, offresu
	mov [di], si

over:


	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start