;PART 2-TASK6
;Report:
;An assembler program that calculates the largest common divisor of two
;integers a and b
;inputs range:
;		a: 0h to 7fh
;		b: 0h to fh
;The program is implemented in 4 parts:
;PART-1: Acquire input numbers
;------------
;The input numbers a and b are acquired and stored in memory at this part of the program.
;Each symbol input from the user is compared with the 'enter' ascii code. A value range check is not performed, the program assumes that the
;symbols input by the user are in hex format from the set 0-9 or a-f. If the symbol input is not 'enter', it is pushed to stack for further processing.
;There are 2 subroutines defined in the program which processes the input symbols into hex numbers (described in detail below). A 'counter' stored 
;in memory keeps track of the total inputs and proceeds to save the inputs upon the acquision of 2 input numbers.
;------------
;PART-2: GCD calculation
;------------
;This part of the program performs the GCD calculation. The 2 input values are loaded into the registers AL and BL from
;the memory. Modulo function is performed on the inputs in a loop, where the value of a and b are continuously
;updated as required (a = b and b = r where r = mod(a/b))in the loop. The loop ends when the value a = 0,
;upon when b = r represents the GCD of the 2 input numbers. In case the value of input b is 0
;the program is immediately terminated ('division by zero error')
;------------
;PART-3: Display of results
;------------
;The results are displayed in the VDU in this part of the program. Depending on the range of the result (0-9)
;or(a-f), the program jumps to the appropriate section where either 30 or 57 is added to the result
;to get the corresponding ascii code.
;------------
;Subroutines:
;------------
;1.)Procedure to calculate the total input number
;---
;Here the total input number is calculated from the individual symbols input by the user. This is done by adding
;each input symbol to the intermediate result which was obtained after multiplying the previously input symbols
;by a suitable multiplier value (either 1h or 10h depending on place value of symbol).
;---
;2.)Procedure to calculate number from input ascii
;---
;Here, the input number values are extracted from their ascii codes. Depending on if the symbol belongs belongs to
;0-9 or a-f, a value of either 30 or 57 is subtracted from the number value.
;------------
;PART-4: END
;Before terminating the program, the counter vlaue is reinitailized to the orignal value (memory address of first input [3])
;-------------------------------------------------------------------
	CLO
	JMP START	;jump to start 
			;reserve memory spaces to store the input numbers and a counter which will track the number of inputs (limited to 2 by design)
	DB 0		;input number 1
	DB 0		;input number 2
	DB 3		;holds the address to the memory space where the first number input will be stored after processing
START:
	MOV BL,1	;Initialise the register BL with 1. BL will hold value of the multiplier ( 1 or 10), which is required for later processing of input values
	MOV CL,0	;clear register CL 
GETINPUT:
	IN 00		;Get input from keyboard
	CMP AL,0D	;Compare with 'enter'
	JZ SAVNUM	;Exit keyboard and save the number if 'enter' key pressed
	PUSH AL		;Push input to stack
	PUSH BL		;push multiplier value to stack (either 1 or 10)
	PUSH CL		;push intermediate result (if any) to stack
	CALL 70		;call subroutine starting at 70 (the routine to calculate the total input number)
	POP CL		;extract result (intermediate/final) after processing
	POP AL		;reset the Stackpointer, extract value from AL
	POP BL		;reset the Stackpointer, extract value from BL
	JMP GETINPUT	;continue acquiring the input

SAVNUM:			;once user hits 'enter' key, save the value in memory
			;update the counter which tracks the number of inputs 
	MOV DL,[05]	;Load the counter value into the register
	MOV [DL],CL	;save input value into the memory space specified by [DL] (which is [03] for input 1 and [04] for input 2)
	INC DL		;increment value of counter storage cell
	MOV [05],DL	;save the counter value
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
			;following are mathematical operations to properly loop the modulo procedure
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
	JNS A_F_BLOCK	;jump to the subroutine which handles the A_F block processing
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