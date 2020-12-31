	CLO
	JMP START
	DB 0		;Reserve memory space for storing input number
	DB 1		;Reserve memory space for multiplier
	DB 0		;Reserve memory space for storing computed number

START:
	IN 00		;Get input from keyboard
	CMP AL,0D	;Compare with 'enter'
	JZ EXIT		;Exit keyboard if 'enter' key pressed
	PUSH AL		;Push input to stack
	CALL 50		;input number calculation procedure
	JMP START	;Continue with acquiring input
EXIT:
;---------------------
	ORG 50		;Initiate procedure to calculate input number
	POP DL
	POP AL

	CALL 90
	MOV [03],AL
	MOV BL,[04]
	MOV CL,[05]
	MUL CL,BL
	ADD CL,AL
	MOV [05],CL
	CMP BL,1
	JNZ SKPINCRMNT
	MUL BL,10
	MOV [04],BL
SKPINCRMNT:
	PUSH DL
	RET
;------------------
	ORG 90

	CMP AL,39
	JNS A_F_BLOCK
	SUB AL,30
	JMP EXITNUMCALC
A_F_BLOCK:
	SUB AL,57
EXITNUMCALC:
	RET	
;-------------------	
END:
	END