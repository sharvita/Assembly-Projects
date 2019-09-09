TITLE pa2.asm

;Name :Sharvita Paithankar
;Description ->
;Part 1:call color
;Description :Write a program that uses procedures (specifically
;the two procedures as described below), so that the input from 
;the user determines how many times to generate random strings.
;Do not generate 1 string and repetitively display it.  
;Each string generated will be unique. Remember, in general,
;a procedure should be fairly simple and accomplish 1 basic step.  	
;Date: 10/08/2018

include Irvine32.inc

.data
     prompt BYTE "Enter a number : " , 0Dh, 0Ah, 0

.code

;This is the main for the program
main proc

	mov ebx,0    ;clear register
	mov edx, OFFSET prompt   
	;calls functions
	call WriteString
	call userEnter
	call Strings

	
	exit 
main endp							   ;end main

;This funtion takes in an unsigned integer input from user 
userEnter PROC 
	call ReadDec
	ret
userEnter endp

Strings proc
.data
	arr BYTE 22 DUP(0) ,0   ;declaring an array of 0's
.code
	;set ecx

	mov esi, OFFSET arr
	mov ecx, eax
	L1 :     ;loop 1 for calculating how many things to generate
		call randNum     ;generates random number 
		push ecx
		push edx
		mov ecx, eax
		mov edx,0
	L2 :                 ;loop 2 is for generating how many ascii numbers need to be made 
		call generateAscii
		mov[esi + edx], al      ;index operand used
		inc edx
	loop L2
	pop edx
	pop ecx

	mov edx, OFFSET arr 

	call color        ;generates colors
	call setTextColor   ;sets color to text

	call WriteString
	call clear
	call crlf

    loop L1
	ret
Strings endp

;this function allows to generate a random number between 5 and 22
randNum proc
	mov eax, 18
	call RandomRange
	add eax,5
	ret
randNum endp

;this function generates ascii characters 
generateAscii proc
	mov eax,26
	call RandomRange 
	add eax,41h
	ret
generateAscii endp
 
 ;this function clears the array so that it doesnt duplicate the random integers
clear proc 
  push edx
  push ecx
  mov edx, 0 
  mov ecx,22
  push ebx
  mov ebx,0
  L1 :
    mov [esi + edx], ebx
	inc edx
  loop L1
  pop ebx
  pop ecx
  pop edx
  ret 
clear endp

;this function allows to generate a random color 
color proc 
   push eax
   mov eax, 14
   call RandomRange
   add eax,1
   pop eax
   ret 
color endp

end main