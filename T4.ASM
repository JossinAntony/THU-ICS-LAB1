		CLO		;Close all peripheral devices

		MOV AL,0	;Load the initial countervalue into the register AL
		MOV BL,0	;Load the initial numerical value into the register BL
		MOV CL,6	;Load the limit value into the register CL
		MOV DL,C0	;Load the initial value C0 (which corresponds to the first element of the VDU into the register CL)

LOOP:		CMP AL,CL	;Compare value of counter variable with limit value (6) as required by the question
		JNS RESUME	;if the counter value is not less than the limit value, jump to statement marked by RESUME to display the values (because the loop will not run)
				
		CMP AL,3	;Evaluation of inner condition. Compare the register value of AL with the limit value (3)
		JZ  AIS3	;If the zero flag is set (i.e counter value is equal to 3), JUMP to increment step marked by AIS3 as described in question
		JNZ AISNOT3	;If the zero flag is not set(i.e, counter value is not equal to 3), JUMP to the step marked by AISNOT3 to continue with exection of program

AIS3:		ADD BL,3	;Increment the numerical value in the register BL by 3 (as required in the question)
	
AISNOT3:	ADD AL,1	;Increment the countervalue in the register AL by 1. This step is also marked LOOP to be used for JUMP statement later.
		JMP LOOP	;Jump to step marked by LOOP to contine comparing the counter value and limit value

RESUME:		ADD AL,30	;Add 30 to the register AL, so that the ASCII code corresponding to the numerical value is produced
		MOV [DL],AL	;Copy contents of register AL into the memory cell pointed out by [DL], so that it is displayed in the VDU

		ADD DL,10	;ADD 10h to DL so that [DL] points to the nextline in VDU

		ADD BL,30	;Add 30 to the register AL, so that the ASCII code corresponding to the numerical value is produced
		MOV [DL],BL	;Copy contents of register BL into the memory cell pointed out by [DL], so that it is displayed in the VDU

		END		;Halt the execution of the program