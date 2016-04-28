Assignment2_Fibonacci      (Asign_2.asm)

; Author: Joseph McMurrough
; CS 271 / Project ID : Assignment2_Fibonacci               Date: 10/19/15
; Description:  Example

INCLUDE Irvine32.inc




.data

; Input user name
nameArr	BYTE	26 DUP(0)

;Number Variables
numb		DWORD	?
inc_test		DWORD	0
first		DWORD	1
second		DWORD	1
five			DWORD	5
UPPER	DWORD	47
LOWER	DWORD	0

;Statements
intro_1	BYTE		"Hi, my name is Joseph McMurrough. Welcome to Assignment #2--Fibonacci!" , 0
q_name	BYTE		"What is your name (max 25 char): ",0
ntmy		BYTE		"Nice to meet you ",0 
enj		BYTE		", I hope you enjoy this program!",0

inst_1	BYTE		"I will display a user specified number of Fibonacci numbers.",0
inst_2	BYTE		"Please enter the number of Fibonacci numbers to display [1...46]: ",0

spaces	BYTE		"      ",0

;Error Messages
err_lessThan	BYTE		"Oh no, your entry is less than 1" , 0
err_greater	BYTE		"Oh no, your entry is greater than 46" , 0

;Goodbye Statments
outro	BYTE		"I enjoyed having you around, " , 0
hand	BYTE		"Have a nice day!" , 0


.code
main PROC

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


	inval:  ;Loop set to come back to if number is less than 0 or greater than 46---

	call		CrLf
	mov		edx, OFFSET	inst_2
	call		WriteString

	;-----Read in user input number, store in numb
	call	     ReadInt
	mov		numb,	eax
	call		CrLf

	;-----Validate user input is within range

	;-----Check for greater than 0
					
	cmp		eax, LOWER		;compaing entry to 0
	jg		proceed1
	mov		edx, OFFSET	err_lessThan	;Display error message that input was less than 1
	call		WriteString
	jmp inval

	proceed1:   ;Passed first test (input >0)

	;-----Check for less than than 46
	cmp		eax, UPPER			;compaing entry to 47
	jl		proceed2
	mov		edx, OFFSET	err_greater	;Display error message that input was greater 46
	call		WriteString
	jmp inval

	proceed2:		;Passed second test (now we know input>0 && input<47  ...[1-46])


;-----------------DISPLAY FIBS------------------
	mov	ecx, numb  ;Sets counter to the user input variable numb
	mov	eax, 1	 ;Sets eax to zero, the first number in fib sequence

	;----The begining of loop start_disp
	start_disp:

	;--Will skip to more if first two values have been displayed already
	cmp inc_test, 1	
	jg	more			

	;---Hard coded writes 1 twice
	call	WriteDec
	mov	edx, OFFSET spaces
	call WriteString
	jmp endloop		;jumps to the end because this iteration only working on first two numbers in sequence




	;--Jump to more if first two values have been entered
	more:	

	;--Check for every 5th iteration to do a newline
	mov	eax, inc_test
	mov edx, 0
	div	five
	cmp	edx, 0
	jne	newline

	call CrLf



	newline:		;Jumps over newline if not a factor of 5

	;  Push values up so the newly calc value will be the first variable, and the last calc will be the second.
	;Note we are following the eq for fib    A(x)= A(x-1) + A(x-2)

	mov	eax,second
	add	eax,first
	mov	numb, eax		;Uses numb to for temporary storage
	call	WriteDec
	mov	edx, OFFSET spaces
	call WriteString

	;Moves value in first to second, value in numb to first
	mov	eax, first
	mov	second, eax
	mov  eax, numb
	mov	first, eax

	endloop:
	inc	inc_test		;inc_test used in two parts of loop 1.Display first two numbers.  2. Check if div by 5
	
	loop start_disp	;Goto start

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










