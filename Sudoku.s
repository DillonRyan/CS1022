	AREA	Sudoku, CODE, READONLY
	EXPORT	start

start

	LDR	R10, =gridOne
	LDR	R1, =0	;row pos
 	LDR	R2, =0	;col pos
	LDR	R3, =8	;setting value
	BL sudoku	; branch to sudoku
 	

testStageOne
 	CMP	R3, #9
 	BGT	testStageTwo
	STRB	R3, [R0]
	BL	isValid
	ADD	R3, R3, #1	; put a break point here - only 1 should be valid
	B	testStageOne

testStageTwo
	LDR	R0, =testGridTwo
	LDR	R1, =0
	LDR	R2, =0
	BL	sudoku
	LDR	R0, =testGridTwo
	LDR	R1, =testSolutionTwo
	BL	compareGrids

testStageThree
	LDR	R0, =testGridThree
	LDR	R1, =0
	LDR	R2, =0
	BL	sudoku
	LDR	R0, =testGridThree
	LDR	R1, =testSolutionThree
	BL	compareGrids

stop	B	stop


compareGrids
	STMFD	sp!, {R4-R6, LR}
	LDR	R4, =0
forCompareGrids
	CMP	R4, #(9*9)
	BGE	endForCompareGrids
	LDRB	R5, [R0, R4]
	LDRB	R6, [R1, R4]
	CMP	R5, R6
	BNE	endForCompareGrids
	ADD	R4, R4, #1
	B	forCompareGrids
endForCompareGrids

	CMP	R4,#(9*9)
	BNE	elseCompareGridsFalse
	MOV	R0, #1
	B	endIfCompareGridsTrue
elseCompareGridsFalse
	MOV	R0, #0
endIfCompareGridsTrue
	LDMFD	sp!, {R4-R6, PC}

	
	
	LDR	R0, =gridOne
	LDR R5, =3 ; Saved the row size which equals 9
	BL	setSquare

;stop	B	stop



; getSquare subroutine
getSquare
	STMFD sp!, {R1,R2,R4,R5 , lr}	; Push onto a full descending stack
	MOV R5, #9 ; row size = 9
	MUL R4, R1, R5 ; index = row * row size
	ADD R4, R4, R2 ; index = index + collumn
	LDRB R0, [R10, R4]	;R0 = grid position
	LDMFD sp!, {R1,R2,R4,R5, pc}	; Pop from a full descending stack


; setSquare subroutine
setSquare
	STMFD sp!, {R1,R2,R4,R5 , lr}	;Push onto a full descending stack
	MOV R5, #9 ; row size = 9
	MUL R4, R1, R5 ; index position = row * row size
	ADD R4, R4, R2 ; index = index + collumn
	STRB R3, [R10, R4] ; R3 = grid position
	LDMFD sp!, {R1,R2,R4,R5, pc}	;Pop from a full descending stack


; isValid subroutine
isValid
	STMFD sp!, {R1,R2,R3 , lr}	;Push onto a full descending stack
	BL validRow
	CMP R10, #1	;if(true)
	BEQ invalid
	BL validColumn
	LDMFD sp!, {R1,R2,R3, pc}	;Pop from a full descending stack
invalid
	LDMFD sp!, {R1,R2,R3, pc}	;Pop from a full descending stack
;row check
validRow
	STMFD sp!, {R1-R9 , lr}	;Push onto a full descending stack
	LDR R4, =0		;row=0
	LDR R5, =9		;9 for for loops
	LDR R6, =0		;col=0
row
	MOV R1, R4
	CMP R4, #9
	BHS forRowEnd 	;bhs
	LDR R6, =0		;set column back to 0
column
	MOV R2, R6
	CMP R6, #9
	BEQ forRow
	BL getSquare	;get row column R1, R2
	MOV R7, R0		;move row column into R7
	CMP R7, #0		;if value = 0 
	BEQ forColumn
	MOV R8, R6		;columnCheck = column
	ADD R8, R8, #1	;columnCheck = column + 1
columnCheck
	MOV R2, R8		;move columncheck into R2
	CMP R8, #9		;columnCheck = 9
	BHS forColumn
	BL getSquare	;get row columnCheck R1, R2
	MOV R9, R0		;move row columnCheck into R0
	CMP R7, R9		;Compare row column to row columnCheck
	BEQ endColumn		;if equal return 1 for false
	ADD R8, R8, #1	;else increment columnCheck
	B columnCheck
forColumn
	ADD R6, R6, #1	;column++
	B column
forRow
	ADD R4, R4, #1	;row++
	B row
	
forRowEnd
	LDR R10, =0		;valid = true
	LDMFD sp!, {R1-R9, pc}	;Pop from a full descending stack
endColumn
	LDR R10, =1		;valid = false
	LDMFD sp!, {R1-R9, pc}	;Pop from a full descending stack
;column check
validColumn
	STMFD sp!, {R1-R9 , lr}	;Push onto a full descending stack
	LDR R4, =0		;row=0
	LDR R5, =9		;9 for for loops
	LDR R6, =0		;column=0
row1
	MOV R2, R4
	CMP R4, #9
	BHS forRowEnd1	;bhs
	LDR R6, =0		;set column back to 0
column1
	MOV R1, R6
	CMP R6, #9
	BHS forRow1
	BL getSquare	;get row column R1, R2
	MOV R7, R0		;move row column into R7
	CMP R7, #0		;if value = 0 
	BEQ forColumn1
	MOV R8, R6		;columnCheck = column
	ADD R8, R8, #1	;columnCheck = column + 1
