
	.global _start
	.global _intasm
	.text
	
_intasm:	
	call buffer_coff
	call buffer_lpcf_delay
	call buffer_gain
	RET	

_start:
	call in
	bset XF ;
	call input_gain
	call reverb_pre
	call reverb_lpcf
	call reverb_allpass
	bclr XF ;
	call out
	call _start
	
	.include "sound_in.asm"
	.include "sound_out.asm"
	.include "reverb.asm"