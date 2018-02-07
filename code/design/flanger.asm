coefflanger .set 46DAh
dataflanger .set 3FCBh


		.data
			.text

flang_delay_LFO_approx3:

mov #3FCBh,BSA01
mov #46DBh,BSA45 ;gain and coefficients for the flanger
mov #0,AR4	  ;Pointer Settings
mov	T2, *AR0(0);Putting the input in the buffer
mov	*AR4(7), T3	;high part of cordic X1
add	#100, T3  ;Adding an offset
add	#1, T3, T0 ;calculating x2
neg	T0, T0
neg	T3, T3
mov	T3, *AR4(14) ;storing X1
mov	T0, *AR4(15) ;storing X2
mov	*AR4(14), T0 ;unloading X1
mov	*AR0(T0), AC0	;unloading Yn
mov	*AR4(15), T0	;unloading X2
mov	*AR0(T0), AC1	;unloading Yn-1
sub	AC0, AC1	;doing (Yn-1)-(Yn)
mov	*AR4(10), AC0	;unloading the fraction
sfts AC0, #16, AC0
SFTL AC0, #-1, AC0	;shifting the fraction by 1
mov	hi(AC0), *AR4(13)	;moving the fraction to memory
mov	AC1, T0	;moving Y2-Y1 to T0
mpym *AR4(13), T0, AC2	;multiplying the fraction by Y2-Y1
SFTS AC2, #-15, AC2	;shifting the result by 15
mov *AR4(14), T0 ;unloading X1
mov	*AR0(T0), AC0	;unloading Yn
sub	AC2, AC0 ;substracting AC2(line 29) from Y2
mov	AC0, T1
mpym *AR4(0), T1, AC3 ;Multiplying the delayed value with the gain
SFTS AC3, #-14, AC3 ;bit shift after multiplication
mov *AR0+, T0	;Incremementing the data buffer
add AC3, T2 ;Adding the delayed line to the undelayed
ret

flang_delay_LFO_approx:


	mov #dataflanger,BSA01
	mov #coefflanger,BSA45  ;gain and coefficients for the flanger
	mov #0,AR4 ;Pointer Settings
	mov	*AR4 (10), T1 ;The low part
	mov	*AR4(7), T3	;high part

	abs T3, T3	;taking the absolute value before negating to ensure negativity
	add	#1, T3, T0	;the value after the integer (high part)
	neg	T0, T0 ;T0 now has the integer after the value
	neg	T3, T3	;	T3 has the value of the highpart
	mov	T3, AC1	; thE VALUE OF T3 THE HIGH PART IS IN AC1
	mov	T0, AC2	;THE VALUE OF T0 THE INTEGER AFTER IS IN AC2
	mov	T1,	AC0	;The value of the fraction is in AC0

	mov *AR0(T0), T0
	abs	T0, T1
	cmp T0 == T1, TC2		;Finding the sign
	bcc	positive,	TC1
	bcc	negative,	!TC1

positive:
	mov	AC1, T1
	mov	*AR0(T1), T1
	cmp T1 < T0, TC2
	bcc	case_one,	TC2		;positive_ascending
	bcc	case_two, !TC2		;postive_desending

negative:
	mov	AC1, T1
	mov	*AR0(T1), T1
	cmp T1 < T0, TC2
	bcc	case_two,	TC2		;negative_ascending
	bcc	case_one, !TC2	;negative_desending

	;First Case (Positive, Ascending) ;Third Case (Negative, Descending)
case_one:
	mov	AC2,T0 ;Unloading the highpart + 1
	mov	AC1, T1 ;Unloading the highpart
	mov	*AR0(T0), AC3 ;taking the sample delayed by T0 samples
	sub	*AR0(T1), AC3, AC3  ;DeltaY into AC3
	mov	AC0, *AR4(11)
	mov	AC0, T0	;Taking the fraction part
	mov	#11, AR4
	mov	#65532, AC0 ;65532 is FFFC in hex
	sub	uns( *AR4),	AC0, AC0 ;Calculating Delta X
	mov	#0, AR4
	add	#4, AC0
	mov	#0001h, T0
	cmp	T0 == #0001h, TC2
	bcc	final, !TC2

	;Second Case (Positive, Descending)	;Fourth Case (Negative, Ascending)
