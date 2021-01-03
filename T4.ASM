;TASK-4
;REPORT:
;Implementation of a combination of a 'for' loop and and an 'if' block.
;The loop variable(countervalue) is incremented and always compared with the limit value 6
;via JUMP conditions (JS,JNS,JMP). WIthin the block when the countervalue is equal to 3, 
;the input value is incremented by 3.
;Both the counter value and result are displayed on the VDU.
;------------------------------------------------------------
		CLO		;Close all peripheral devices

		MOV AL,0	;Load the initial countervalue into the register AL
		MOV BL,0	;Load the initial numerical value into the register BL
		
		MOV DL,C0	;Load the initial value C0 (which corresponds to the first element of the VDU into the register CL)

LOOP:		CMP AL,6	;Compare value of counter variable with limit value (6) as required by the question
		JNS DISPLAY	;if the counter value is not less than the limit value,
				;jump to statement marked by DISPLAY to display the values (because the loop will not run)
				
		CMP AL,3	;Evaluation of inner condition. Compare the register value of AL with the limit value (3)
		JZ  AIS3	;If the zero flag is set (i.e counter value is equal to 3),
				;JUMP to increment step marked by AIS3 as described in question
		JNZ AISNOT3	;If the zero flag is not set(i.e, counter value is not equal to 3),
				;JUMP to the step marked by AISNOT3 to continue with exection of program

AIS3:		ADD BL,3	;Increment the numerical value in the register BL by 3 (as required in the question)
	
AISNOT3:	ADD AL,1	;Increment the countervalue in the register AL by 1.
				;This step is also marked LOOP to be used for JUMP statement later.
		JMP LOOP	;Jump to step marked by LOOP to contine comparing the counter value and limit value

DISPLAY:	ADD AL,30	;Add 30 to the register AL, so that the ASCII code corresponding to the numerical value is produced
		MOV [DL],AL	;Copy contents of register AL into the memory cell pointed out by [DL], so that it is displayed in the VDU

		ADD DL,10	;ADD 10h to DL so that [DL] points to the nextline in VDU

		ADD BL,30	;Add 30 to the register AL, so that the ASCII code corresponding to the numerical value is produced
		MOV [DL],BL	;Copy contents of register BL into the memory cell pointed out by [DL], so that it is displayed in the VDU

		END		;Halt the execution of the program