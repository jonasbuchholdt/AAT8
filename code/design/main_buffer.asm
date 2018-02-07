	.data
		.text

buffer_delay:
	amov    #20000h,XAR0 ; Main data page for the circular buffer and circular buffer address initialisation
	amov    #20000h,XAR1    
	mov     #0x70F,BK03 ; Set buffer vsize of 4 words
	mov     #0,AR0 ; AR2 points to the second slot in the buffer
	mov     #0,AR1 ; AR2 points to the second slot in the buffer
	bset    AR0LC ; AR2 is configured as circular pointer 
	bset    AR1LC
	RET
	
buffer_layer:
	amov    #20000h,XCDP ; Main data page for the circular buffer and circular buffer address initialisation
	mov     #3F87h,BSAC ; Starting address Buffer base address is COEFF[0] = 1000 + 10000 = 11000h -->in the SARAM      
	mov     #0x14,BKC ; Set buffer vsize of 4 words
	mov     #0,CDP ; AR2 points to the second slot in the buffer
	bset    CDPLC ; AR2 is configured as circular pointer 
	RET
	
buffer_gain_coeff:
	amov    #20000h,XAR4	; Main data page for the circular buffer and circular buffer address initialisation
	amov    #20000h,XAR5
	mov     #3F87h,BSA45		; Starting address Buffer base address is COEFF[0] = 1000 + 10000 = 11000h -->in the SARAM      
	mov     #16,BK47			; Set buffer vsize of 1 words
	mov     #0,AR4			; AR2 points to the second slot in the buffer
	mov     #0,AR5	
	bset    AR4LC			; AR2 is configured as circular pointer 
	bset    AR5LC
	mov     #0x1000, *AR4+	;Input gain		;0
	mov     #0x2000, *AR4+	;0.5			;1
	mov     #0x2CCD, *AR4+	;0.7			;2
	mov     #0x199A, *AR4+	;LD scale		;3
	mov     #0x0CCD, *AR4+	;LD			;4
	mov     #0x11EC, *AR4+	;f scale		;5
	mov     #0x35C3, *AR4+	;f			;6
	mov     #0x2B03, *AR4+	;g			;7 
	mov     #0x2D50, *AR4+	;a			;8
	mov     #0x4000, *AR4+	;b1			;9
	mov     #0x399A, *AR4+	;b2			;10
	mov     #0x3334, *AR4+	;b3			;11
	mov     #0x2CCD, *AR4+	;b4			;12
	mov     #0x2667, *AR4+	;b5			;13
	mov     #0x2000, *AR4+	;b6			;14
	mov     #0x4000, *AR4+	;gain			;16
	mov     #46B4h,BSA45    ;gain and coefficients for the flanger
	mov     #0x1000, *AR4+	;gain g=0.7 ;0
	mov     #0x2000, *AR4+	;fl		    ;1
	mov     #0x2CCD, *AR4+	;max_delay(rounded down);2
	mov     #0x199A, *AR4+	;delay (variable);3
	mov     #0x0CCD, *AR4+	;c2			;4
	mov     #0x1800, *AR4+	;d2	        ;5
	mov     #0x35C3, *AR4+	;final		;6 	
		
	RET 