columnCheck1
	MOV R1, R8		;move columncheck into R2
	CMP R8, #9		;columnCheck = 9
	BEQ forColumn1
	BL getSquare	;get row columnCheck R1, R2
	MOV R9, R0		;move row columnCheck into R0
	CMP R7, R9		;Compare row column to row columnCheck
	BEQ endColumn1		;if equal return 1 for false
	ADD R8, R8, #1	;else columnCheck++
	B columnCheck1
forColumn1
	ADD R6, R6, #1	;column++
	B column1
forRow1
	ADD R4, R4, #1	;row++
	B row1
	
forRowEnd1
	LDR R10, =0		;valid = true
	LDMFD sp!, {R1-R9, pc}	;Pop from a full descending stack
endColumn1
	LDR R10, =1		;valid = false
	LDMFD sp!, {R1-R9, pc}	;Pop from a full descending stack



; sudoku subroutine
sudoku
	LDR R4, =0	;boolean result = false
	MOV R5, R2	;int nxtcol
	MOV R6, R1	;int nxtrow = row
	ADD R5, R5, #1	;nxtcol = col+1
	CMP R5, #8		;if (nxtcol > 8)
	BLO firstIf			;{
	LDR R5, =0 		;nxtcol =0
	ADD R6, R6, #1	;nxtrow++
	
firstIf
	BL getSquare	
	CMP R8, #0	;if (getSquare(numL, row, col) != 0
	BEQ firstElse	;{
	BL isValid	;
	CMP R4, #1	;&&isValid(numL))
	BNE firstElse
	
	CMP R1, #8	;if(row == 8
	BNE secondElse	; &&
	CMP R2, #8	;col == 8)
	BNE secondElse	;{	
	LDR R4, =1	;return true (1 = true)
	
secondElse
	BL sudoku	
	
firstElse
for
	LDR R7, =1	;(num = 1
	CMP R7, #9	;num<=9
	BHI endFor	;&&
	CMP R4, #1	;!result i.e R4 == 0)
	BNE endFor	;{
	MOV R3, R7	; value = num
	BL setSquare	;setSquare(numL, row, col, num);
	BL isValid 
	CMP R4, #1		;if(isValid(NumL))
	BNE notValid	
	CMP R1, #8	;if (row == 8
	BNE thirdElse	;&&
	CMP R2, #8	;col==8)
	BNE thirdElse	;{
	LDR R4, =1	;;return true (1 = true)
	
thirdElse	
	BL sudoku	
notValid	
	BL sudoku 
	
endFor
	CMP R4, #0	;if(!result)
	LDR R3, =0	;value = 0
	BL setSquare	;setSquare(numL, row, col, 0)

	AREA	Grids, DATA, READWRITE



gridOne
	DCB	0,0,0,0,0,5,6,7,0
	DCB	0,2,3,0,0,0,0,0,0
	DCB	0,4,0,0,0,0,0,0,0
	DCB	0,0,0,0,0,0,0,0,0
	DCB	0,0,0,0,0,0,0,0,0
	DCB	0,0,0,0,0,0,0,0,0
	DCB	0,0,0,0,0,0,0,0,0
	DCB	8,0,0,0,0,0,0,0,0
	DCB	9,0,0,0,0,0,0,0,0

testGridTwo
	DCB	0,2,7,6,0,0,0,0,3
	DCB	3,0,0,0,0,9,0,0,0
	DCB	8,0,0,0,4,0,5,0,0
	DCB	6,0,0,0,0,2,0,4,0
	DCB	0,0,2,0,0,0,8,0,0
	DCB	0,4,0,7,0,0,0,0,1
	DCB	0,0,3,0,1,0,0,0,7
	DCB	0,0,0,8,0,0,0,0,9
	DCB	9,0,0,0,0,6,2,8,0

testSolutionTwo
	DCB	1,2,7,6,5,8,4,9,3
	DCB	3,5,4,2,7,9,1,6,8
	DCB	8,9,6,3,4,1,5,7,2
	DCB	6,3,9,1,8,2,7,4,5
	DCB	7,1,2,4,9,5,8,3,6
	DCB	5,4,8,7,6,3,9,2,1
	DCB	2,8,3,9,1,4,6,5,7
	DCB	4,6,5,8,2,7,3,1,9
	DCB	9,7,1,5,3,6,2,8,4

testGridThree
	DCB	0,0,0,9,0,0,0,5,0
	DCB	0,0,3,0,4,0,1,0,6
	DCB	0,4,0,2,0,0,0,8,0
	DCB	7,0,8,0,0,0,0,0,0
	DCB	0,3,0,0,0,0,0,6,0
	DCB	0,0,0,0,0,0,5,0,4
	DCB	0,6,0,0,0,1,0,7,0
	DCB	4,0,2,0,5,0,3,0,0
	DCB	0,9,0,0,0,8,0,0,0

testSolutionThree
	DCB	1,2,7,9,8,6,4,5,3
	DCB	9,8,3,5,4,7,1,2,6
	DCB	5,4,6,2,1,3,7,8,9
	DCB	7,5,8,3,6,4,2,9,1
	DCB	2,3,4,1,9,5,8,6,7
	DCB	6,1,9,8,7,2,5,3,4
	DCB	8,6,5,4,3,1,9,7,2
	DCB	4,7,2,6,5,9,3,1,8
	DCB	3,9,1,7,2,8,6,4,5

	END
