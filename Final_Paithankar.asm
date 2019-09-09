;Final Game :TIC TAC TOE
;Sharvita Paithankar
;********************************************************************

;This game asks the user different option and allows them to enter 
;numbers from 1-9 to choose whcih box they want to put a x or o in. 
;This games also allows the user to see the statistics of the games
;played before. 

;********************************************************************
INCLUDE Irvine32.inc    

.data    
;variables 
promptMenu BYTE "*********************Tic Tac Toe game**********************",0dh, 0ah
BYTE "Choose and option: ", 0dh, 0ah
BYTE "1. Player vs Player", 0dh, 0ah
BYTE "2. Computer vs Player", 0dh, 0ah
BYTE "3. Computer vs Computer", 0dh, 0ah
BYTE "4. Statistics", 0dh, 0ah
BYTE "5. Exit",0dh, 0ah
BYTE "Enter a number: ", 0

promptError BYTE "Not a valid entry. Try again",0
promptStatistics BYTE 'Following are the stats: ',0
promptPvP BYTE '1) Player vs Player: ', 0
promptCvC BYTE '2) Computer vs Computer: ', 0
promptCvP BYTE '3) Computer vs Player: ', 0
prompttied BYTE '4) Games tied: ', 0
winnerX DWORD ?
winnerO DWORD ?
PvP BYTE 0			;counters for games played and statistic 
CvC BYTE 0
CvP BYTE 0
tiedGames BYTE 0
winnerArrayX DWORD 0,0,0
winnerArrayO DWORD 0,0,0
;2 dimensional array
tictacArray DWORD 9,9,9                     
Rowsize = ($ - tictacArray)
          DWORD 9,9,9
          DWORD 9,9,9

.code
main PROC
                                         
;Prototypes                     
PlayerTurn PROTO, tictacH: PTR DWORD, player : DWORD
ComputerTurn PROTO, tictacC: PTR DWORD, turn : DWORD
XWon PROTO, tictacX: PTR DWORD, winnerXX: PTR DWORD, winnerArrayXX: PTR DWORD
OWon PROTO, tictacO: PTR DWORD, winnerOO: PTR DWORD, winnerArrayOO: PTR DWORD
GameCompleted PROTO , tictacWinningBoard : PTR DWORD , xWinsGame: PTR DWORD , oWinsGame: PTR DWORD, winnerArrayXXX: PTR DWORD, winnerArrayOOO: PTR DWORD
printBoard PROTO, tictacBoard: PTR DWORD

call Randomize;                           ;seeds the random..doing it in main solves a lot of issues 
;clearing the registers
    mov EAX, 0           
    mov EBX, 0
    mov ECX, 0
    mov EDX, 0                                
    mov EDI, 0
    mov EBP, 0                             

    Menu:   
	;call Clrscr
    ;reset varibales before starting new game 
    mov ECX, 9                            
    mov esi, OFFSET tictacArray
    mov EAX, 9
    mov winnerX, 0
    mov winnerO, 0

	;clearing out array using esi 
    ClearOutLoop:
        mov [esi], EAX
        add esi, TYPE DWORD
    loop ClearOutLoop

    mov esi, OFFSET tictacArray

   
