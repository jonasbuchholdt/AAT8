		.text
		
buffer:

  amov    #10000h,XAR2 ; Main data page for the circular buffer and circular buffer address
                        ;initialisation
  mov     #1000h,BSA23 ; Starting address Buffer base address is COEFF[0] = 1000 + 10000 =
                        ;11000h -->in the SARAM
  mov     #0x4,BK03  ; Set buffer size of 4 words
  mov     #2,AR2   ; AR2 points to the second slot in the buffer
  bset    AR2LC ; AR2 is configured as circular pointer 
  MOV     #0x4000, T3
  mov 	T3, *AR2
  mov     *AR2+,T0 ; T0 is loaded with COEFF[2]
  mov     *AR2+,T1 ; T1 is loaded with COEFF[3]
  mov     *AR2+,T2 ; T2 is loaded with COEFF[0]
  mov     *AR2+,T3 ; T3 is loaded with COEFF[1]
  RET






	
	