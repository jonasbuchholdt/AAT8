
coeffreverb .set 3F98h
datacomb1 .set 0000h
datacomb2 .set 070Fh
datacomb3 .set 0E1Eh
datacomb4 .set 152Dh
datacomb5 .set 1C3Ch
datacomb6 .set 234Bh
dataall1 .set 2A5Ah
dataall2 .set 3169h
datapre .set 3878h
datax .set 3F87h




      .text

reverb_pre:
	mov     #datax,BSA45		;Select X1
	mov     #datapre,BSA01		;Select PreReverb 
	mov		T2, *AR0			;Safe input data into buffer
	mov 	*AR0(-0x100), AC0	;First tab
	mov 	*AR0(-0x101), AC1	;secund tab	
	Add		AC1, AC0			;Y = X(N-ed1)+X(N-ed2)
	mov 	*AR0(-0x102), AC1	;third tab	
	Add		AC1, AC0			;Y = X(N-ed3)+Y
	mov 	*AR0(-0x103), AC1	;forth tab
	Add		AC1, AC0			;X1(N) = X(N-ed3)+Y
	mov 	AC0, *AR5			;Flyt X1(N) i buffer
	ret

reverb_lpcf:

	;get delayed data X1(N-1) initializing 
	mov		AC0,T2				;get X1(N)
	mov		*AR5(-1), AC2		;get X1(N-1)
	mov     #coeffreverb,BSA01		;Select coffecient
	mov     #coeffreverb,BSA45		;Select coffecient
	mov     #coeffreverb,BSAC		;Select coffecient
	;calculate LD
	mov		#1,CDP
	MPYM 	*AR4(3), *CDP, AC0	;0.5 * user input (init of 0.4)
	SFTS 	AC0, #-14, AC0		;LD	(init LD = 0.2)
	mov		AC0,*AR4(4)			;store LD in AR4 slot number 4
	;calculating X1(N-1)*-LD
	neg		AC0,AC0				;invert the sign for LD
	SFTS 	AC0, #16, AC0		;bit shift
	SFTS 	AC2, #16, AC2		;bit shift
	MPY 	AC0, AC2			;X1(N-1)*-LD
	;SFTS 	AC2, #-14, AC2		;result of X1(N-1)*-LD
	;calculate the g
	;f = 0.5*scaleroom+0.7
	MPYM 	*AR4(5), *CDP, AC1	;0.5 * user input (init of 0.4)
	SFTS 	AC1, #-14, AC1		;bit shift
	add		*AR4(2),AC1			;AR4 slot number 2 + AC1
	mov		AC1, *AR4(6)		;result of f
	; g=f*(1-LD) = f-(f*LD)
	mov		#4,CDP				;LD
	MPYM	*AR4(6), *CDP, AC1		;(f*LD)
	SFTS 	AC1, #-14, AC1		;bit shift
	sub		AC1,*AR4(6),AC1		;f-(f*LD)
	mov		AC1,*AR4(7)			;store g in AR4 slot number 7
	;mov		AC2,T2
	
	;LPCF
LPCF	.macro mem, del, bval 	
	mov     #mem,BSA01			;select lpcf1 	
	mov 	*AR0(-1), T0		;X2(N-1) move in to T0
	MPYM 	*AR4(4), T0, AC0	;X2(N-1)*LD
	mov 	*AR0(del), T0		;X2(N-D) move in to AC1
	MPYM 	*AR4(7), T0, AC1	;X2(N-D)*g
	Add		AC2, AC0			;X1(N-1)*-LD + X2(N-1)*LD
	Add		AC1, AC0			;X1(N-1)*-LD + X2(N-1)*LD + X2(N-D)*g
	SFTS 	AC0, #-14, AC0		;bit shift
	add		T2, AC0				;X1(N-1)*-LD + X2(N-1)*LD + X2(N-D)*g + X1(N)
	mov		AC0, *AR0			;store input data i buffer
	mov		#bval,CDP	
	MPYM 	*AR0, *CDP, AC0		;(X1(N-1)*-LD + X2(N-1)*LD + X2(N-D)*g + X1(N))*b1
	.endm
  	LPCF	datacomb1, -0x345, 9
  	mov		AC0,AC3
	LPCF	datacomb2, -0x3F5, 10
	add		AC0,AC3
	LPCF	datacomb3, -0x4FE, 11
	add		AC0,AC3
	LPCF	datacomb4, -0x556, 12
	add		AC0,AC3
	LPCF	datacomb5, -0x65E, 13
	add		AC0,AC3
	LPCF	datacomb6, -0x70E, 14
	add		AC0,AC3	
	ret


reverb_allpass:
Allpass	.macro mem, del, aval 	
	mov     #mem,BSA01			;select lpcf1	 	
	mov 	*AR0(del), T0		;X2(N-D) move in to T0
	MPYM 	*AR4(aval), T0, AC1	;X2(N-D)*a
	Add		AC3, AC1			;X2(N)+X2(N-D)*a
	SFTS 	AC1, #-14, AC1		;bit shift
	mov		AC1,*AR0			;safe X2(N)+X2(N-D)*a
	mov		*AR4(aval),T0		;a
	neg		T0,T0				;-a
	MPYM 	*AR0, T0, AC3		;(X2(N)+X2(N-D)*a)*-a	
 	mov		*AR0(del),AC0		;(X2(N)+X2(N-D)*a)
 	SFTS 	AC0, #14, AC0		;(X2(N)+X2(N-D)*a)>>14
	Add	 	AC0,AC3	
	.endm
	
  	Allpass	dataall1, -0x2ED, 8 	;-0x2ED
    Allpass	dataall2, -0x23D, 8	;-0x23D
	SFTS 	AC3, #-14, AC3		;bit shift    
    mov		AC3,T2
	mov     #datax,BSA45	;Select X1
	add		*AR5, T2
	mov		*AR5+, T0			;count up
	mov		*AR0+, T0
	ret
	