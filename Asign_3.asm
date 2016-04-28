;Assignment3_Integer Accumulator      (Asign_3.asm)

; Author: Joseph McMurrough
; CS 271 / Project ID : Assignment3_Integer Accumulator            Date: 10/28/15
; Description:  Signed integer accumlation.  User enters a sequence of negative numbers (the amount allowed is capped by...)
; (cont... the variable MAXNUMS) .  The user then enters a  number out of range to continue to next step.
;  The nummbers are added and averaged, with the results being displayed to the user.  
INCLUDE Irvine32.inc




.data

;--------Input user name
nameArr	BYTE	25 DUP(0)

;-----------Number Variables
addstore	SWORD  0
aver		SBYTE  ?
accum	BYTE		1
UPPER	EQU	-1
LOWER	EQU	-100
MAXNUMS	EQU	20

;-----------Statements

	;Extra Credit
ec_1	BYTE		"**EC Number 1 Attempt! (Number lines during user input)" , 0

	;INTRO STATEMENTS
intro_1	BYTE		"Hi, my name is Joseph McMurrough. Welcome to Assignment #3!" , 0
q_name	BYTE		"What is your name (max 25 char): ",0
ntmy		BYTE		"Nice to meet you ",0 
enj		BYTE		", I hope you enjoy this program!",0
	
	;INSTRUCTIONS
inst_1	BYTE		"Please enter some number's in the range of -100 to -1 inclusive.",0
inst_2	BYTE		"When you are finished, please enter a number out of range to generate results. ",0
	
	;LOOP DISPLAY FOR NUMBER OF ENTRY
loop_inst1	BYTE	"Value #",0
loop_col		BYTE ":",0

	;ERROR MESSAGES
err_novalid	BYTE		"Dang, you didn't enter in any valid numbers" , 0

	;RESULT STATEMENTS
result_st1	BYTE		"GREAT SUCCESS...",0
result_st2	BYTE		"You entered " ,0
result_st3	BYTE		" valid numbers."
result_st4	BYTE		"The sum of your entries is: " ,0
result_st5	BYTE		"The rounded average of your entries is: ",0

	;GOODBYTE STATEMENTS, OH I MEAN GOODBYE STATEMENTS
outro	BYTE		"I enjoyed having you around, " , 0
hand	BYTE		"Have a nice day!" , 0


.code
main PROC

;----EXTRA CREDIT DISPLAY---------
mov		edx, OFFSET ec_1
	call		WriteString
	call		CrLf

;----INTRODUCTION---------
	;----The following code will output an intro message to the screen
	mov		edx, OFFSET intro_1
	call		WriteString
	call		CrLf
	call		CrLf

;-----USER INSTRUCTIONS FOR NAME INPUT-------
	;----Now we will read in string/name from the user
	mov		edx, OFFSET q_name
	call		WriteString;

	;-----getUserData ----->>name
	mov		edx, OFFSET  nameArr
	mov		ecx, SIZEOF	nameArr
	call		ReadString
	call		CrLf

	;-----greet and display user name 
	mov		edx, OFFSET	ntmy
	call		WriteString
	
	mov		edx, OFFSET	nameArr
	call		WriteString

	mov		edx, OFFSET	enj
	call		WriteString
	call		CrLf



;------GetUserDataNumbers + Validation----------

	;----The following code will output instructions to the screen
	mov		edx, OFFSET	inst_1
	call		WriteString
	call		CrLf
	mov		edx, OFFSET	inst_2
	call		WriteString
	call		CrLf








	getnums:  ;Loop set to come back to if number is is not in range [-100, -1]

	

	;-----Read in user input number, store in numb


	; *************beg EXTRA CREDIT PORTION for #1****************
	mov eax, 0		;Clears eax for display (clears info from ah and upper eax)
	mov		edx, OFFSET	loop_inst1      ;Displays "Value #"
	call		WriteString

	mov		al, accum     ;Writes the current entry number
	call		WriteDec

	mov		edx, OFFSET	loop_col      ;Displays ":"
	call		WriteString
	; *************end EXTRA CREDIT PORTION for #1****************


	
	call	     ReadInt
	call		CrLf

	; Compares entry to -100, if lower, will exit loop
	cmp  ax, LOWER		;Checks if entry is less than -100
	JL	getout

	 ;Compares entry to -1, if higher, will exit loop
	cmp  ax, UPPER		;Checks if entry is greater than -1
	JG	getout
	
	add		ax, addstore
	mov		addstore, ax


	cmp accum, MAXNUMS    ;MAXNUMS can be set to determine the max amount of numbers that can be accumulated
	JE	maxreached		;Originally set to 20
	inc accum		;Inc accum (keeps track of how many)
	loop getnums

	getout:
	cmp accum, 1		;Checks for entry using accum > 1
	JG hasentry
	
	;-----There are no valid entries
	mov		edx, OFFSET	err_novalid      ;Displays message if no valid entries were entered 
	call		WriteString
	call		CrLf

	jmp endloop
	
	
	
	
	hasentry:		;There exists at least one valid entry
	dec accum		; We dec by one to account for exit number.
	maxreached:		; Jump to maxnums if max reached, aviod decrement of accum due to no out number to subtract
;------Calculate Average--------

	mov		edx, 0
	mov		ax, addstore		   ;No sign extend necessary b/c addstore is SWORD
	mov		bl, accum
	idiv		bl
	mov		aver,al		;  quotient in al stored in variable aver SBYTE

;-------Display results---------
	mov		edx, OFFSET	result_st1      ; Message "Great success" 
	call		WriteString
	call		CrLf

	mov		edx, OFFSET	result_st2      ; Message "You entered" 
	call		WriteString

	mov		eax, 0
	mov		al, accum			 ;"How many number entered"
	call		WriteDec

	mov		edx, OFFSET	result_st3      ; Message "You entered" 
	call		WriteString
	call		CrLf
	call		CrLf

	mov		edx, OFFSET	result_st4      ; Message "The Sum is" 
	call		WriteString

	movsx	eax, addstore			 ;  The sum displayed
	call		WriteInt
	call		CrLf

	mov		edx, OFFSET	result_st5      ; Message "The average is" 
	call		WriteString

	movsx	eax, aver			 ;  The average displayed, sign extended 
	call		WriteInt
	call		CrLf


	endloop:

;----------FAREWELL----------
	call CrLf

	mov		edx, OFFSET	outro
	call		WriteString
	mov		edx, OFFSET	nameArr
	call		WriteString
	call		CrLf
	mov		edx, OFFSET	hand
	call		WriteString
	call		CrLf
	call		CrLf





	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main










