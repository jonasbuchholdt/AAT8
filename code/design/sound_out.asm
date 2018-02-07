MSWWr .equ 0x2809
MSWWl .equ 0x280D
	
      .text
out:
transmit_flag:
	BTST #4,port(#02810h) ,TC1 ;Looking at receive flag
	BCC transmit_flag ,!TC1 ;Continue if flag is set
	MOV T1, port(#MSWWl) ;Writing left side
	MOV T2, port(#MSWWr) ;Writing right side
	RET