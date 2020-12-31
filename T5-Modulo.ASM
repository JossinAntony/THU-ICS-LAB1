	CLO			;close all peripheral devices
	JMP START		;jump to start 

START:
	MOV AL,1A		;Move the input numbers whose modulo is to be found to registers AL and BL
	MOV BL,9
	MOV CL,C0
	PUSH AL			;push parametr values to stack
	PUSH BL

	CALL 30			;call subroutine at 30 which processes the modulo function

	POP BL			;extract results from stack
	POP AL

	ADD AL,30		;convert the result to equivalent ascii code	
	MOV [CL],AL		;move the result to VDU address for display

	ORG 30
	POP DL			;extract parameter values from stack
	POP BL
	POP AL
	MOD AL,BL		;find the modulo
	PUSH AL			;push the results back to stack
	PUSH BL
	PUSH DL
	RET			;return to the main procedure
	
	
	END

