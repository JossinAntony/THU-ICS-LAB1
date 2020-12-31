	CLO
	JMP START
	DB 0		;Reserve memory space for storing input number
	DB 1		;Reserve memory space for multiplier
	DB 0		;Reserve memory space for storing computed number
	DB 0		;Reserve memory space for counter which tracks count of input numbers for gcd Calculation
	DB 0		;Reserve memory space for input 1
	DB 0		;Reserve memory space for input 2

START:
	MOV BL,1
GETINPUT:
	IN 00		;Get input from keyboard
	CMP AL,0D	;Compare with 'enter'
	JZ EXIT		;Exit keyboard if 'enter' key pressed
	PUSH AL		;Push input to stack
	PUSH BL
	PUSH CL
	CALL 50
	POP CL
	POP AL
	POP BL
	JMP GETINPUT
EXIT:
	MOV [7],CL
	MOV BL,1
	;JMP START	;Continue with acquiring input

;---------------------
	ORG 50		;Initiate procedure to calculate input number
	POP DL
	POP CL
	POP BL
	POP AL

	CALL 90
	MUL CL,BL
	ADD CL,AL
	CMP BL,1
	JNZ SKPINCRMNT
	MUL BL,10
SKPINCRMNT:
	PUSH BL
	PUSH AL
	PUSH CL
	PUSH DL
	RET
;------------------
	ORG 90

	CMP AL,40
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