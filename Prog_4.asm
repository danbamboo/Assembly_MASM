;Assignment4_Anti-Prime      (Prog_4.asm)

; Author: Joseph McMurrough
; CS 271 / Project ID : Assignment4_Anti-Prime          Date: 11/05/15
; Description:  This programed is deigned to display a sequence of composite numbers, the amount of
;which is to be determined by the user.  The cap to the program will be 400.  

;-----------------------------General Procedure legend------------------------------
; 1.  meet_greet (calling proc: main)  -> Introduction, rules
; 2. get_that_Data (calling proc: main) ->Get user input, call validate to validate, loop if error
;	2a. validate (calling proc: get_that_Data) ->validate user input within range
; 3. composite (calling proc: main) ->main driver for generating composite numbers
;	3a. get_comp (calling proc: composite) ->finds the next composite number
; 4. ttfn (calling proc: main)  -> Outro statement



INCLUDE Irvine32.inc


;Constant
MAXIMUS	equ	400   ;Max set as a constant
ALIGN_COL	equ	4     ;Provides spaces inbetween output

.data



;-----------Number Variables
howMany	WORD  ?
isValid	BYTE	 ?
start_at_two	WORD	?
lastcomp		WORD	3
set_half		WORD	?
inc_me		BYTE	0
;-----------Statements

	;Extra Credit
ec_1	BYTE		"**EC Number 1 Attempt! (Number lines during user input)" , 0

	;INTRO STATEMENTS
intro_1	BYTE		"Hi, my name is Joseph McMurrough. Welcome to Assignment #4!" , 0
intro_2	BYTE		"       *-_-*-_-*-_-*THE ANTI PRIME *-_-*-_-*-_-*            " , 0

	
	;INSTRUCTIONS
inst_1	BYTE		"Here is the deal.  You enter a number from [1-400].",0
inst_2	BYTE		"I will display, in order, a sequence of composite numbers exactly the length of your entry.",0
inst_3	BYTE		"Got it? Good! Here we go!",0

inst_4	BYTE		"Please enter number [1-400] :  ",0

	;Calc results
generating	BYTE		"{}_{}_{}_{}_{}GENERATING{}_{}_{}_{}_{}RESULTS{}_{}_{}_{}_{}" ,0


	;ERROR MESSAGES
err_novalid	BYTE		"Dang, you didn't enter in a valid number... try again." , 0



	;GOODBYTE STATEMENTS, OH I MEAN GOODBYE STATEMENTS
outro	BYTE		"I enjoyed having you around for this anti-prime program!" , 0
hand	BYTE		"Have a nice day!" , 0


.code
main PROC

call meet_greet

call get_that_Data

call composite

call ttfn

	exit	; exit to operating system
main ENDP


;------Procedure to display introduction messages and some user instructions
;-----Receives:  Only global "string" variables
;---Returns:  No values, only display messages local to function.
;--Preconditions: N/A
;-Registers Changed: edx
;

meet_greet	PROC

;----INTRODUCTION---------
	
	;----The following code will output an intro message to the screen
	mov		edx, OFFSET intro_1
	call		WriteString
	call		CrLf

	mov		edx, OFFSET intro_2
	call		WriteString
	call		CrLf
	call		CrLf
	
	;----The following code will output instructions for users to read and learn up.
	mov		edx, OFFSET inst_1
	call		WriteString
	call		CrLf

	mov		edx, OFFSET inst_2
	call		WriteString
	call		CrLf

	mov		edx, OFFSET inst_3
	call		WriteString
	call		CrLf
	call		CrLf

	ret
	meet_greet	ENDP


;------Gets input from user and stores it in global var.  Calls another function for validation
;-----Receives:  N/A  Gets a max number from global variable.
;---Returns:  Stores value in global variable.
;--Preconditions: N/A
;-Registers Changed: ax
;

	get_that_Data		PROC


	getback:  ; come back to start of input if invalid entry
	
	;Writes prompt for user to enter number [0-400]
	mov		edx, OFFSET inst_4
	call		WriteString
	call		CrLf
	call		CrLf

	;-----Read in user input number, store in numb
	call	     ReadInt
	mov		howMany,	ax
	call		CrLf



	call validate	;validate user input, using var isValid 1=T 0=F




	cmp isValid, 1		;Compare isValid ==0 after procedure validate is ran
	JE continue_1		;If it is ==1 (is a valid entry), proceed to continue_1
					;else display error message and go to getback:

	;Writes error message 
	mov		edx, OFFSET err_novalid
	call		WriteString
	call		CrLf

	jmp getback 	;Kicks user back to beginning of entry prompty 

	continue_1:	;Continue on 
	call Clrscr 
	mov		edx, OFFSET generating
	call		WriteString
	call		CrLf


	
		ret
	get_that_Data		ENDP




;------Procedure: Validates user input
;-----Receives:  howMany global variable
;---Returns:  Stores validity in global varaible isValid. 0=false, 1=true
;--Preconditions: Numeric user entry stored in variable howMany
;-Registers Changed: ax
;
validate		PROC

mov	isValid,0    ;Initially sets isValid to = 
mov	ax, howMany	;puts howMany in ax
cmp  ax,1			;First condition, is howMany less than 1?
JL	elFin		;jumps to end if howMany < 1

cmp ax, 400		;jumps to end if howMany > 400
JG   elFin	

mov isValid,1       ;If both conditions passed, set isValid to 1

elFin:

	ret
validate		ENDP



;------Procedure: Loops through howMany user entered global variable to display composite numbers
;------            Calls on get_comp to generate next composite number
;-----Receives:  Only global "string" variables
;---Returns:  Output of composite number
;--Preconditions: Numeric user entry stored in variable howMany
;-Registers Changed: ax,dx,cx
;
composite		PROC



mov	cx,howMany  ;set loop to howMany user input 
mov edx, 0
mov	dh,3  ;Y axis

start:


push edx
call get_comp   ;Procedure call to get_comp
pop edx

	cmp		inc_me, 10
	jl		skip_nl	
	inc		dh
	mov		inc_me, 0
skip_nl:
	

	mov		eax, ALIGN_COL
	mov		dl, inc_me
	mul		dl
	mov		dl, al

mov   ax, lastcomp
call Gotoxy
call	WriteDec
	
inc inc_me
loop start




	ret
composite		ENDP




;------Loops through howMany user entered global variable to display composite numbers
;-----Receives:  Only global "string" variables
;---Returns:  Stores validity in global varaible isValid. 0=false, 1=true
;--Preconditions: Numeric user entry stored in variable howMany
;-Registers Changed: ax
;
get_comp		PROC

top:
mov	start_at_two, 2   ;Used in loop to find composite
inc lastcomp    ;Increments the last valid composite number to begin looking for new one
mov ax, lastcomp

xor	edx, edx		;alternate way to clear edx with unsigned 
mov ax, lastcomp
mov	bx, 2
div	bx
mov	set_half, ax
inc set_half

try_again_comp:

mov ax, set_half
cmp ax, start_at_two
je	top					;Not a composite number, jump to top and try next number



xor	edx, edx	   ;mod current number with current value (lastcomp % start_at_two)
mov ax, lastcomp
mov	bx, start_at_two
div	bx

cmp	dx, 0
je	comp_found

inc start_at_two
jmp try_again_comp

	comp_found:
	ret
get_comp		ENDP




ttfn	PROC
call CrLf
	;Writes a goodbye statement
	mov		edx, OFFSET outro
	call		WriteString
	call		CrLf

	;Writes "have a nice day"
	mov		edx, OFFSET hand
	call		WriteString
	call		CrLf



	ret
ttfn		ENDP




END main



