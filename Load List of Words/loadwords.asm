.data
	wordCount:	.word 5454 # Should be number of words in file
	filePath:	.asciiz "C:\\Users\\The Parkour Hobo\\Home\\Projects\\6 UTD Courses\\Fall 2018\\CS 3340.501 - Computer Architecture\\Team Project\\Load List of Words\\hardlist.txt"
.text
	# Allocate memory
	lw $a0, wordCount
	sll $a0, $a0, 2 # $a0 now contains # of bytes needed for array
	li $v0, 9 # Allocate memory
	syscall # $v0 now contains the address of the allocated memory
	move $s0, $v0
	
	# Load file
	la $a0, filePath
	li $a1, 0 # Reading flag
	li $a2, 0 # Ignore mode
	li $v0, 13 # Open file
	syscall # $v0 now contains the file descriptor
	
	blt $v0, 0, end # Stop if error (file descriptor negative)
	
	# Read file
	move $a0, $v0 # Put file descriptor in $a0
	move $a1, $s0 # Put location of array into $a1
	lw $a2, wordCount # Amount of words to read
	sll $a2, $a2, 2 # Amount of letters to read
	li $v0, 14 # Read from file
	syscall
	
	# Close file
	li $v0, 16 # Close file
	syscall
	
	end:
	li $v0, 10 # Exit
	syscall