case_two:
	mov		AC2,	T0
	mov		AC1, T1
	mov		*AR0(T1), AC3
	sub		*AR0(T0), AC3, AC3  ;DeltaY into AC3
	neg     AC3, AC3
	mov		AC0, T0				;Getting the fraction part into the temp reg
	mov		T0, AC0				;moving deltaX into a safe part for the future(AC0 Ovewritten, fraction part lost)

final:
	mov	AC0, T0				;unloading the deltaX
	mov	AC3, T1				;unloading deltaY
	SFTS AC0, #16, AC0		;Getting ready for multiplication (Here you have deltaX)
	SFTS AC3, #16, AC3		;Getting ready for multiplication (Here you have deltaY)
	mpy AC0, AC3			;first step to calculate y' (deltaY LOST)
	SFTS AC3, #-14, AC3
	mov T0, *AR4(11)
	sub AC3, *AR4(11), AC3		;y' calculated
	bcc	positive_final,	TC1
	neg	AC3, AC3

positive_final:
	mov	AC1 	,T0		;unloading the highpart
	mov	*AR0(T0), AC0
	add	AC0, AC3		;finding the final value of the delayed line
	mpym *AR4(0), T1, AC3      ;Multiplying the delayed value with the gain
	SFTS AC3, #-14, AC3		  ;bit shift after multiplication
	mov	*AR0+, T0
	add	AC3, T2		  ;Adding the delayed line with the undelayed
	ret




;chorus_delay_LFO:

;	mov     #3FCBh,BSA01
;	mov     #46DAh,BSA45    ;gain and coefficients for the flanger
;	mov     #0,AR4
;	mov		#0,	*AR4(6)
;	Flang .macro delay, gain
;				  ;Pointer Settings
;	;mov     #0x3FA5,BK03          ; Starting address for the flanger effect
;	;mov		#0,AR0				  ;Pointer Settings
;	mov		T2, *AR0(0)           ;Putting the input in the buffer
;	mov		*AR4(7), T3
;	mpym	delay, T3, AC3  ;Starting calculating the variable delay value
;	SFTS 	AC3, #-14, AC3		  ;bit shift after multiplication
;	mov		AC3, T0		  ;Second step into calculating the variable delay value
;	abs 	T0, T0			  ;Calculating the absolute value of the delay
;	;mov		T0, *AR4(3)           ;Saving the delay value in the gain and coefficients buffer
;	;sub		T0, *AR4(2), T0		  ;calculating the value of the slot index (max_delay - abs(delay))
;	neg		T0, T0
;	mov		*AR0(T0), T1		  ;Taking the delayed value from the buffer
;	;mov		*AR4(0), T3
;	mpym	gain, T1, AC3      ;Multiplying the delayed value with the gain
;	SFTS 	AC3, #-14, AC3		  ;bit shift after multiplication
;	mov		*AR4(6), T0		  ;Adding the delayed line with the undelayed
;	add		T0, AC3
;	mov		AC3, *AR4(6)
;	.endm
;
;	Flang	0x0084, 0x2000
;	Flang	0x0028, 0x1333
;	Flang	0x0020, 0x2666
;	mov		*AR0+, T0
;
;	add		*AR4(6), T2
;	RET

	;Approximation code:

;flang_delay_LFO_Approx:
	;mov     #0,AR4				  ;Pointer Settings
	;mov     #0x3FA5,BK03          ; Starting address for the flanger effect
	;mov		#0,AR0				  ;Pointer Settings
	;mov		T2, *AR0(0)           ;Putting the input in the buffer
	;mpym	*AR4(2), cordic, AC3  ;Starting calculating the variable delay value
	;SFTS 	AC3, #-14, AC3		  ;bit shift after multiplication
	;sub		0x2, AC3, T0		  ;Second step into calculating the variable delay value
	;mov		T0, *AR4(3)           ;Saving the delay value in the gain and coefficients buffer
	;abs 	*AR4(3), T0			  ;Calculating the absolute value of the delay and rounding it down (By storing in T0) (x1)
	;sub		0x1, T0, T1			  ;calculating x2
	;sub		*AR0(-T0),*AR0(-T1), T3 ;Calculating y2-y1
	;mov		*AR0(-T0), AC3
	;sub		T0, T1, T1			  ;Calculating x2-x1
	;abs		*AR4(3), *AR4(3)	  ;Absolute value of the delay without rounding down
	;sub		*AR4(3), *AR4(2), AC0		  ;calculating the value of the slot index (max_delay - abs(delay))
	;sub		T0, AC0, AC0		;Calculating c2
	;mpym	AC0, T3	,AC0			;calculating d2
	;SFTS 	AC3, #-14, AC3
	;add		AC3, AC0			;y1 to the d2
	;mpym	*AR4(0), AC3, AC3      ;Multiplying the delayed value with the gain
	;SFTS 	AC3, #-14, AC3		  ;bit shift after multiplication
	;add		AC3, T2, T2		  ;Adding the delayed line with the undelayed
	;RET

