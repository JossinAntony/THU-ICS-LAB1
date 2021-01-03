;TASK-2
;Report:
;Implementation of an 'if-else' loop. The input number is compare with the numerical value 3.
;If the input vlaue is equal to 3, increment the number by 1.
;Else, increment the vlaue by 2
;Display the result in the VDU.
;-----------------------------------------------
		CLO		;Close all peripheral devices

		MOV AL,3	;Load the initial value into the reigster AL
		MOV BL,C0	;Load the initial value C0 (which corresponds to the first element of the VDU)into the register BL
		MOV CL,3	;Load the limit value (3) to the register CL
		
		CMP AL,CL	;Compare the numerical value with 3h (as described in the question)
		JZ AIS3		;Jump to step marked by AIS3 if comparison sets z flag, indicating that the compared values are equal (to 3h as per the question)
		JNZ AISNOT3	;Jump to step marked by AISNOT3 if comparison does not set z flag, indicating that the compared values are not equal (to 3h as per the question)

AIS3:		ADD AL,1	;Add 1 to the value stored in register AL as required by question, if values are equal
		JMP DISPLAY	;Jump to the step marked DISPLAY to contine the program execution

AISNOT3:	ADD AL,2	;Add 2 to the value stored in register AL as required by question, if values are not equal

DISPLAY:	ADD AL,30	;Add 30 to the register AL, so that the ASCII code corresponding to the numerical value is produced.
				;Program execution continues after going through the JUMP instructions
		MOV [BL],AL	;Move the value in register AL to the memory cell pointed out by [BL] (for display in the VDU)
		END		;Halt the program	
	