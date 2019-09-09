
;Sharvita Paithankar

Include Irvine32.inc

clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>
clearESI TEXTEQU <mov ESI, 0>
clearEDI TEXTEQU <mov EDI, 0>
maxlength equ 1000

.data
menuPrompt byte '1. Find GCD',0h,0dh,
'2.Matrix of words', 0ah,0dh,
'3.Exit', 0ah,0dh,0h
errorPrompt byte 'Invalid choice', 0ah,0dh,0h

findGCD PROTO
euclid PROTO, val1 : dword, val2 : dword
fillArray PROTO, GCD : dword
wordMatrix PROTO
findWords PROTO, matrixPtr : ptr byte
clearRegisters PROTO

.code 
main proc

call randomize 
menu:
invoke clearRegisters
mov edx, offset menuPrompt
call WriteString 
call readDec

opt1:
cmp al,1
ja opt2
invoke findGCD
jmp menu 

opt2:
cmp al,2
ja opt3
invoke wordMatrix
jmp menu 

opt3:
cmp al,3
ja oops
jmp quitit

oops:
mov edx, offset errorPrompt 
call WriteString 
call WaitMsg
jmp menu 

quitit:
ret 
main endp

findGCD proc

.data 
aPrompt byte 'Enter a number: ', 0h
bPrompt byte 'Enter another number: ' ,0h
output byte 'The GCD and GCD Prime of the two numbers you entered? ' , 0h,0dh,0h
goAgain byte 'Do you want to enter other numbers? (Y/N) ', 0ah, 0dh, 0h
aNum DWORD ?
bNum DWORD ?
GDC DWORD ?
userChoice byte ?
space byte '        ' , 0h

.code 

GCDloop :
mov eax, 0 
mov edx, offset aPrompt
call WriteString 
call readDec
mov aNum, eax
mov eax, 0 
mov edx, offset bPrompt 
call WriteString 
mov bNum, eax

mov edx, offset output
call WriteString 
mov eax, aNum 
call WriteDec
mov edx, offset space 
call WriteString 
mov eax, bNum 
call writeDec
call WriteString 
invoke euclid, aNum, bNum 

mov edx, offset goagain 
call WriteString 
call readChar
cmp al, 'y'
je GCDloop 
cmp al, 'Y'
je GCDloop 
cmp al,'n'
je quitit
cmp al,'N'
je quitit

quitit :
ret 
findGCD endp

euclid proc, val1 :DWORD, val2 :DWORD

.data 
space2 byte '          ', 0h
.code 
mov eax, val1
cmp eax, val2
jb val2greater 
je done 
sub eax, val2
mov val1, eax
invoke euclid, val1, val2
ret 

val2greater:
sub val2, eax
invoke euclid, val1, val2
ret 

done:
call writeDec
mov val1, eax
mov edx, offset space2
call WriteString 
invoke fillArray, val1
call crlf

ret 
euclid endp 


fillArray PROC, GCD : dword

.data 
primeArray WORD maxlength dup(0)
isprime BYTE 'Yes', 0ah, 0dh,0h
nope BYTE 'No', 0ah, 0dh,0h

.code 
push esi 
mov ecx,0
mov esi, offset primeArray
fillArrayloop :
mov eax, ecx
add ax,2
mov[esi+2*ecx], ax
inc ecx
cmp eax, GCD
jb fillArrayloop 
pop esi 
push esi

mov ecx, 0 
mov esi, offset primeArray
push edx

checkPrimeloop:
mov edx,0
mov ax, word PTR GCD

cmp [esi+2*ecx],ax
jae prime
mov bx, word ptr[esi+2*ecx]
div bx
cmp edx, 0 
je notprime 
inc ecx
jmp checkPrimeloop 

prime :
pop esi 
mov edx, offset isPrime 
call WriteString 
jmp theend

notprime:
pop esi 
mov edx, offset nope
call WriteString 

theend:
pop edx
ret 
fillArray endp

wordMatrix proc 
.data 
letterArray byte 5 dup(0)
rowSize = ($ - letterArray)
byte 5 dup(0)
byte 5 dup(0)
byte 5 dup(0)
byte 5 dup(0)
vowelArray byte 'A','E','I', 'O', 'U', 0h 
consonentArray byte 'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z', 0h
matrixIs byte 'The matrix is: ',0ah, 0dh, 0h

