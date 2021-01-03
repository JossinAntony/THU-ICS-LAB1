;Write an assembler program that calculates the largest common divisor of two
;integers a and b
;inputs range:
;		a: 0 to 7f
;		b: 0 to f


;---------
	CLO		;close all peripheral devices
	JMP START	;jump to start 
	DB 0		;reserve memory spaces to store the input numbers and a counter which will track the number of inputs (limited to 2 by design)
	DB 0
	DB 3		;holds the address to the memory space where the first number input will be stored after processing
;----------------------------------------------------------------
;PART-1: Acquire input numbers
;----------------------------------
START:
	MOV BL,1	;Initialise the register BL with 1. BL will hold value of the multiplier ( 1 or 10), which is required for later processing of input values
	MOV CL,0	;clear register CL 
GETINPUT:
	IN 00		;Get input from keyboard
	CMP AL,0D	;Compare with 'enter'
	JZ SAVNUM	;Exit keyboard and save the number if 'enter' key pressed
	PUSH AL		;Push input to stack
	PUSH BL		;push multiplier alue to stack (either 1 or 10)
	PUSH CL		;push intermediate result (if any) to stack
	CALL 70		;call subroutine starting at 70 (the routine to calculate the total input number)
	POP CL		;extract result (intermediate/final) after processing
	POP AL		;reset the Stackpointer, extract value from AL
	POP BL		;reset the Stackpointer, extract value from BL
	JMP GETINPUT	;continue acquiring the input

SAVNUM:			;once user hits 'enter' key, save the value in memory

	MOV DL,[05]	;update the counter which tracks the number of inputs 
	MOV [DL],CL
	INC DL
	MOV [05],DL
	CMP DL,5	;if counter value exceeds 4, it means that both the input numbers have been acquired.If not, continue acquiring number inputs
	JS START	;Continue with acquiring input
;----------------------------------------------------------------
;PART-2: GCD
;----------------------------------
	MOV AL,[03]	;load the saved input 1 to AL for processing
	MOV BL,[04]	;load the saved input 2 to BL for processing
	CMP BL,0	;if the value in BL is zero, terminate the procedure (zero error)
	JZ END
REPGCD:
	MOD AL,BL	;calculate modulo
	CMP AL,0	;check if AL is zero (i.e, if GCD has been reached)
	JZ DISPLAY	;if GCD has been reached, go to the display section
			;following are mathematical operations to properly loop the GCD program
	PUSH AL		; = r
	PUSH BL		; = b
	POP AL		; = b
	POP BL		; = r
	JMP REPGCD	;loop the program
;----------------------------------------------------------------
;PART-3: Display of GCD value
;----------------------------------
DISPLAY:
	CMP BL,A	;compare GCD value with A
	JNS DISPLAYHEX	;if the result is greater than 9, got to the hex symbol processing part
	ADD BL,30	;if the result is in range 0-9, add 30 to convert them to equivalent ascii codes
	MOV [C0],BL	;display the result in ascii
	JMP END		;jump to end section
DISPLAYHEX:
	ADD BL,57	;if the result is in range A-F, add 57 to convert them to equivalent ascii codes
	MOV [C0],BL	;display the result in ascii
	JMP END		;jump to end section
ERROR:
			;to capture 'division by zero' error if any
;#################################################################
;Subroutines
;##########
;1.)Procedure to calculate the total input number
;-------------------------
	ORG 70		
	POP DL		;extract values from stack
	POP CL
	POP BL
	POP AL
	CALL A0		;call subroutine at A0 to extract values from ascii codes
	MUL CL,BL	;multiply the intermediate result by suitable multiplier (1 or 10)
	ADD CL,AL	;add the latest acquired input value to the intermediate result
	CMP BL,1	;update the multiplier value to 10 starting from the second acquired input number
	JNZ SKPINCRMNT
	MOV BL,10	;update multiplier
SKPINCRMNT:
	PUSH BL		;push the values to stack for parameters return
	PUSH AL
	PUSH CL
	PUSH DL
	RET
;--------------------------------------------
;2.)Procedure to calculate number from input ascii
;----------------------
	ORG A0
	CMP AL,40	;if the ascii codes are greater than 39, they belong to the A-F block,5
	JNS A_F_BLOCK	;jump to the subrouine which handles the A_F block processing
	SUB AL,30	;for input number in range 0-9, extract the values by subtracting 30
	JMP EXITNUMCALC	;exit the subroutine
A_F_BLOCK:
	SUB AL,57	;for extracting input values in range A-F, subtract 57 from the input ascii codes
EXITNUMCALC:
	RET		;Return to the main program
;----------------------------------------------------------------
END:
			;reintialize the value of counter with memory address 03 where first input number will be stored.
	MOV AL,03	
	MOV [05],AL
	END