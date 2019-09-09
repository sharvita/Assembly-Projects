TITLE inclassMENU.asm
; Author:  Diane Yoha
; Date:  7 March 2018
; Description: 

;// Your assignment is to implement all remaining functionality and error checking as required. 
;// Remember this code allows the user to keep entering strings until


Include Irvine32.inc 

;//Macros
ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>
Newline  textequ <0ah, 0dh>
maxLength = 51d

.data

UserOption byte 0h
key byte maxLength dup(0)	;		// declares the array to be used throughout the program.
message byte 0
errormessage byte 'You have entered an invalid option. Please try again.', Newline, 0h


.code
main PROC

call ClearRegisters ;// clears registers

mov edx, offset key 
mov ecx, maxLength
call enterKey

startHere:

mov esi, OFFSET UserOption
call displayMenu


opt1:
cmp useroption, 1
jne opt2
mov edx, offset key
mov ecx, maxLength
call enterKey
jmp starthere

opt2:
cmp useroption, 2
jne opt3
mov ecx, maxLength
mov edx,offset message
call enterMessage
mov esi, offset message
call upperCase
mov esi,offset message
call removeSymbols
call encrypt
jmp starthere

opt3:
cmp useroption, 3
jne opt4
mov edx, offset message
mov esi, offset key
call decrypt
jmp starthere


opt4:
cmp useroption, 4
jne opt5
mov edx, offset message
mov esi, offset key 
call decrypt
jmp starthere

opt5:
cmp useroption, 5
jne opt6
mov edx, offset message
call print
jmp starthere

opt6:
cmp useroption, 6
jne oops ;// invalid entry
jmp quitit


oops:
push edx
mov edx, offset errormessage
call writestring
call waitmsg
pop edx
jmp starthere

quitit:
exit
main ENDP

;// Procedures
;// ===============================================================
DisplayMenu Proc
;// Description:  Displays the Main Menu to the screen and gets user input
;// Receives:  Offset of UserOption variable in ebx
;// Returns:  User input will be saved to UserOption variable

.data
MainMenu byte 'MAIN MENU', 0Ah, 0Dh,
'==========', 0Ah, 0Dh,
'1. Enter a key:', 0Ah, 0Dh,
'2. Enter a phrase: ',0Ah, 0Dh,
'3. Encrypt: ',0Ah, 0Dh,
'4. Decrypt: ',0Ah, 0Dh,
'5. Display the phrase: ',0Ah, 0Dh,
'6. Exit: ',0Ah, 0Dh, 0Ah, 0Dh,
'Please enter a number between 1 and 6 -->', 0h
.code
push edx  				 ;// preserves current value of edx
call clrscr
mov edx, offset MainMenu ;// required by WriteString
call WriteString
call readhex			 ;// get user input
mov byte ptr [esi], al	 ;// save user input to UserOption
pop edx    				 ;// restores current value of edx

ret
DisplayMenu ENDP



ClearRegisters Proc
;// Description:  Clears the registers EAX, EBX, ECX, EDX, ESI, EDI
;// Requires:  Nothing
;// Returns:  Nothing, but all registers will be cleared.

cleareax
clearebx
clearecx
clearedx
clearesi
clearedi

ret
ClearRegisters ENDP
;// ---------------------------------------------------------------
enterKey proc 
;// Description: Gets string from user.
;// Receives:  Address of string
;// Returns:   String is modified and length of entered string is in saved in theStringLen


.data
option1prompt byte 'Please enter a key: ', 0h

.code

jumpBack:
call clrscr
push edx       ;//saving the address of the string pass in.
mov edx, offset option1prompt
call writestring
pop edx

call readString			;prints to screen 
cmp al,0
je invalidKey
ja endLoop

invalidKey:
jmp jumpBack			;if invalid, tehn go back to loop 

endLoop :
call clrscr
ret
enterKey endp



enterMessage proc
;// Description:  takes in a message from user 
;// Receives:  address of string in edx
;// Returns:  noting
.data
opt2prompt1 byte "Enter message :", newline , 0

.code

messageLoop :
call clrscr
push edx
mov edx, offset opt2prompt1
call writestring		;//prints prompt
pop edx
call readString			;takes in a string 
cmp al,0
je invalidMessage
ja endLoop2