;ask user for prompt 
    mov EDX, OFFSET promptMenu 
    call WriteString
    call Crlf
    mov al,0
    or al,1  
	;ask user for number 
    call ReadInt 
	 

	;Option from user selected at this point
	cmp EAX,1
	jz opt1
    cmp EAX,2
    jz opt2                                
    cmp EAX,3
    jz opt3
	cmp EAX,4
	jz opt4
    cmp EAX,5
    jz opt5                              
    jnz Error                              

	;if it's an invalid message 
    Error:                                 
    mov EDX, OFFSET promptError
    call WriteString

    call Crlf
    call WaitMsg
	;Go bck to menu
    jmp Menu                              

    EndProgram: ;exit
    call Crlf
    call WaitMsg 
    call Crlf
    invoke ExitProcess,0                     ;exits program


	opt1:
	inc PvP 
	invoke PlayerTurn , ADDR tictacArray,1				;players take turn until there is a possibilty that there is a winner
    invoke printBoard , ADDR tictacArray

    invoke PlayerTurn , ADDR tictacArray,0 
    invoke printBoard , ADDR tictacArray

    invoke PlayerTurn , ADDR tictacArray,1  
    invoke printBoard , ADDR tictacArray

    invoke PlayerTurn , ADDR tictacArray,0 
    invoke printBoard , ADDR tictacArray

    invoke PlayerTurn , ADDR tictacArray,1
    invoke printBoard , ADDR tictacArray

    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX

    mov EAX, 1
    cmp EAX, winnerX
    jz ENDOFGAME

    invoke PlayerTurn , ADDR tictacArray,0  
    invoke printBoard , ADDR tictacArray
    invoke OWon , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO

    mov EAX, 1
    cmp EAX, winnerO
    jz ENDOFGAME

    invoke PlayerTurn , ADDR tictacArray,1   
    invoke printBoard , ADDR tictacArray
    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX

    mov EAX, 1
    cmp EAX, winnerX
    jz ENDOFGAME

    invoke PlayerTurn , ADDR tictacArray,0   
    invoke printBoard , ADDR tictacArray

    invoke OWon , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO
    mov EAX, 1
    cmp EAX, winnerO

    jz ENDOFGAME
    invoke PlayerTurn , ADDR tictacArray,1   
    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
    jmp ENDOFGAME 

     

	;if Computer v Player 
    opt2:  
   	inc CvP

    call Crlf
    invoke PlayerTurn , ADDR tictacArray,1 
    invoke printBoard , ADDR tictacArray

    invoke ComputerTurn , ADDR tictacArray,0  
    invoke printBoard , ADDR tictacArray

    invoke PlayerTurn , ADDR tictacArray,1  
    invoke printBoard , ADDR tictacArray

    invoke ComputerTurn , ADDR tictacArray,0  
    invoke printBoard , ADDR tictacArray

    invoke PlayerTurn , ADDR tictacArray,1
    invoke printBoard , ADDR tictacArray

    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
    mov EAX, 1
    cmp EAX, winnerX
    jz ENDOFGAME

    invoke ComputerTurn , ADDR tictacArray,0   
    invoke printBoard , ADDR tictacArray

    invoke OWon , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO			;check is anyone is winning 
    mov EAX, 1
    cmp EAX, winnerO
    jz ENDOFGAME

    invoke PlayerTurn , ADDR tictacArray,1  
    invoke printBoard , ADDR tictacArray
    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
    mov EAX, 1
    cmp EAX, winnerX
    jz ENDOFGAME

    invoke ComputerTurn , ADDR tictacArray,0   
    invoke printBoard , ADDR tictacArray
    invoke OWon , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO
    mov EAX, 1
    cmp EAX, winnerO
    jz ENDOFGAME

    invoke PlayerTurn , ADDR tictacArray,1   
    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX					;check is x won
    jmp ENDOFGAME  

																		;Computer vs computer 
    opt3:   
	inc CvC																;number of games played 
    call Crlf

    invoke ComputerTurn , ADDR tictacArray,1							;players take turn 
    invoke printBoard , ADDR tictacArray

    invoke ComputerTurn , ADDR tictacArray,0  
    invoke printBoard , ADDR tictacArray

    invoke ComputerTurn , ADDR tictacArray,1  
    invoke printBoard , ADDR tictacArray

    invoke ComputerTurn , ADDR tictacArray,0  
    invoke printBoard , ADDR tictacArray

    invoke ComputerTurn , ADDR tictacArray,1  
    invoke printBoard , ADDR tictacArray

    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
        mov EAX, 1
        cmp EAX, winnerX
        jz ENDOFGAME

    invoke ComputerTurn , ADDR tictacArray,0				;check if there is a winner 
    invoke printBoard , ADDR tictacArray

    invoke OWon , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO
    mov EAX, 1
    cmp EAX, winnerO					;if there is a winner then end game 
    jz ENDOFGAME

    invoke ComputerTurn , ADDR tictacArray,1   
    invoke printBoard , ADDR tictacArray

    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX
    mov EAX, 1
    cmp EAX, winnerX
     jz ENDOFGAME

    invoke ComputerTurn , ADDR tictacArray,0   
    invoke printBoard , ADDR tictacArray

    invoke OWon , ADDR tictacArray, ADDR winnerO, ADDR winnerArrayO
    mov EAX, 1
    cmp EAX, winnerO
    jz ENDOFGAME

    invoke ComputerTurn , ADDR tictacArray,1     ;computer's turn 
    invoke XWon , ADDR tictacArray, ADDR winnerX, ADDR winnerArrayX

    ENDOFGAME:
    invoke GameCompleted , ADDR tictacArray , winnerX , winnerO , ADDR winnerArrayX , ADDR winnerArrayO
    call Waitmsg
    jmp Menu                                 ;jumps back to menu



	opt4:										;print the statistics
	push EDX
	mov EDX, OFFSET promptStatistics
    call WriteString
	call crlf
	mov EDX, OFFSET promptPvP						;print player vs player 
    call WriteString
    mov AL, PvP
    call WriteDec
	call crlf
	mov EDX, OFFSET promptCvC
    call WriteString
    mov AL, CvC
    call WriteDec
	call crlf
	mov EDX, OFFSET promptCvP
    call WriteString
    mov AL, CvP
    call WriteDec
	call crlf
	mov EDX, OFFSET prompttied
    call WriteString
    mov AL, tiedGames
    call WriteDec
	call Crlf
	pop EDX
	jmp Menu 
    opt5:
    jz EndProgram