.code 
mov esi, offset letterArray
push esi 
mov ecx, 25

fillMatrixloop:
mov eax, 2
call randomRange
cmp al,0
je addVowel 
mov edi, offset consonentArray 
mov eax, 21
call randomRange 
mov bl, byte ptr [edi + eax]
mov byte ptr[esi], bl 
inc esi 
loop fillMatrixloop 

addVowel:
cmp ecx, 0
je doneWithArray
mov edi, offset vowelArray
mov eax,5
call RandomRange 
mov bl, byte ptr[esi+eax]
mov byte ptr[esi], bl 
inc esi 
loop fillMatrixloop 

doneWithArray:
pop esi 
push esi 
mov edx, offset matrixIs
call WriteString 
call crlf 
mov edx,5 
mov ecx, 25

displayLoop:
dec edx
mov al, byte ptr[esi]
call writeChar
mov al, ' '
call WriteChar
inc esi 
cmp edx,0
je refill 
loop displayLoop 

refill :
cmp ecx, 0
je stopLoop 
mov edx, 5 
call crlf 
loop displayLoop 

stopLoop:
pop esi 
invoke findWords, ADDR letterArray 
call crlf

ret 
wordMatrix endp

findWord proc, matrixPtr : ptr byte 
.data
noWords byte 'Words not found ',0h,0dh, 0h 
yesWords byte 'These were found : ' ,0ah,0dh,0h
separate byte', ',0h
vowelCount byte 0 
wordCount byte 0
tempWord byte 5 dup(0), 0h 
rowCount byte 0
rowindex byte 1

.code
mov esi, matrixPtr 
push esi 

begin:
mov vowelCount, 0
mov ebx, 0
mov edi, offset tempWord 
mov ecx, 0 
cmp rowCount, 5
jb checkcolumns 
cmp rowCount, 10
jb continue2 
cmp rowCount, 11
jb continue3 
cmp rowCount, 12
jb continue4
jmp finished 

checkcolumns:
mov al, byte ptr [esi+ebx]
mov byte ptr [edi], al 
add ebx, 5 
inc edi 
inc ecx
cmp ecx,5 
je checkVowels
jmp checkcolumns

checkVowels:
dec edi 
cmp byte ptr[edi], 'A'
je countit 
cmp byte ptr[edi], 'E'
je countit 
cmp byte ptr[edi], 'I'
je countit 
cmp byte ptr[edi], 'O'
je countit 
cmp byte ptr[edi], 'U'
je countit 
loop checkVowels 
jmp checkWord 

countit:
inc vowelCount
cmp ecx, 0
je checkWord 
loop checkVowels 

checkWord:
cmp vowelCount ,2
je isWord 

continue1:
inc esi 
inc rowCount 
jmp begin 

continue2:
pop esi 
push esi 
cmp rowCount,5
je checkrows
mov eax, 5
mul rowindex
mov ebx,eax
inc rowindex

checkRows:
mov al, byte ptr[esi+ebx]
mov byte ptr[edi], al 
inc ebx
inc edi
inc ecx
cmp ecx, 5
je checkVowels
jmp checkRows 

continue3:
pop esi 
push esi 

checkDiagonal:
mov al, byte ptr[esi+ebx]
mov byte ptr[edi], al 
add ebx, 6 
inc edi 
inc ecx
cmp ecx, 5
je checkVowels
jmp checkDiagonal

continue4:
pop esi
push esi 
mov ebx, 4

diag2:
mov al, byte ptr[esi+ebx]
mov byte ptr[edi], al 
add ebx, 4
inc edi 
inc ecx
cmp ecx, 5
je checkVowels
jmp diag2

isWord:
cmp wordCount, 0
ja here 
mov edx, offset yesWords
call WriteString 

here:
inc wordCount 
cmp wordCount,1
jbe printWord
mov edx, offset separate 
call writeString 

printWord:
mov edx, offset tempWord 
ja done
mov edx, offset noWords

finished :
cmp wordCount, 0 
ja done
mov edx, offset noWords

done:
call crlf
mov rowCount, 0 
mov wordCount, 0 
mov rowindex, 1
ret
findWord endp

ClearRegisters proc 

cleareax
clearebx
clearecx
clearedx
clearesi
clearedi

ret
ClearRegisters endp 
end main 