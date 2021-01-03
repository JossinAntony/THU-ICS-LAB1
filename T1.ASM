	CLO		;Close all peripheral devices

	MOV AL,3	;Load the initial value 3 into the reigster AL
	MOV BL,C0	;Load the initial value C0 (which corresponds to the first element of the VDU into the register BL)
	

	CMP AL,5	;Condition evaluation: The numerical value in AL is compared with the value 5h as given in the question.
	JNS DISPLAY	;If the S flag is not set (i.e, value not less than limit value), JUMP to display steps
	ADD AL,1	;If the set flag is set (value < limit value), increment the numerical value in the register AL

DISPLAY:
	ADD AL,30	;Add 30 to the register AL, so that the ASCII code corresponding to the numerical value is produced	
	MOV [BL],AL	;Move the value in register AL to the memory cell pointed out by [BL] (for display in the VDU)
	END		;Halt program after execution

