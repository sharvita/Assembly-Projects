

INCLUDE Irvine32.inc
ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>
Newline  textequ <0ah, 0dh>

BoardDisplay PROTO
anyWin PROTO
anyWinO PROTO
PvC PROTO, arr DWORD

main PROC

exit
main ENDP

INCLUDE Irvine32.inc

BoardDisplay PROTO



.data
arr BYTE 9 DUP("-")
arrayOffset DWORD ?
.code
main PROC
mov arrayOffset, OFFSET arr
call mainMenu
call waitmsg
	exit
main ENDP

mainMenu PROC
.data
Prompt1 BYTE "Welcome to the Tic Tac Toe game!!!!",0dh, 0ah
		BYTE "Please choose one of the option below: ", 0dh, 0ah
		BYTE "1. Player vs Computer", 0dh, 0ah
		BYTE "2. Computer vs Computer", 0dh, 0ah
		BYTE "3.Player vs Player",0
Prompt2 BYTE "Your Choice: ", 0
PromptChoose BYTE "Where do you want to move? (1,2,3,4,5,6,7,8,9)", 0
PromptTie BYTE "Game tied!", 0
userInput DWORD ?
randVal DWORD ?
player BYTE ?
computer BYTE ?
rowIndex DWORD ?
columnIndex DWORD ?
charNow DWORD ?
totalGame BYTE 0

.code
mov EDX, OFFSET Prompt1
call WriteString
call crlf
mov EDX, OFFSET Prompt2
call WriteString
call ReadInt
push EAX
INVOKE BoardDisplay
pop EAX
mov userInput, EAX
cmp userInput, 1
je pc

cc:											;computer vs compter
cmp userInput, 2
jne mainexit

mainext:
ret
mainMenu ENDP

PvC PROC, arr : DWORD
.data 

.code 

ret
PvC ENDP 

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


END main