invalidMessage:
jmp messageLoop			;if invalid, go back to message ,loop

endLoop2 :
call crlf
ret
enterMessage endp


encrypt proc
;// Description:  this encrypts all the phrases..
;// Receives: address of string in edx
;// Returns:  nothing
.data

.code
push esi

encryptLoop:
cmp byte ptr[edx],0			;compares whatever is edx to 0
je endLoop3					;if its equal to 0
cmp byte ptr[esi],0
je changeKey				;changes the key if user enters new one 
ja keepGoing				

changeKey:
pop esi						;pop esi so that new key
push esi					;creates new space for new key

keepGoing:
movzx eax, byte ptr[esi]		;if key is not changed then 
mov ebx,1Ah						;encryption
div bl							;division bl
add byte ptr[edx],ah
cmp byte ptr[edx],ah
jbe letter
movzx eax, byte ptr[edx]
sub al,'Z'
add al,'@'
mov byte ptr[edx], al

letter:
inc esi
inc edx
jmp encryptLoop

endLoop3:
pop esi
ret
encrypt endp


;This function allows the user to decrypt the message
decrypt proc
.data

.code 
push esi
decryptLoop:
cmp byte ptr[edx],0			;compares if its empty
ja endLoop4					
cmp byte ptr[esi],0
je changeK					;changing key 
ja decrypting

changeK:
pop esi
push esi

decrypting:				;decrypting the messae
movzx eax, byte ptr[esi]
mov ebx,1Ah				
div bl
sub byte ptr[edx],ah
cmp byte ptr[edx],41h
jae capL
movzx eax, byte ptr[edx]
movzx ebx, byte ptr[edx]
mov ebx, 41h
sub bl, al				;instead of adding you subtract to decrypt
neg bl
add bl, 5Bh
mov byte ptr[edx],bl

capL:
inc esi
inc edx
jmp decrypting

endLoop4:
pop esi
ret
decrypt endp

;this function prints the decrypted and encrypted key or message
print proc
;// Description:  Displays the string.
;// Receives: address of string in edx
;// Returns:  nothing


.data
   option5prompt byte 'The string is : ', 0h
.code
mov esi,1					
printLoop:
cmp byte ptr[edx],0
je endLoop5
cmp esi,5
jbe printL
mov al,' '
call writeChar
mov esi,1

printL:
mov al, byte ptr[edx]
call writeChar
inc edx
inc esi
jmp printLoop

endLoop5:
call crlf
call waitMsg
ret
print endp

;Tjos function changes it to upperCase
upperCase proc
.data
.code
upperCaseLoop:
cmp byte ptr[esi],0
je endLoop6
cmp byte ptr[esi],'a'
je upper
ja continue
jb stop

continue:
cmp byte ptr[esi],'z'
ja stop
upper:
sub byte ptr[esi],20h
stop:
inc esi
jmp upperCaseLoop

endLoop6:
ret
upperCase endp

;thsi removes the symbols in the 
removeSymbols proc
.data 
promptSym byte maxLength dup(0)

.code 
mov edx, offset promptSym
push edx
push esi

letterLoop:
cmp byte ptr[esi],0
je done
cmp byte ptr[esi],41h
jb continue1
cmp byte ptr[esi],5Ah
jbe saveLetter
cmp byte ptr[esi],61h
jb continue1
cmp byte ptr[esi],7Ah
ja continue1

saveLetter:
mov al, byte ptr[esi]
mov byte ptr[edx], al
inc edx

continue1:
inc esi
jmp letterLoop

done:
mov ecx, maxLength
pop esi
pop edx
push esi

clearMessage:
mov byte ptr[esi],0
inc esi
loop clearMessage

pop esi
push esi
push edx

newPrompt:
cmp byte ptr[edx],0
je endMes
mov al, byte ptr[edx]
mov byte ptr[esi],al
inc esi
inc edx
jmp newPrompt

endMes:
pop edx
pop esi
mov ecx, maxLength

clearM:
mov byte ptr[edx],0
inc edx
loop clearM

ret
removeSymbols endp

END main

