TITLE extra creidt thing

INCLUDE irvine32.inc

.data
Grades WORD 100 DUP(0h)

.code
main proc

call userint
call rawGrade


call WaitMsg

exit
main endp



userint PROC
.data
prompt BYTE "Enter a number between 0 and 100: ", 0
userNumber DWORD ?

.code
mov edx, OFFSET prompt

GREATER :
call WriteString
call ReadInt
mov userNumber, eax

CMP userNumber, 100
JG GREATER

CMP userNumber, 00000000
JNE ISZERO





ISZERO :
mov eax, userNumber
mov ebx, OFFSET Grades
call rawGrade
ret
userint ENDP




rawGrade PROC
.data
randomGradeGenerated DWORD ?
howManyNumbers DWORD ?
;// grades word ?

.code
mov ecx, eax; moves into counter the eax
push eax


; push the number into the array

mov esi, offset Grades


; mov eax, 51; generate a number between 0 and 50
call Randomize
L1:
mov eax, 51; generate a number between 0 and 50

call RandomRange
;// mov randomGradeGenerated, eax
;// add randomGradeGenerated, 50; make the number that is 0 - 50 be 50 - 100


;// mov ebx, randomGradeGenerated
;// inc ebx
add eax, 50
mov[esi], eax
inc esi
inc esi

loop L1


pop eax


ret
rawGrade ENDP

calcGrade proc
;mov ecx, userInput
;mov esi, offset Grades
;cmp 59, [esi]
;inc esi
ret 
calcGrade ENDP




end main