invoke ExitProcess,0               ;shouldn't be needed, but just incase to stop program if something falls through
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PlayerTurn PROC, tictacH: PTR DWORD, player: DWORD
;this function takes in the array and which player is playing and allows them 
;to make a move on the board
;*****************************************************************************

.data
promptPlayerStart BYTE "Make a move.Enter a number between 1 to 9: ",0
promptOccupied BYTE "Sorry,it's already taken! Try again...",0
promptNotValidNumber BYTE "Invalid number.",0

.code
call Crlf
call Crlf

PlayerChoice:
mov esi, tictacH
mov EDX, OFFSET promptPlayerStart       ;prompts user that it is their turn
call WriteString
call ReadDec
mov ECX, 9					;should be 1 - 9! if doesn't jump then falls through to error message
cmp ECX, EAX
jz ValidRandNum
mov ECX, 8
cmp ECX, EAX
jz ValidRandNum
mov ECX, 7
cmp ECX, EAX
jz ValidRandNum
mov ECX, 6
cmp ECX, EAX
jz ValidRandNum
mov ECX, 5
cmp ECX, EAX
jz ValidRandNum
mov ECX, 4
cmp ECX, EAX
jz ValidRandNum
mov ECX, 3
cmp ECX, EAX
jz ValidRandNum
mov ECX, 2
cmp ECX, EAX
jz ValidRandNum
mov ECX, 1
cmp ECX, EAX
jz ValidRandNum
call Crlf
mov EDX, OFFSET promptNotValidNumber
call WriteString
call Crlf
call Crlf
jmp PlayerChoice

ValidRandNum:
mov ECX, EAX
cmp ECX, 1                              ;is their choice = 1?
jz FirstBox                              ;if yes jump to FirstBox, no need to increment through array
dec ECX
ISVALIDLOOP:
    add esi, TYPE DWORD
    loop ISVALIDLOOP

FirstBox:       
mov EBX, 9
cmp [esi], EBX                          ;is array position = 9?
jz OKAYCHOICE                           ;if yes, position was empty (dash '-'), okay to now fill
mov EDX, OFFSET promptOccupied          ;if no, inform user to try again
call Crlf
call WriteString
call Crlf
call Crlf
jmp PlayerChoice                    ;...& loops back around

OKAYCHOICE:
mov EBX, player                              ;moves 'x' into position
mov [esi], EBX                          ;1 = X, 0 = O, and 9 = empty

RET                                     ;returns next memory location saved after call of procedure
PlayerTurn ENDP                                    

;**********************************************************************
ComputerTurn PROC , tictacC : PTR DWORD, turn : DWORD
;this function takes in the array and what the computer is going to 
;put in the array[an x or an o] 
;This function chooses the 5th square if available and if not then 
;it chooses a random number between 1-9 to fill in the sqaure and 
;complete the move 
;**********************************************************************
.data
promptComputerStart BYTE "Move is being made...",0

.code
call Crlf
call Crlf
mov EDX, OFFSET promptComputerStart               ;informs user computer is choosing
call WriteString
mov esi, tictacC                                  ;ESI = start of tictacC array

												;the following chooses the middle box if it
add esi, TYPE DWORD
add esi, TYPE DWORD
add esi, TYPE DWORD
add esi, TYPE DWORD 
jmp CHOICE2

RANDOMCOMPCHOICE:
mov esi, tictacC
mov EAX, 9
call RandomRange                                  ;RandomRange returns back 0 - 8
add EAX, 1                                        ;now range is 1 - 9 (correct range)
mov ECX, EAX
cmp ECX, 1                                        ;was computer O's choice = 1?
jz CHOICE2                                        ;if yes jump to CHOICE2, no need to increment through array                    
dec ECX
ISVALIDLOOP:
    add esi, TYPE DWORD
    loop ISVALIDLOOP
