TITLE pa3Part1.asm

;Name :Sharvita Paithankar
;Description ->
;Part 1:  	
;⦁	Compute fib(n) for n = 2, 3, …, 10 using an array, of the appropriate size and type
;Date: 9/23/2018


include Irvine32.inc

	 
.data
	arr DWORD 123,251,12

.code
main proc

	mov EAX,0				;clear register

	mov EAX,[arr]			;move 123 to eax
	XCHG EAX,[arr+4]		;swap 123 with 251
	XCHG [arr+8],EAX		;swap 251 eith 12
	mov arr,EAX				;mov EAX 12 to arr
	

	call DumpRegs
	

exit 
main endp							   ;end main
end main