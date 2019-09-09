
;Sharvita Paithankar

Include Irvine32.inc

clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>
clearESI TEXTEQU <mov ESI, 0>
clearEDI TEXTEQU <mov EDI, 0>
arrayMax equ 1000

.data
n dword 1000
primeArr WORD arrayMax dup(0)
exitPrompt byte 'Press q to quit or press space', 0h

.code 
main proc

createArr PROTO, arrayPtr : ptr word, arrLength :DWORD
printMenu PROTO
findPrimes PROTO, arrayPtr : ptr word, arrLength : DWORD
printPrimes PROTO, arrayPtr : ptr word, arrLength : DWORD

invoke createArr, ADDR primeArr, n
invoke findPrimes, ADDR primeArr, n
invoke printPrimes, ADDR primeArr, n
menuloop :
call crlf
invoke printMenu
mov n, eax
invoke createArr, ADDR primeArr,n
invoke findPrimes, ADDR primeArr,n
invoke printPrimes, ADDR primeArr,n
mov edx, offset exitPrompt
call writeString
call readChar
cmp al, 'q'
je quit
cmp al, 'Q'
je quit
jmp menuloop

quit:
main endp
;****************************************************************
createArr proc, arrayPtr : ptr WORD, arrLength : DWORD
;this function creates and array and fills it with prime numbers 
;****************************************************************
.code 
push esi
mov ecx,0
mov esi, arrayPtr
createArrloop:
mov eax, ecx
add ax,2
mov[esi+2*ecx],ax
inc ecx
cmp eax, arrLength			; this is to make sure we do not exceed the 1000 limit 
jb createArrloop
pop esi
ret 
createArr endp
;****************************************************************
printPrimes proc, arrayPtr : ptr WORD, arrLength :DWORD
;this function prints all the prime numbers and diplays the numebr 
;primes that tehre are in the array 
;****************************************************************
.data 
numberOfPrimes byte 0
prompt1 byte 'There are ', 0h
prompt2 byte, 'primes between 2 and ', 0h
row byte 2
col byte 0
done byte 0

.code 
push esi
dec arrLength
mov esi, arrayPtr
mov ecx, arrLength
mov ebx, 0

L1 :						;go through the prime array and things that are not prime are equal to -1
mov ax,[esi+2*ebx]
cmp ax,-1
jne isprime
inc ebx
jmp end2

;checks if it is prime and increments the counter to count primes
isprime:
inc numberOfPrimes
inc ebx

end2:
loop L1
mov eax,0
call clrscr

;this to to display the number of primes 
;the following uses registers to print prompts using writeString
mov edx, offset prompt1
call writeString 
mov al, numberOfPrimes
call writeDec
mov edx, offset prompt2
call writeString
inc arrLength 
mov eax, arrLength
call writeDec
dec arrLength
call crlf


mov ebx, 0

;the following loop goes through the goes through array and prints all primes
displayprimenums:
mov ax,[esi+2*ebx]
cmp ax, -1
je dontdisplay

;the row and col is to make it look better when printing it 
mov dh, row
mov dl, col
call gotoxy
call writeDec
inc done 
cmp done,5 
je newline
add col, 5
inc ebx
jmp check 
newline:
call crlf
sub col, 25
inc row
mov done, 0
mov dh,row
mov dl, col
call gotoxy
add col, 5
inc ebx
jmp check

dontdisplay:
inc ebx

;check is it in less than 1000
check :
cmp ebx, arrLength
jb displayprimenums

mov col,0
mov row,2
mov done,0
mov numberOfPrimes,0
pop esi
call crlf
call waitmsg

ret 
printPrimes endp
;******************************************************
findPrimes proc, arrayPtr : ptr word, arrLength : DWORD 
;this function checks and stores all the prime numbers between 
;2 qnd 100. Then it return the pointer of the array
;******************************************************

.code 
push esi
mov esi, arrayPtr
mov ecx,0

L1:
mov ebx, ecx
inc ebx
cmp word ptr[esi+2*ecx],-1    ;if it is not a prime we set it to -1
jne L2
continue1:
inc ecx
cmp ecx, arrLength 
jb L1
jmp end1

L2:
cmp WORD ptr[esi+2*ebx],-1
jne L3
continue2:
inc ebx
cmp ebx, arrLength
jb L2
jmp continue1

;the following checks to see if the number is correct 
L3:
mov edx, 0 
mov eax,0
mov ax,[esi+2*ebx]
div WORD ptr [esi+2*ecx]
cmp edx,0
je remove 
jmp continue2

remove :
mov WORD ptr[esi+2*ebx],-1
jmp continue2

end1:
pop esi 
ret 
findPrimes endp

;*********************************************************
printMenu proc 
;this function prints and asks the user which value they want
;to choose between 2 and 1000
;************************************************************
.data 
prompt byte 'Enter a number from 2 to 1000 : ',0h
.code 

;this loop checks if number is valid 
L1:
mov edx, offset prompt 
call writeString 
call readDec
cmp eax, 2
jb L1
cmp eax,1000
ja L1
pop edx
ret
printMenu endp



end main 