CHOICE2:
mov EBX, 9
cmp [esi], EBX                                    ;1 = X, 0 = O, and 9 = empty
jz VALIDCHOICEMADE
jmp RANDOMCOMPCHOICE

VALIDCHOICEMADE:
mov EBX, turn
mov [esi], EBX                                    ;1 = X, 0 = O, and 9 = empty


push EBP												;the following delays everything by 1 second 
mov EBP, 10000
mov EAX, 10000
delay2:
dec bp                   ;counts down and does a lot of operations to "wait" two seconds
nop
jnz delay2
dec EAX
cmp EAX,0    
jnz delay2
pop EBP

RET                                                          
ComputerTurn ENDP   


;**********************************************************************************************
GameCompleted PROC , tictacWinningBoard : PTR DWORD , xWinsGame : PTR DWORD , oWinsGame : PTR DWORD, winnerArrayXXX : PTR DWORD, winnerArrayOOO : PTR DWORD
;This procedure allows the user to view the end board and Prints who won the game 
;This function highlights the winning row or column 
;It also prints if it was a tie or not 
;**********************************************************************************************              

.data
xAxis BYTE 2
yAxis BYTE 0
promptSIdes BYTE "    |   |    ",0
PrintCounterSides DWORD 0
promptXWinner BYTE "    X is the champion!",0
promptOWinner BYTE "    O is the champion!",0
promptNoWinner BYTE "Game is tied",0
printNumSides DWORD 1
promptCongrats BYTE "         You won!!!!      ",0


.code
mov printNumSides, 1              ;reset variables
mov xAxis, 2
mov yAxis, 0
mov PrintCounterSides, 0
mov esi, tictacWinningBoard
call Clrscr
mov ECX, 3
PRINTSIDES:									
    mov EDX, OFFSET promptSIdes
    call WriteString
    call Crlf
    loop PRINTSIDES

mov tictacWinningBoard, esi             ;ESI = beginning of board array
DOITAGAINW:
mov ECX, 3

PRINTSIDELOOP:
push EDX                                 
mov dh, yAxis                               ;dh = yCoord
mov dl, xAxis                               ;dl = xCoord
call Gotoxy                                  ;moves cursor to (x,y) on screen
    pop EDX     

    ;change colors
    mov EAX, white + (black * 16)      
    call SetTextColor

    mov EBX, 9
    cmp [esi], EBX
    jz PrintDASHW          ;to Print -
    mov EBX, 1
    cmp [esi], EBX
    jz PrintxW             ;to Print x
    mov EBX, 0
    cmp [esi], EBX
    jz PrintoW             ;to Print o

    PrintxW:
        mov EAX, 0
        cmp EAX, xWinsGame                      ;is xWinsGame = 0?
        push ECX
        jz PrintJUSTX                         ;if yes, x did not win. 
        mov EAX, WinnerArrayXXX                 ;if no, x won the game
        mov EBX, printNumSides                 ;EBX = printNumSides
        mov ECX, 3
        LOOPCHECKXWINNER:
            cmp [EAX], EBX                     ;if printNumSides is same as what is found in winner Array then Print
            jz PrintCOLORX
            add EAX, TYPE DWORD
        loop LOOPCHECKXWINNER
        jmp PrintJUSTX                        ;if none found to be same, no color added
        PrintCOLORX:
        mov EAX, white + (blue * 16)           ;
        call SetTextColor                       ;irvine library function
        PrintJUSTX:
        pop ECX
        mov EAX, 'x'
        call WriteChar
        jmp TOLOOPNEXTCHARW

    PrintoW:
        mov EAX, 0
        push ECX
        cmp EAX, oWinsGame                      ;is oWinsGame = 0?
        jz PrintJUSTO                         ;if yes, x did not win. 
        mov EAX, WinnerArrayOOO                 ;if no, x won the game
        mov EBX, printNumSides                 ;EBX = printNumSides
        mov ECX, 3
        LOOPCHECKOWINNER:
            cmp [EAX], EBX
            jz PrintCOLORO
            add EAX, TYPE DWORD
        loop LOOPCHECKOWINNER
        jmp PrintJUSTO                        ;if none found to be same, no color added
        PrintCOLORO:
        mov EAX, black + (yellow * 16)           ;black letters w/ white background
        call SetTextColor                       ;irvine library function
        PrintJUSTO:
        pop ECX
        mov EAX, 'o'
        call WriteChar
        jmp TOLOOPNEXTCHARW

    PrintDASHW:                                ;dashes never have color
        mov EAX, '-'
        call WriteChar

    TOLOOPNEXTCHARW:
        add xAxis, 4                          ;inc x coordinate
        add esi, TYPE DWORD
        add printNumSides, 1
        mov EAX, white + (black * 16)           ;set color back to white lettering w/ black background
        call SetTextColor

    mov EBX, 1                                   ;since loop would be too far, must dec ECX by hand
    cmp ECX, EBX
    jz DONEPRINTINGXXX     
    sub ECX, 1
    jmp PRINTSIDELOOP                             ;loops 3 times (for each row)

    DONEPRINTINGXXX:  

