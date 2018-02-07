MSWRr .equ 0x2829
MSWRl .equ 0x282D

      .text
in:
recieve_flag:
	BTST #2,port(#02810h) ,TC1 ;Looking at receive flag
	BCC recieve_flag ,!TC1 ;Continue if flag is set
	MOV port(#MSWRl) ,T1 ;Reading left side
	MOV port(#MSWRr) ,T2 ;Reading right side
	RET