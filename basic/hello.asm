code 	segment
		assume cs:code
		start:
			mov ax,5h
			mov bx,6h
			add ax,bx
			mov ah,4ch    ; 调用DOS的4C号功能
			int 21h       ; 退出DEBUG状态，返回DOS
code 	ends
		end start