mov xAxis, 2                                    ;reset x coordinate back to first column
add yAxis, 1                                    ;inc to next row
add PrintCounterSides, 1
mov EDX, 2
cmp PrintCounterSides, EDX                       ; if PrintCounterSides hasn' reached 3, need to do agian
jbe DOITAGAINW  


;ypu won message
call Crlf
call Crlf
mov EAX,oWinsGame   
cmp xWinsGame, EAX                      ;if both XXX and OOO are the same, no one won
jnz SOMEPLAYERWON
mov EDX, OFFSET promptNoWinner
call WriteString
inc tiedGames
jmp GAMEOVER                            ;CATS GAME

SOMEPLAYERWON:
mov EDX, OFFSET promptCongrats          
call WriteString
call Crlf

mov EAX, 1
cmp xWinsGame, EAX
jnz TRYOWINNER
mov EDX, OFFSET promptXWinner
call WriteString                        ;X WINNER
jmp GAMEOVER

TRYOWINNER:                             ; if none of the above, o wins!
mov EDX, OFFSET promptOWinner
call WriteString                        ;O WINNER

GAMEOVER:
call Crlf
call Crlf
RET                                                          ;returns next memory location saved after call of procedure
GameCompleted ENDP 
                                       

;*******************************************************************************
XWon PROC , tictacX : PTR DWORD, winnerXX: PTR DWORD, winnerArrayXX: PTR DWORD
;This procedure checks if there are any x's in a row in the array and then fills 
;the winning array with 
;*******************************************************************************           

.data
xTime DWORD 0

.code
mov esi, tictacX    ;ESI = beginning of tictacX array
mov EAX, 0
mov xTime, 0
;for the rows
mov ECX, 3

CHECKFORROWS:
    push ECX                      ;ESP = ECX
    mov EAX, 0
    mov ECX, 3
    LOOPFORROWS:
        mov EBX, [esi]
        add EAX, EBX
        add esi, TYPE DWORD
        loop LOOPFORROWS

    pop ECX                       ;ECX value returned

;to set the winnerArrayXX values
    mov EDX, 0
    cmp EDX, xTime
    jz XFIRSTTIME
    mov EDX, 1
    cmp EDX, xTime
    jz XSECONDTIME
    mov EDX, 2
    cmp EDX, xTime
    jz XTHIRDTIME

    XFIRSTTIME:                   ;first row 1, 2, 3 set
    mov EDI, winnerArrayXX
    mov EDX, 1                    ;EDX = 1
    mov [EDI], EDX                ;winnerArrayXX[0] = EDX
    add EDI, TYPE DWORD
    mov EDX, 2
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 3
    mov [EDI], EDX
    jmp ENDFOTIMESTHROUGHX

    XSECONDTIME:                  ;second row 4, 5, 6 set
    mov EDI, winnerArrayXX
    mov EDX, 4
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 5
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 6
    mov [EDI], EDX
    jmp ENDFOTIMESTHROUGHX

    XTHIRDTIME:                   ;third row 7, 8, 9 set
    mov EDI, winnerArrayXX
    mov EDX, 7
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 8
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 9
    mov [EDI], EDX

    ENDFOTIMESTHROUGHX:

add xTime, 1 

;to check if we have a winner
mov EDX, 3          ;since 1+1+1 = 3 check if sum = 3
cmp EAX, EDX
jz XWINNER

mov EBX,1
cmp ECX, EBX        ;since loop got to big, must dec ECX and jump instead
jz DONEX
sub ECX, 1
jmp CHECKFORROWS
     
