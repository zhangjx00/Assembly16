;例子：设缓冲区DATA中有一组单字节有符号数，一0为结束符，写一个程序实现如下功能：
;把前5个正数一次送入缓冲区pdata，把前五个负数一次送入缓冲区mdata，如不足5个数，补0
;第一步：预设2个缓冲区
;第二步：取数据
;第三步：判断是否为0
;第四步：判断是否为正数
;第五步：判断是否为负数
;第六步：判断是否满5个数
;第七步：结束
;----------------------------------------------------------

;常量
mac_c=5 
assume cs:code,ds:dasg
dasg segment
data db 3,-4,5,6,-7,8,-9,-10,-1,-32,-123,27,58,0



code segment
start:
	mov ax, segaddr
	mov ds, ax



over:


	;结束程序，固定套路
	mov ax, 4c00h
	int 21h

code ends
	end start