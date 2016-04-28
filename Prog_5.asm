
;Assignment5_Sorting Random Numbers      (Prog_5.asm)

; Author: Joseph McMurrough


; CS 271 / Project ID : Assignment5_Sorting Random Numbers           Date: 11/15/15
; Description:  Without using global varaibles, this program passes in varaibles by value and reference using the stack frame.  
; This program will generate a user defined amount of random numbers [10-200],all within the range of [100 -999].  The program
;will then sort these numbers and display results before and after sorting.  

;-----------------------------General Procedure legend------------------------------
; 1.  meet_greet (calling proc: main)  -> Introduction, rules
; 2. get_that_Data (calling proc: main) ->Get user input, call validate to validate, loop if error
;	2a. validate (calling proc: get_that_Data) ->validate user input within range
; 3. composite (calling proc: main) ->main driver/loop for generating composite numbers
;	3a. get_comp (calling proc: composite) ->finds the next composite number
; 4. ttfn (calling proc: main)  -> Outro statement



INCLUDE Irvine32.inc


;Constants
MAX_AMOUNT	equ	200   ;Max set as a constant
MIN_AMOUNT	equ	10   ;Max set as a constant
MAX_RANGE		equ	900	;max range will be MAX_RANGE-1+MIN_RANGE (999)
MIN_RANGE		equ	100

NXT_IDX		equ	4	; Size of DWORD for array increment
.data

;-----------Number Variables
thisMany	DWORD	?
rand_arr		DWORD	MAX_AMOUNT	DUP(?)

;-----------Statements
	;---Extra Credit
ec_1	BYTE		"**EC Number 1 Attempt! (Align the output columns)" , 0
	;---INTRO STATEMENTS
intro_1	BYTE		"Hi, my name is Joseph McMurrough. Welcome to Assignment #5!" , 0
intro_2	BYTE		"       *-_-*-_-*-_-* RaNdOm SoRt *-_-*-_-*-_-*            " , 0
	;---INSTRUCTIONS
inst_1	BYTE		"Here is the deal...  You enter a number from [10-200].",0
inst_2	BYTE		"Go head, enter a number [10-200] :",0
	;---Calc results
generating	BYTE		"{}_{}_{}_{}_{}GENERATING{}_{}_{}_{}_{}RESULTS{}_{}_{}_{}_{}" ,0
	;---ERROR MESSAGES
err_novalid	BYTE		"Dang, you didn't enter in a valid number... try again." , 0
	;---GOODBYTE STATEMENTS, OH I MEAN GOODBYE STATEMENTS
outro	BYTE		"I enjoyed having you around for this anti-prime program!" , 0
hand	BYTE		"Have a nice day!" , 0
	;------Titles
titleUnsort	BYTE		"The Unsorted List:",0
titleSort	     BYTE		"The Sorted List:",0
titleMedian BYTE		"The Median is: ",0

spaces	BYTE	"   ",0




;MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN
;MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN

.code
main PROC

call Randomize
call meet_greet  

push OFFSET thisMany
call get_that_data



push   thisMany
push		OFFSET	rand_arr
call fillArray

push   OFFSET    titleUnsort 
push   thisMany
push		OFFSET	rand_arr
call writeArray

push   thisMany
push		OFFSET	rand_arr
call selectionSort


push   OFFSET    titleSort 
push   thisMany
push		OFFSET	rand_arr
call writeArray

push   OFFSET   titleMedian
push   thisMany
push		OFFSET	rand_arr
call displaymed

	exit	; exit to operating system
main ENDP

;MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN
;MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN_MAIN









;_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES
;_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES_PROCEDURES


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


	ret
	meet_greet	ENDP



;------Gets input from user and stores it in global var.  Calls another function for validation
;-----Receives:  N/A  Gets a max number from global variable.
;---Returns:  Stores value in global variable.
;--Preconditions: N/A
;-Registers Changed: eax,edx,ebp,esp
;

	get_that_Data		PROC
	push ebp
	mov	ebp, esp



	getback:  ; come back to start of input if invalid entry

		;Writes prompt for user to enter number [0-200]
	mov		edx, OFFSET inst_2
	call		WriteString




	;-----Read in user input number, store in numb
	mov		ebx, [ebp+8]
	call	     ReadInt
	mov		[ebx], eax     ;thisMany=eax
	call		CrLf
	


	mov eax, [ebp+8]	
	push  [eax]		;thisMany is passed by value
	call validate	;validate user input, using var isValid 1=T 0=F




	cmp eax, 1		;Compare isValid ==0 after procedure validate is ran
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

	





	pop ebp
		ret 4
	get_that_Data		ENDP




