;PART 2- TASK 5
;REPORT:
;A program to find the modulo of 2 input numbers.
;The input numbers are pushed to stack where the modulo function (MOD)is executed.
;The result is displayed in the VDU.
;Input value range:
;			a: 0h<=a<=7Fh
			b: 0h<=a<=9h
;------------------------------------------------------------
	CLO			;close all peripheral devices
	JMP START		;jump to start 

START:
	MOV AL,1A		;Move the input numbers whose modulo is to be found to registers AL and BL
	MOV BL,9
	MOV CL,C0		;Load the initial value C0 (which corresponds to the first element of the VDU into the register CL)
	PUSH AL			;push parameter values to stack
	PUSH BL

	CALL 30			;call subroutine at 30 which processes the modulo function

	POP BL			;extract results from stack
	POP AL

	ADD AL,30		;convert the result to equivalent ascii code	
	MOV [CL],AL		;move the result to VDU address for display

	ORG 30
	POP DL			;save the value of RET address on stack
	POP BL			;extract parameter values from stack
	POP AL
	MOD AL,BL		;find the modulo
	PUSH AL			;push the results back to stack
	PUSH BL
	PUSH DL			;push the RET address on stack
	RET			;return to the main procedure
	
	
	END

