.data
NumberPrompt:	.asciiz	"Please enter a 4 Letter Word: "
AnswerPrompt2:	.asciiz " is "
Welcome1: .asciiz "Cows and Bulls\n"
Menu0: .asciiz "\nPlease choose from one of the following menu options:\n"
Menu1: .asciiz "[1] Start new game\n"
Menu2: .asciiz "[2] Exit Game\n"
MenuPrompt: .asciiz "Please enter your choice [1 or 2]:"
Guess0: .asciiz "Please enter a four-letter Word with no repetitions(Should be Captial):\n"
Guess1: .asciiz "Valid letter are A-Z\n"
UserGuess: .space 64
BaseString: .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
PReturn: .asciiz "\n"
Answer: .space 64
MenuError1: .asciiz "\nThat did not appear to be a valid menu selection.\n"
InputRangeError: .asciiz "\nIt appears the word has not met the requirement.\n"
ScoreOut1: .asciiz "\nYour guess has "
ScoreOut2: .asciiz " has "
ScoreBull: .asciiz " Bull and "
ScoreBulls: .asciiz " Bulls and "
ScoreCow: .asciiz " Cow\n"
ScoreCows: .asciiz " Cows\n"
YouWin: .asciiz "\nYOU WIN!\n"

	.text
main:
	la $t0, Welcome1	#Loading address of prompt to display
	la $t9, PReturn		#Loading this in $t9 for quick carriage return printing
	li $v0, 4		#Syscall value for print string
	add $a0, $t0, $zero	#loading address of $t0 to $a0
	syscall			#Syscall to print spring
	
	
	jal ShowMenu		#Show the menu options
	
GameLoop:
	li $v0, 4
	la $t0, Guess0
	add $a0, $t0, $zero
	syscall
	la $t0, Guess1
	add $a0, $t0, $zero
	syscall
	li $v0, 8
	la $a0, UserGuess
	li $a1, 64
	syscall			#storing string in UserGuess
	la $t0, UserGuess
	li $v0, 4		#print string's "before" look
	add $a0, $t0, $zero
	syscall
	
	#error checking
	la $t0, UserGuess
	
	lb $t1, ($t0)		#setting 0th bit to s1
	lb $t2, 1($t0)		#setting 1st bit to s2
	lb $t3, 2($t0)		#setting 2nd bit to s3
	lb $t4, 3($t0)		#setting 3rd bit to s4
	lb $t5, 4($t0)
	
	
	
	
	# if (A>=65)&&(Z<=90)
FirstCheck:
	addi $t5, $zero, 65
	blt $t1, $t5, UserInputError
	addi $t5, $zero, 90
	ble $t1, $t5, SecondCheck
	j UserInputError
FirstFix:
	sub $t1, $t1, 32
	
SecondCheck:
	addi $t5, $zero, 65
	blt $t2, $t5, UserInputError
	addi $t5, $zero, 90
	ble $t2, $t5, ThirdCheck
	j UserInputError
SecondFix:
	sub $t2, $t2, 32
	
ThirdCheck:

	addi $t5, $zero, 65
	blt $t3, $t5, UserInputError
	addi $t5, $zero, 90
	ble $t3, $t5, FourthCheck
	j UserInputError
ThirdFix:
	sub $t3, $t3, 32
	
FourthCheck:

	addi $t5, $zero, 65
	blt $t4, $t5, UserInputError
	addi $t5, $zero, 90
	ble $t4, $t5, FifthCheck
	j UserInputError
FourthFix:
	sub $t4, $t4, 32
	
FifthCheck:
	addi $t5, $zero, 0
	blt $t5, $t5, UserInputError
	addi $t5, $zero, 0
	ble $t5, $t5, AfterCheck
	j UserInputError

	







AfterCheck:
		
	la $t0, UserGuess
	sb $t1, ($t0)		#setting 0th bit to s1
	sb $t2, 1($t0)		#setting 1st bit to s2
	sb $t3, 2($t0)		#setting 2nd bit to s3
	sb $t4, 3($t0)		#setting 3rd bit to s4
	lb $t5, 4($t0)
	
	li $v0, 4		#print string
	add $a0, $t0, $zero
	syscall
	

FinalScore:
	
	addi $t1, $zero, 1
	li $v0, 4
	la $t0, ScoreOut1
	add $a0, $t0, $zero
	syscall
	li $v0, 1
	add $a0, $s7, $zero
	syscall
	li $v0, 4
	la $t0, ScoreBulls
	j ShowCow1
	

ShowBull:
	la $t0,ScoreBull
	


ShowCow1:
	add $a0, $t0, $zero
	syscall
	li $v0, 1
	add $a0, $s6, $zero
	syscall
	li $v0, 4
	beq $t1, $s6, ShowCow
	la $t0, ScoreCows
	j ShowScore2

ShowCow:
	la $t0, ScoreCow
ShowScore2:
	add $a0, $t0, $zero
	syscall
	add $t1, $zero, 4
	beq $s7, $t1, GameWon
	j GameLoop
	#Not necessary with the menu system, but leaving this here for legacy just in case in order to ensure the program stops.
	li $v0, 10		#exits the program
	syscall
	
GameWon:
	li $v0, 4
	la $t0, YouWin
	add $a0, $t0, $zero
	syscall
	j ShowMenu
	
UserInputError:
	li $v0, 4
	la $t0, InputRangeError
	add $a0, $t0, $zero
	syscall
	j GameLoop



ShowMenu:
	li $v0, 4
	
	la $t0, Menu0
	add $a0, $t0, $zero
	syscall
	
	la $t0, Menu1
	add $a0, $t0, $zero
	syscall
	
	la $t0, Menu2
	add $a0, $t0, $zero
	syscall
	
	la $t0, MenuPrompt
	add $a0, $t0, $zero
	syscall
	li $v0, 8		#Loading the input as a string to avoid problems
	la $a0, UserGuess
	li $a1, 64
	syscall			#storing string in UserGuess
	lb $t1, ($a0)		#just pulling the first byte
	
	addi $t0, $zero, 49	#putting 1 in $t0 for checking
	beq $t1, $t0, GameLoop  #starting the game
	addi $t0,$zero,50	#For exit
	bne $t1, $t0, MenuError	#if they didn't choose any valid menu options print error message and go back to the menu
				
	li $v0, 10		#exits the program
	syscall
	
MenuError:
	li $v0, 4
	la $t0, MenuError1
	add $a0, $t0, $zero
	syscall
	
	j ShowMenu



	

	


	
	