DONEX:

;for the columnns
mov ECX, 3
mov xTime, 0                          ;reset xTime = 0
mov esi, tictacX                             ;reset esi to beginning of array
CHECKFORCOLS:
    push ECX
    mov EAX, 0
    mov ECX, 3
    LOOPFORCOLS:
        mov EBX, [esi]
        add EAX, EBX
        add esi, TYPE DWORD
        add esi, TYPE DWORD
        add esi, TYPE DWORD           
        loop LOOPFORCOLS
    pop ECX

;to set the winnerArrayXX values
    mov EDX, 0
    cmp EDX, xTime
    jz XXFIRSTTIME
    mov EDX, 1
    cmp EDX, xTime
    jz XXSECONDTIME
    mov EDX, 2
    cmp EDX, xTime
    jz XXTHIRDTIME

    XXFIRSTTIME:                  ;first column 1, 4, 7
    mov EDI, winnerArrayXX
    mov EDX, 1
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 4
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 7
    mov [EDI], EDX
    jmp xTimeLOOP

    XXSECONDTIME:                 ;second column 2, 5, 8
    mov EDI, winnerArrayXX
    mov EDX, 2
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 5
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 8
    mov [EDI], EDX
    jmp xTimeLOOP

    XXTHIRDTIME:                  ;third column 3, 6, 9
    mov EDI, winnerArrayXX
    mov EDX, 3
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 6
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 9
    mov [EDI], EDX

    xTimeLOOP:

    mov EDX, 3
    cmp EAX, EDX
    jz XWINNER
 
    mov EDX, 1
    cmp EDX, xTime         ;has the first column been checked? 
    jz ADD2COLUMNSXX              ;if yes, need to increment by 1 for second loop
    mov esi, tictacX
    add esi, TYPE DWORD
    jmp ColumnsDone
    ADD2COLUMNSXX:
    mov esi, tictacX              ;if anything else we add 2 for checking the third column
    add esi, TYPE DWORD
    add esi, TYPE DWORD

    ColumnsDone:
    mov EBX, 1
    cmp ECX, EBX                  ;is ECX downto 1?
    jz DONEXX                     ;if yes, don't loop through anymore
    sub ECX, 1     
    add xTime, 1
    jmp CHECKFORCOLS

    DONEXX:

;for the diagonals
    mov esi, tictacX              ;esi = beginning of tictacX array
    mov EBX, 0
    mov EAX, [esi]                ;adding position 1 of board, no need to increment
    add EBX, EAX
    mov ECX, 2
    LOOPDIAGONALX:
        add esi, TYPE DWORD           ;upper left to lower right diagonal ( 1, 5, 9)
        add esi, TYPE DWORD
        add esi, TYPE DWORD
        add esi, TYPE DWORD           ;needs to increment 4 
        mov EAX, [esi]
        add EBX, EAX
    loop LOOPDIAGONALX

    mov EDI, winnerArrayXX             ;assignment of the winnerArrayXX values. 1, 5, 9
    mov EDX, 1
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 5
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 9
    mov [EDI], EDX

    mov EDX, 3                         ;finding winner? If sum/EBX = 3 then yes
    cmp EBX, EDX
    jz XWINNER

    mov EAX,0
    mov EBX, 0
    mov esi, tictacX                   ;reset variables
    add esi, TYPE DWORD
    add esi, TYPE DWORD                ;hard-coded, needs to start at position 3 of board
    mov EAX, [esi]
    add EBX, EAX

    mov ECX, 2
    SECONDDIAGLOOP:
        add esi, TYPE DWORD           ;upper right to lower left diagonal ( 3,5,7)
        add esi, TYPE DWORD
        mov EAX, [esi]
        add EBX, EAX
    loop SECONDDIAGLOOP

    mov EDI, winnerArrayXX             ;assignment of the winnerArrayXX values. 1, 5, 9
    mov EDX, 3
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 5
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 7
    mov [EDI], EDX

    mov EDX, 3     ;finding winner? If sum/EBX = 3 then yes
    cmp EBX, EDX
    jz XWINNER

jmp XENDING         ;if no winner is found, must skip over XWINNER

;found a winner
XWINNER:
    mov EDX, winnerXX
    mov EAX, 1
    mov [EDX], EAX                ;set dereferenced address to 1

XENDING:

RET                                                          ;returns next memory location saved after call of procedure
XWon ENDP                                         

