
		
		.text
cordic_2:


	mov     #3F87h,BSA45		; move to coeff buffer
	;mov #1, ST1.SATD
	
	;Clear accumulators
	mov #0,AC0
	mov #0,AC1
	mov *AR4(4),T1		;The sin gain
	mov *AR4(5),T3		;The cos gain	

	
	;low x_n*cos(theta): 
	;high part
	mov     #3F87h,BSA45	; move to coeff buffer
	mov *AR4(1), T0		;high cos(theta)
	mov     #4F87h,BSA45	; move to data buffer
	mpym *AR5(0),T0, AC1	; low x_n * high cos(theta
	sfts AC1, #2, AC2	;making it the high part
	
	;low part
	mov     #3F87h,BSA45	; move to coeff buffer
	mov *AR4(0),T0	;low cos(theta)
	mov     #4F87h,BSA45	; move to data buffer
	;AC1 = unsigned(T0*(*AR5(-1)) low x_n*lowcos(theta)
	MPYMU *AR5(0),T0,AC1	
	sfts AC1, #-14, AC1
	
	;high part x_n*cos(theta) + low part x_n*cos(theta)
	add AC2,AC1
	sfts AC1, #-16, AC1	;Because it is the low part
	
	;high x_n*cos(theta): 
	;high part
	mov     #3F87h,BSA45	; move to coeff buffer
	mov *AR4(1), T0	;high cos(theta)
	mov     #4F87h,BSA45	; move to data buffer
	mpym *AR5(-1),T0, AC0	; high x_n * high cos(theta
	sfts AC0, #2, AC2	;making it the high part
	
	;low part
	mov     #3F87h,BSA45	; move to coeff buffer
	mov *AR4(0),T0	;low cos(theta)
	mov     #4F87h,BSA45	; move to data buffer
	MPYMU *AR5(-1),T0,AC0	
	;AC1 = unsigned(T0*(*AR5(-1))  low x_n*cos(theta)
	sfts AC0, #-14, AC0
	
	;high part x_n*cos(theta) + low part x_n*cos(theta)
	add AC2,AC0
	
	;Add high part and low part of x_n
	add AC1, AC0
	
	;low y_n* sin(theta): 
	;high part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(3), T0				;high sin(theta)
	mov     #4F87h,BSA45		; move to data buffer
	mpym *AR5(-1),T0, AC2		; low y_n*high sin(theta
	sfts AC2, #2, AC1	;making it the high part
	
	;low part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(2),T0		;low sin(theta)
	mov     #4F87h,BSA45		; move to data buffer
	MPYMU *AR5(-1),T0,AC2	;AC1 = unsigned(T0*(*AR5(-1))  low y_n* low sin(theta)
	sfts AC2, #-14, AC2
	
	;high part y_n*sin(theta) + low part y_n*sin(theta)
	add AC2,AC1
	sfts AC1, #-16, AC1		;because it is the low part of y_n
	
	;high y_n*sin(theta): 
	;high part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(3), T0				;high sin(theta)
	mov     #4F87h,BSA45		; move to data buffer
	mpym *AR5(-3),T0, AC2		; high y_n*sin(theta
	sfts AC2, #2, AC3	;making it the high part
	
	;low part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(2),T0		;low sin(theta)
	mov     #4F87h,BSA45		; move to data buffer
	MPYMU *AR5(-3),T0,AC2	;AC1 = unsigned(T0*(*AR5(-1))  low y_n*sin(theta)
	sfts AC2, #-14, AC2
	
	;high part y_n*sin(theta) - low part y_n*sin(theta)
	add AC2,AC3
	
	;adding high and low part of y_n*sin(theta)
	add AC3,AC1
	
	;x_n*cos(theta) - y_n*sin(theta)
	sub AC1, AC0
	mov AC0, AC3		;x_n+1 is saved here
	
	;low x_n*sin(theta): 
	;high part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(3), T0				;high sin(theta)
	mov     #4F87h,BSA45		; move to data buffer
	mpym *AR5(0),T0, AC1		; low x_n * high sin(theta)
	sfts AC1, #2, AC2	;making it the high part
	
	;low part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(2),T0		;low sin(theta)
	mov     #4F87h,BSA45		; move to data buffer
	MPYMU *AR5(0),T0,AC1	;AC1 = unsigned(T0*(*AR5(-1))  low x_n* low sin(theta)
	sfts AC1, #-14, AC1
	
	;high part x_n*sin(theta) + low part x_n*sin(theta)
	add AC2,AC1
	sfts AC1, #-16, AC1		;because it is the low part of x_n
	
	;high x_n*sin(theta): 
	;high part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(3), T0				;high sin(theta
	mov     #4F87h,BSA45		; move to data buffer
	mpym *AR5(-1),T0, AC0		; high x_n * high sin(theta)
	sfts AC0, #2, AC2	;making it the high part
	
	;low part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(2),T0		;low sin(theta)
	mov     #4F87h,BSA45		; move to data buffer
	MPYMU *AR5(-1),T0,AC0	;AC1 = unsigned(T0*(*AR5(-1))  low x_n* high sin(theta)
	sfts AC0, #-14, AC0
	
	;high part x_n*cos(theta) + low part x_n*cos(theta)
	add AC2,AC0
	
	;add high and low part of x_n*sin(theta)
	add AC1, AC0
	
	;move x_n+1 to x_n
	mov hi(AC3), *AR5(-1) 	;high of AC3 => high x_n 
	mov AC3, *AR5(0) 	;low of AC3 => low x_n  
	
	
	;low y_n*cos(theta): 
	;high part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(1), T0				;high cos(theta)
	mov     #4F87h,BSA45		; move to data buffer
	mpym *AR5(-2),T0, AC2		; low y_n* high cos(theta)
	sfts AC2, #2, AC1	;making it the high part
	
	;low part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(0),T0		;low cos(theta)
	mov     #4F87h,BSA45		; move to data buffer
	MPYMU *AR5(-3),T0,AC2	;AC1 = unsigned(T0*(*AR5(-1))  low y_n* low cos(theta)
	sfts AC2, #-14, AC2
	
	;high part y_n*cos(theta) - low part y_n*cos(theta)
	add AC2,AC1
	sfts AC1, #-16, AC1 	;Because it is the low part of y_n
	
	
	;high y_n*cos(theta): 
	;high part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(1), T0				;high cos(theta)
	mov     #4F87h,BSA45		; move to data buffer
	mpym *AR5(-3),T0, AC2		; high y_n*high cos(theta)
	sfts AC2, #2, AC2	;making it the high part
	
	;low part
	mov     #3F87h,BSA45		; move to coeff buffer
	mov *AR4(0),T0		;low cos(theta)
	mov     #4F87h,BSA45		; move to data buffer
	MPYMU *AR5(-3),T0,AC3	;AC1 = unsigned(T0*(*AR5(-1))  high y_n* low cos(theta)
	sfts AC3, #-14, AC3
	
	;high part y_n*sin(theta) + low part y_n*sin(theta)
	add AC3,AC2
	
	;add high and low part of y_n*cos(theta)
	add AC2, AC1
	
	;y_n*cos(theta) + x_n*sin(theta)
	add AC0, AC1

	;save y_n*cos(theta) + x_n*sin(theta) in memory y_n+1 => y_n
	mov hi(AC1),*AR5(-3)	;High part of y_n+1
	mov AC1, *AR5(-2)		;Low part of y_n+1
	
	
	sfts AC1, #-18,AC1
	add #1638, AC1
	mov AC1, T2
	


	
	
	
	ret
