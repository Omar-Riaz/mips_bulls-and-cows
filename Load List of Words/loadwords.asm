.data
	wordCount:	.word 500 # Should be number of words in file - easylist = 500, hardlist = 5454
	word:		.asciiz "    " # Will contain the randomly chosen word
	filePath:	.asciiz "C:\\Users\\The Parkour Hobo\\Home\\Projects\\6 UTD Courses\\Fall 2018\\CS 3340.501 - Computer Architecture\\Team Project\\Load List of Words\\easylist.txt"
.text
	# Allocate memory
	lw $a0, wordCount
	sll $a0, $a0, 3 # $a0 now contains number of bits needed for array
	li $v0, 9 # Allocate memory syscall
	syscall # $v0 now contains the address of the allocated memory
	move $s0, $v0
	
	# Load file
	la $a0, filePath
	li $a1, 0 # Reading flag
	li $a2, 0 # Ignore mode
	li $v0, 13 # Open file syscall
	syscall # $v0 now contains the file descriptor
	
	blt $v0, 0, end # Stop if error (file descriptor negative)
	
	# Read file
	move $a0, $v0 # Put file descriptor in $a0
	move $a1, $s0 # Put location of array into $a1
	lw $a2, wordCount # Amount of words to read
	sll $a2, $a2, 2 # Amount of letters to read
	li $v0, 14 # Read from file syscall
	syscall
	
	# Close file
	li $v0, 16 # Close file syscall
	syscall
	
	# Get a random number from 0 to (wordCount - 1)
	lw $a1, wordCount
	li $v0, 42 # Random int range syscall
	syscall
	sll $a0, $a0, 2 # Multiply by 4 (can now be used as array offset)
	
	move $t0, $s0 # $t0 now contains the start of the word array
	addu $t0, $t0, $a0 # Add the random offset
	lw $t1, ($t0) # Put the randomly chosen word in $t1
	sw $t1, word # Can't call printString on a register - move it back to memory on the "word" label
	
	# At this point, the label "word" contains a random word from the chosen list
	# This should probably be where the bulls & cows game starts, if this isn't made into a function
	
	la $a0, word
	li $v0, 4 # printString	syscall
	syscall
	
	end:
	li $v0, 10 # Clean exit syscall
	syscall