;flang_delay_LFO_approx2:

	;mov     #3FCBh,BSA01
	;mov     #46DAh,BSA45    ;gain and coefficients for the flanger
	;mov     #0,AR4				  ;Pointer Settings
	;mov     #0x3FA5,BK03          ; Starting address for the flanger effect
	;mov		#0,AR0				  ;Pointer Settings
	;mov		T2, *AR0(0)           ;Putting the input in the buffer
	;mpym	*AR4(2), T3, AC3  ;Starting calculating the variable delay value
	;SFTS 	AC3, #-14, AC3		  ;bit shift after multiplication
	;sub		0x2, AC3, T0		  ;Second step into calculating the variable delay value
	;sub		0x1, T0, T1			  ;calculating x2
	;abs 	T0, T0			      ;Calculating the absolute value of the delay
	;mov		T0, *AR4(3)           ;Saving the delay value in the gain and coefficients buffer
	;sub		T0, *AR4(2), T0		  ;calculating the value of the slot index (max_delay - abs(delay))
	;abs		T0, T0
	;neg		T0, T0
	;neg		T1, T1
	;mov 	AR0, CDP
	;mov		*AR0(T1), AC2
	;sub		*AR0(T0),AC2, AC1 ;Calculating y2-y1
	;mov		AC1, T3
	;mov		*AR0(T0), AC3		;storing y1 into AC3

	;neg		T0, T0
	;sub		T0, AC0, AC0		;Calculating c2
	;mpym	T3,  AC0, AC0		;calculating d2
	;SFTS 	AC0, #-14, AC0
	;add		AC3, AC0			;y1 to the d2
	;mpym	*AR4(0), AC0, AC3      ;Multiplying the delayed value with the gain
	;SFTS 	AC3, #-14, AC3		  ;bit shift after multiplication
	;mov		*AR0+, T0
	;add		AC3, T2		  ;Adding the delayed line with the undelayed
	;RET

flang_delay_LFO:


	mov     #3FCBh,BSA01
	mov     #46DAh,BSA45    ;gain and coefficients for the flanger
	mov     #0,AR4				  ;Pointer Settings
	;mov     #0x3FA5,BK03          ; Starting address for the flanger effect
	;mov		#0,AR0				  ;Pointer Settings
	mov		T2, *AR0(0)           ;Putting the input in the buffer
	mov		*AR4(7), T0
	;mpym	*AR4(2), T3, AC3  ;Starting calculating the variable delay value
	;SFTS 	AC3, #-14, AC3		  ;bit shift after multiplication
	;mov		AC3, T0		  ;Second step into calculating the variable delay value
	abs 	T0, T0			  ;Calculating the absolute value of the delay
	;mov		T0, *AR4(3)           ;Saving the delay value in the gain and coefficients buffer
	;sub		T0, *AR4(2), T0		  ;calculating the value of the slot index (max_delay - abs(delay))
	neg		T0, T0
	mov		*AR0(T0), T1		  ;Taking the delayed value from the buffer
	;mov		*AR4(0), T3
	mpym	*AR4(0), T1, AC3      ;Multiplying the delayed value with the gain
	SFTS 	AC3, #-14, AC3		  ;bit shift after multiplication
	mov		*AR0+, T0
	add		AC3, T2		  ;Adding the delayed line with the undelayed
	RET

				;cordic needed