;------Procedure: Validates user input
;-----Receives:  howMany global variable
;---Returns:  Stores validity in global varaible isValid. 0=false, 1=true
;--Preconditions: Numeric user entry stored in variable howMany
;-Registers Changed: ax
;
validate		PROC
	push ebp
	mov ebp,esp



mov	eax, [ebp+8]
cmp  eax,MIN_AMOUNT			;First condition, is eax(howMany) less than 1?
JL	notValid		;jumps to end if howMany < 10

cmp eax, MAX_AMOUNT		;jumps to end if howMany > 200
JG   notValid	

mov eax, 1
jmp elFin

notValid:
mov eax, 0

elFin:

pop ebp
	ret 4
validate		ENDP





;------Procedure: 
;-----Receives:  
;---Returns:  
;--Preconditions: 
;-Registers Changed: 
;
fillArray	PROC
push ebp
mov ebp, esp

mov ecx, [ebp+12]
mov esi, [ebp+8]



createArr:
mov eax,MAX_RANGE	;max range-1 genrate random 899
call RandomRange
add eax, MIN_RANGE

mov [esi], eax
add	esi, NXT_IDX    ;increments by 4 to get next index
loop createArr


pop ebp
	ret 8
	fillArray	ENDP


;------Procedure: writeArray
;-----Receives:  
;---Returns:  
;--Preconditions: 
;-Registers Changed: 
;
writeArray	PROC


push ebp
mov ebp, esp


call CrLf
mov edx, [ebp+16]
call WriteString
call CrLf


mov ecx, [ebp+12]
mov esi, [ebp+8]
mov bl, 1

again:
mov  eax, [esi]
call WriteDec
mov		edx, OFFSET spaces
call		WriteString

cmp bl, 10
jl noSpace
call CrLf
mov bl, 0

noSpace:
add esi, NXT_IDX
inc bl
loop again

 call CrLf


pop ebp
	ret 12
	writeArray	ENDP


;------Procedure: SelectionSort
;-----Receives:  
;---Returns:  
;--Preconditions: 
;-Registers Changed: 
;
SelectionSort	PROC


push ebp
mov ebp, esp

mov ecx, [ebp+12]   ;ECX set up to = howMany elements in array-1
dec ecx
mov esi, [ebp+8]    ;Starting address of array


outloop:    ;OUTER LOOP BOUNDS++++++++++++++++++++++

push ecx            ;prepare for inner loop, set the same ecx
mov ebx, esi         ; move current @of esi into ebx
add ebx, NXT_IDX     ; increment @of ebx by 4, or 1 index
mov eax, [esi]       ;  move the value of esi into eax



innloop:        ;INNER LOOP BOUNDS-------------------------
cmp eax, [ebx]		;compare esi pointer to ebx pointer
jg notLarger				;if esi index > newEntry then skip ahead

mov eax, [ebx]			;else move value in ebx into eax 
mov edx, ebx

notLarger:
add ebx, NXT_IDX
loop innloop     ;INNER LOOP BOUNDS-------------------------



pop ecx

mov ebx, [esi]     ;value of esi into ebx (esi unchanged from inner loop_)
cmp eax, ebx       
JLE noSwap

mov eax, esi

push eax
push edx
call swapEm


noSwap:
add esi, NXT_IDX 
loop outloop       ;OUTER LOOP BOUNDS++++++++++++++++++++++






pop ebp
	ret 8
	SelectionSort	ENDP





;------Procedure: swapEm
;-----Receives:  
;---Returns:  
;--Preconditions: 
;-Registers Changed: 
;
swapEm	PROC
push ebp
mov ebp, esp

mov eax, [ebp+8]
mov edx, [eax]

mov esi, [ebp+8]
mov ebx, [ebp+12]
mov eax, [ebx]
mov [esi], eax

mov esi, [ebp+12]
mov eax, edx
mov [esi], eax


pop ebp 
	ret 8
	swapEm	ENDP





;------Procedure: swapEm
;-----Receives:  
;---Returns:  
;--Preconditions: 
;-Registers Changed: 

 displaymed  PROC

 push ebp
mov ebp, esp


 call CrLf


mov esi, [ebp+8]

 mov eax, [ebp+12]
 mov ebx, 2
 cdq
 div ebx
 

 cmp edx, 0
 JE  evendiv
 mov ecx, NXT_IDX
 mul ecx

 add esi, eax
 mov eax, [esi]
 mov edx, [ebp+16]
 call WriteString
 call WriteDec
 call CrLf

 jmp goto_end

 evendiv:
 dec eax
 mov ecx, NXT_IDX
 mul ecx

 add esi, eax
 mov eax, [esi]

 add esi, NXT_IDX
 add eax, [esi]
  mov ebx, 2
 cdq
 div ebx


  mov edx, [ebp+16]
 call WriteString
 call WriteDec
 call CrLf


 goto_end:

pop ebp
 ret 12
 displaymed ENDP







END main



