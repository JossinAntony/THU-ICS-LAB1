;TASK-3
;REPORT:
;Implementation of a 'for' loop.
;The loop variable(countervalue) is incremented and always compared with the limit value 6
;via JUMP conditions (JS,JNS,JMP). As long as it satisfies the conditions
;(counter value less than 6)the input vlaue is incremented by 3. 
;The result is displayed in the VDU.

;---------------------------------------------------------
	CLO		;Close all peripheral devices

	MOV AL,3	;Load the initial countervalue (3) into the register AL
	MOV BL,0	;Load the initial numerical value (0) into the register BL
	
	MOV DL,C0	;Load the initial value C0 (which corresponds to the first element of the VDU into the register DL)
	
CMP:	
	CMP AL,6	;Compare value of counter variable with 6 (as required by the question)

	JS LOOP		;Jump to step marked by LOOP if comparison sets s flag, indicating that the numerical value is less than the counter value
	JNS DISPLAY	;Jump to step marked by DISPLAY if comparison does not set s flag,
			;indicating that the numerical value is not less than the counter value

LOOP:	
	ADD AL,1	;Increment the countervalue in the register AL by 1. This step is also marked LOOP to be used for JUMP statement later.
	ADD BL,3	;Increment the numerical value in the register BL by 3 (as required in the question)
	JMP CMP		;Jump to step marked by CMP to check the status of the conditional statement (numerical value < limit value)
	
DISPLAY:
	ADD BL,30	;Add 30 to the register BL, so that the ASCII code corresponding to the numerical value is produced
	MOV [DL],BL	;Copy contents of register BL into the memory cell pointed out by [CL], so that it is displayed in the VDU
	END		;Halt the execution of the program