;.global _cordic_sine
		
		;.data
		
		.text
calculate_gain_eq:

;	15dB = 4.623 = 0x49F8
;	12dB = 2.9812 = 0x2FB3
;	9dB = 1.8185 = 0x1D19
;	6dB = 0.9953 = 0x0FED
;	3dB = 0.4125 = 0x069A
gains_eq .macro gain, a1, a3	
	MOV	#0, AR4
	;gain value	shifted #12
	mov #gain, T3
	mov *AR4(a1), T0
	mpym *AR4(a1), T3, AC1
	sfts AC1, #-12, AC1	;shift #-12
	mov AC1,*AR4(a1)	;G*a1/b1
	mov *AR4(a1), T0
	
	;gain value	shifted #12
	mov #gain, T3		
	mov *AR4(a3), T0
	mpym *AR4(a3), T3, AC1
	sfts AC1, #-12, AC1	;shift #-12 
	mov AC1,*AR4(a3)	;G*a3/b1
	mov *AR4(a3), T0
	
	.endm 
	
	;coeff for equalizer - 1st, 2nd, 3rd band
	mov		#3F97h,BSA45		
	gains_eq 0x0FED, 0, 2
	gains_eq 0x0000, 5, 7
	gains_eq 0x0000, 10, 12
	
	;coeff for equalizer - 4th, 5th band
	mov		#3FF7h,BSA45		
	gains_eq 0x0000, 0, 2
	gains_eq 0x2FB3, 5, 7
	
	;coeff for equalizer - high and low shelving
	mov		#40F0h,BSA45		
	gains_eq 0x0000, 0, 1
	gains_eq 0x0000, 5, 6

	ret

equalizer:

	
	mov     #5F87h,BSA45	;move to out buffer
	mov #15, AR5	;filter output
	mov 0x0000, *AR5	;initializing filter output
	
	mov     #5F87h,BSA45	;data ring buffer for equalizer
	MOV	#0, AR5	

filter .macro output, buffer_start
	MOV	#buffer_start, AR5			
	mov #buffer_start, CDP
	
	mov	T2,*AR5(-4)	;The input
	
	mov #buffer_start, T3
	MPYM	*AR5-, *CDP-, AC0	;ACO = Y(N-2)*A2
	MACMZ	*AR5-, *CDP-, AC0	;ACO = Y(N-1)*A1
	MACM	*AR5-, *CDP-, AC0	;ACO = X(N-2)*B2
	MACMZ	*AR5-, *CDP-, AC0	;ACO = X(N-1)*B1
	MACMZ	*AR5, *CDP, AC0		;ACO = X(N)*B0
	sfts	AC0, #-14, AC0	
	mov 	AC0, *AR5(3)	;making it the new output
	MOV	*AR5(3),T1	;move Y(N) to T1
	
	mov     #5F87h,BSA45	;move to out buffer
	mov #15, AR5	;filter output
	add *AR5, T1, T0
	mov T0, *AR5	;filter output
	
	.endm	
	
	;set *CDP to point at coeffs for equalizer
	mov     #3F97h,BSAC	
	;data ring buffer for equalizer - 1st, 2nd, 3rd band	
	mov     #5F87h,BSA45	
	;omega_zero = 200Hz
	filter	3, 4
	;omega_zero = 400Hz
	filter	8, 9
	;omega_zero = 800Hz
	filter	13, 14
	
	;set *CDP to point at coeffs for equalizer
	mov     #3FF7h,BSAC	
	;data ring buffer for equalizer - 1st, 2nd, 3rd band
	mov     #5F9Fh,BSA45	
	;omega_zero = 1600Hz
	filter	3, 4
	;data ring buffer for equalizer - 1st, 2nd, 3rd band
	mov     #5F9Fh,BSA45	
	;omega_zero = 3200Hz
	filter	8, 9
	
	;set *CDP to point at coeffs for equalizer
	mov     #40F0h,BSAC
	;data ring buffer for equalizer - LS and HS			
	mov		#5FF7h,BSA45	
	filter 3, 4	; LS
	;data ring buffer for equalizer - LS and HS
	mov		#5FF7h,BSA45	
	filter 8, 9	;Hs
	
	mov     #5F87h,BSA45	;move to out buffer
	mov #15, AR5	;filter output
	add *AR5, T2, T0
	mov T0, T2	;total output

	ret