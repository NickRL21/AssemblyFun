*-----------------------------------------------------------
* Title      : Recursive Fibonacci
* Written by : Nick Lewis | github@nickrl21
* Date       : 10/30/2019
* Description: A program to calculate the n-th Fibonacci
* number recursively from user input. Written in Motorola
* 68000 assembly for the EASY68k simulator: easy68k.com
*-----------------------------------------------------------
* WARNING: entering large numbers for n is VERY SLOW
* entering 25 creates over 240,000 recursive calls
*-----------------------------------------------------------
		
        ORG    $1000		
start:  
        LEA     intro_msg,A1    * print intro message
        JSR     print_str
        
loop    LEA     prompt,A1   * prompt user for input
        JSR     print_str
 
        MOVEQ.L #0,D1       * clear contents of D1
        
        JSR     read_num    
        CMPI    #0,D1       * compare user input to 0
        BLT     stop        * stop simulation if negative
        
        MOVE.L  D1,D5   * copy n into input register for subroutine
        JSR     fib     * calculate Fibonacci number
        
        LEA     calls_msg,A1   * print total calls label
        JSR     print_str   
        MOVE.L  D4,D1       * move call count to D1 for printing
        JSR     print_num
        JSR     print_newline
        
        
        LEA     result_msg,A1  * print result label
        JSR     print_str   
        MOVE.L  D6,D1   * copy result into D1 for printing
        JSR     print_num     
        JSR     print_newline  
        
        
        BRA     loop    * return to loop so another number can be entered             
		
		
* Fibonacci subroutine
* place input (n) into D5, result is returned in D6
* counts total calls to fib in D4 including initial non-recursive call
fib:    MOVEQ.L #0,D6   * clear result register
        MOVEQ.L #0,D4   * clear call counter
        
_fib    ADDI.L  #1,D4    * increment call counter
        MOVEM   D5,-(SP) * record state of n
        CMPI    #1,D5    * check base case
        BLE     base_case   
        SUBI    #1,D5    * call fib n - 1
        JSR     _fib     
        SUBI    #1,D5    * call fib n - 2
        JSR     _fib
        BRA     return   * branch to return   
        
base_case:
        ADD     D5,D6       * add n to result
        
return  MOVEM   (SP)+,D5    * restore previous value of n 
        RTS
        
        
stop    MOVE.B	#9,D0
		TRAP	#15 	* stop simulation
	

* prints null terminated string at A1
print_str:
        MOVEM   D0,-(SP)    * save D0's state to stack
        MOVE.B  #14,D0      * task to print string without CR LF
        TRAP    #15
        MOVEM   (SP)+,D0    * restore D0's state
        RTS                

* print decimal from D1.L
print_num:
        MOVEM   D0, -(SP)   * save D0's state to stack
        MOVE.B  #3,D0       * task to display decimal in D1.L
        TRAP    #15 
        MOVEM   (SP)+,D0    * restore D0's stat    
        RTS
        
print_newline:
        LEA     newline,A1  * load newline
        JSR     print_str
        RTS 
        

* reads decimal number from keyboard into D1.L
read_num:
        MOVEM   D0,-(SP)    * save D0's state to stack
        MOVE.B  #4,D0       * task to read number from keyboard into D1.L
        TRAP    #15
        MOVEM   (SP)+,D0    * restore D0's state
        RTS          


* equates  
CR      EQU     $0D     * ASCII carriage return
LF      EQU     $0A     * ASCII line feed


* constants
intro_msg:
        DC.B    '<><><><><><><><><><><><><><><><><><><><><>',CR,LF
        DC.B    '<>  Recursive Fibonacci Calculator      <>',CR,LF
        DC.B    '<>  Positive number for n-th fibonacci  <>',CR,LF
        DC.B    '<>  Negative number to stop program     <>',CR,LF
        DC.B    '<><><><><><><><><><><><><><><><><><><><><>',CR,LF,0

prompt  DC.B    'Enter a number:',0

result_msg:
        DC.B    'Result:',0
        
calls_msg:
        DC.B    'Total calls to Fibonacci subroutine:',0

newline DC.B    CR,LF,0
        
		END    START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