;****************************************************************************
OWon PROC , tictacO : PTR DWORD, winnerOO: PTR DWORD, winnerArrayOO: PTR DWORD
;This procedure checks if there are 3 O's in a row or a column and puts them 
;in the winning array 
;****************************************************************************    

.data
timesO DWORD 0

.code
mov esi, tictacO    ;ESI = beginning of tictacO array
mov EAX, 0
mov timesO, 0

mov ECX, 3

CheckRowO:
    push ECX                      ;ESP = ECX
    mov EAX, 0
    mov ECX, 3
    LOOPFORROWSO:
        mov EBX, [esi]
        add EAX, EBX
        add esi, TYPE DWORD
        loop LOOPFORROWSO

    pop ECX                       ;ECX value returned


    mov EDX, 0
    cmp EDX, timesO
    jz OFIRSTTIME
    mov EDX, 1
    cmp EDX, timesO
    jz OSECONDTIME
    mov EDX, 2
    cmp EDX, timesO
    jz OTHIRDTIME

    OFIRSTTIME:                   ;first row 1, 2, 3 set
    mov EDI, winnerArrayOO
    mov EDX, 1                    ;EDX = 1
    mov [EDI], EDX                ;winnerArrayOO[0] = EDX
    add EDI, TYPE DWORD
    mov EDX, 2
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 3
    mov [EDI], EDX
    jmp ENDFOTIMESTHROUGHO

    OSECONDTIME:                  ;second row 4, 5, 6 set
    mov EDI, winnerArrayOO
    mov EDX, 4
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 5
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 6
    mov [EDI], EDX
    jmp ENDFOTIMESTHROUGHO

    OTHIRDTIME:                   ;third row 7, 8, 9 set
    mov EDI, winnerArrayOO
    mov EDX, 7
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 8
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 9
    mov [EDI], EDX

    ENDFOTIMESTHROUGHO:

add timesO, 1 


mov EDX, 0          ;since 0+0+0 = 0 check if sum = 0
cmp EAX, EDX
jz OWINNER

mov EBX,1
cmp ECX, EBX        ;since loop got to big, must dec ECX and jump instead
jz DONEO
sub ECX, 1
jmp CheckRowO
     
DONEO:

mov ECX, 3
mov timesO, 0                          ;reset timesO = 0
mov esi, tictacO                             ;reset esi to beginning of array
CHECKFORCOLSO:
    push ECX
    mov EAX, 0
    mov ECX, 3
    LOOPFORCOLSO:
        mov EBX, [esi]
        add EAX, EBX
        add esi, TYPE DWORD
        add esi, TYPE DWORD
        add esi, TYPE DWORD           
        loop LOOPFORCOLSO
    pop ECX

;putting values in winner array 
    mov EDX, 0
    cmp EDX, timesO
    jz OOFIRSTTIME
    mov EDX, 1
    cmp EDX, timesO
    jz OOSECONDTIME
    mov EDX, 2
    cmp EDX, timesO
    jz OOTHIRDTIME

    OOFIRSTTIME:                  ;first column 1, 4, 7
    mov EDI, winnerArrayOO
    mov EDX, 1
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 4
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 7
    mov [EDI], EDX
    jmp ENDFOTIMESTHROUGHOO

    OOSECONDTIME:                 ;second column 2, 5, 8
    mov EDI, winnerArrayOO
    mov EDX, 2
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 5
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 8
    mov [EDI], EDX
    jmp ENDFOTIMESTHROUGHOO

    OOTHIRDTIME:                  ;third column 3, 6, 9
    mov EDI, winnerArrayOO
    mov EDX, 3
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 6
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 9
    mov [EDI], EDX

    ENDFOTIMESTHROUGHOO:
;if anyone win ?
    mov EDX, 0
    cmp EAX, EDX
    jz OWINNER
 
    mov EDX, 1
    cmp EDX, timesO         ;has the first column been checked? 
    jz ADD2COLUMNSOO              ;if yes, need to increment by 1 for second loop
    mov esi, tictacO
    add esi, TYPE DWORD
    jmp DONEADDINGCOLUMNSOO
    ADD2COLUMNSOO:
    mov esi, tictacO              ;if anything else we add 2 for checking the third column
    add esi, TYPE DWORD
    add esi, TYPE DWORD

    DONEADDINGCOLUMNSOO:
    mov EBX, 1
    cmp ECX, EBX                  ;is ECX downto 1?
    jz DONEOO                     ;if yes, don't loop through anymore
    sub ECX, 1     
    add timesO, 1
    jmp CHECKFORCOLSO

    DONEOO:

    mov esi, tictacO              ;esi = beginning of tictacO array
    mov EBX, 0
    mov EAX, [esi]                ;adding position 1 of board, no need to increment
    add EBX, EAX
    mov ECX, 2
    LOOPDIAGONALO:
        add esi, TYPE DWORD           ;upper left to lower right diagonal ( 1, 5, 9)
        add esi, TYPE DWORD
        add esi, TYPE DWORD
        add esi, TYPE DWORD           ;needs to increment 4 
        mov EAX, [esi]
        add EBX, EAX
    loop LOOPDIAGONALO

    mov EDI, winnerArrayOO             ;assignment of the winnerArrayOO values. 1, 5, 9
    mov EDX, 1
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 5
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 9
    mov [EDI], EDX

    mov EDX, 0                         ;finding winner? If sum/EBX = 0 then yes
    cmp EBX, EDX
    jz OWINNER

    mov EAX,0
    mov EBX, 0
    mov esi, tictacO                   ;reset variables
    add esi, TYPE DWORD
    add esi, TYPE DWORD                ;hard-coded, needs to start at position 3 of board
    mov EAX, [esi]
    add EBX, EAX

    mov ECX, 2
    LOOPDIAGONAL2O:
        add esi, TYPE DWORD           ;upper right to lower left diagonal ( 3,5,7)
        add esi, TYPE DWORD
        mov EAX, [esi]
        add EBX, EAX
    loop LOOPDIAGONAL2O

    mov EDI, winnerArrayOO             ;assignment of the winnerArrayOO values. 1, 5, 9
    mov EDX, 3
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 5
    mov [EDI], EDX
    add EDI, TYPE DWORD
    mov EDX, 7
    mov [EDI], EDX

    mov EDX, 0     ;finding winner? If sum/EBX = 0 then yes
    cmp EBX, EDX
    jz OWINNER

jmp OENDING         ;if no winner is found, must skip over OWINNER

OWINNER:
    mov EDX, winnerOO
    mov EAX, 1
    mov [EDX], EAX                ;set dereferenced address to 1

OENDING:

RET                              ;returns next memory location saved after call of procedure
OWon ENDP                                         





;***********************************************************************
printBoard PROC , tictacBoard : PTR DWORD
;this procedure goes though the 2 d array and prints it in the screen
;*************************************************************************

.data
xCoord BYTE 2
yCoord BYTE 0
promptS BYTE "    |   |    ",0
PrintOutCounter DWORD 0

.code
mov xCoord, 2                                
mov yCoord, 0                                 
mov PrintOutCounter, 0                     
mov esi, tictacBoard
call Clrscr
mov ECX, 3

PrintSides:
    mov EDX, OFFSET promptS
    call WriteString
    call Crlf
    loop PrintSides

;print characters 
mov tictacBoard, esi
cmp tictacBoard, 1
DOITAGAIN:
mov ECX, 3

LOOPPrint:
    push EDX          
    mov dh, yCoord                               ;dh = yCoord
    mov dl, xCoord                               ;dl = xCoord
    call Gotoxy                                  ;moves cursor to (x,y) on screen
    pop EDX     

    mov EBX, 9
    cmp [esi], EBX
    jz PrintDASH      ;array = 9 -> Print dash
    mov EBX, 1
    cmp [esi], EBX
    jz Printx         ;array = 1 -> Print x
    mov EBX, 0
    cmp [esi], EBX
    jz Printo         ;array = 0 -> Print o

    Printx:
        mov EAX, 'x'
        call WriteChar
        jmp TOLOOPNEXTCHAR

    Printo:
        mov EAX, 'o'
        call WriteChar
        jmp TOLOOPNEXTCHAR

    PrintDASH:
        mov EAX, '-'
        call WriteChar

    TOLOOPNEXTCHAR:
        add xCoord, 4
        add esi, TYPE DWORD

loop LOOPPrint                   ;only loops 3 times to fill one row    

mov xCoord, 2                      ;reset xCoord = 2
add yCoord, 1                      ;inc to next line
add PrintOutCounter, 1
mov EDX, 2 
cmp PrintOutCounter, EDX         ;have we Printed out 2 rows?
jbe DOITAGAIN                      ;if yes we need 1 more row

RET                                ;returns next memory location saved after call of procedure
printBoard ENDP                                    
end main