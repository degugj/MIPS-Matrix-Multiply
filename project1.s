# File: project1.s
# Jack DeGuglielmo	
# 10/14/2019
#
	.globl main 			# Store initial values of arrays in memory
	.data
	arrayA:
	.word 7
	.word 16
	.word 23
	.word 40
	.word 11
	.word 39
	.word 37
	.word 10
	.word 2
	.word 18
	arrayPrime: 			# Store zeros in adjacent memory locations for split arrays
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	arrayComposite:
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.text
	lui $sp 0x8000 # initialize the stack pointer
	isPrime:    															# isPrime function is initialized above main so as to not run unintentionally after main
		addiu $sp,$sp,-12 # stack grows by 12 bytes
		sw $ra, 0($sp) # save return address into stack							# increase stack pointer to store register values that must be restored for the callee
		sw $s0, 4($sp) # save i into s0
		sw $s1, 8($sp) # save n/2 into s1
		addi $s0, $zero, 2 # set i = 2
		srl $s1, $a0, 1 # shift argument right by 1 to divide by 2
		addi $s1, $s1, 1
	isPrimeLoop:														# this loop iterated through i values from 2 to the number/2 (definition of prime)
		beq $s0, $s1, EndProcTrue # 									# isPrime will return a one if it finds a factor of "n" else return zero 
		div $a0, $s0
		mfhi $t6
		beq $t6, 0, EndProcFalse							# jumps over True case
		addi $s0, $s0, 1 # i++
		j isPrimeLoop
	EndProcTrue:													# two cases for different returns 
		addi $v0, $zero, 1
		lw $ra, 0($sp) # save return address into stack
		lw $s0, 4($sp) # save i into s0
		lw $s1, 8($sp) # save n/2 into s1
		addiu $sp,$sp,12 # stack shrinks by 12 bytes
		j $ra														# cases will jump back to $ra which is the line after the jal call of main
	EndProcFalse:
		add $v0, $zero, $zero
		lw $ra, 0($sp) # save return address into stack
		lw $s0, 4($sp) # save i into s0
		lw $s1, 8($sp) # save n/2 into s1
		addiu $sp,$sp,12 # stack shrinks by XX bytes
		j $ra
		
	main:															# main function allocates memory for saved registers, loads array addresses, initializes regs to zero
		addiu $sp,$sp,-16 # stack grows by 16 bytes
		sw $ra, 0($sp) # save return address into stack
		sw $s0, 4($sp) # store i in $s0
		sw $s1, 8($sp) # store j in $s1
		sw $s2, 12($sp) # store k in $s2

		la $t0, arrayA # load start address for arrayA
		la $t1, arrayPrime # load start address for arrayPrime
		la $t2, arrayComposite # load start address for arrayComposite
		
		add $s0, $zero, $zero # set i = 0
		add $s2, $zero, $zero # set j = 0
		add $s2, $zero, $zero # set k = 0
		add $t4, $zero, $zero # set d = 0
		addi $t5, $zero, 10 # set reg t5 to 10
		addi $t7, $zero, 1 # set reg t7 to 1
	Loop:
		beq $s0, $t5, End # End case is satisfied when i equals the number of elements in arrayA			# main loop iterates through arrayA calling isPrime
		sll $t6, $s0, 2 # shift left 2 to multiply i by 4 (byte addressed)
		add $t9, $t0, $t6 # base address of arrayA + 4(i)
		lw $a0, 0($t9) # load value of a into argument reg for isPrime
		jal isPrime # jump and link to isPrime
		add $t4, $v0, $zero # grab return value of isPrime and store in reg d
		bne $t4, $t7, Else # branch to else if not equal to 1
		sll $t6, $s1, 2 # shift left 2 to multiply j by 4 (byte addressed)
		add $t8, $t1, $t6 # base address of arrayPrime + 4(j)
		sw $a0, 0($t8) # store a[i] in prime[j]		
		addi $s1, $s1, 1 # j++																	# isPrime returns a 1 or 0 indicating whether the value was prime or not
		addi $s0, $s0, 1 # i++
		j Loop		# must loop back or else statement will execute!!
	Else:
		sll $t3, $s2, 2 # shift left 2 to multiply k by 4 (byte addressed)					# branch to "else", composite array builder that will jump back to loop
		add $t8, $t2, $t3 # base address of arrayComposite + 4(k)
		sw $a0, 0($t8) # store a[i] in composite[k]		
		addi $s2, $s2, 1 # k++
		addi $s0, $s0, 1 # i++
		j Loop
	End:
		add $v0, $zero, $zero
		addiu $sp,$sp,16 # stack shrinks by 16 bytes
		lw $ra, 0($sp) # save return address into stack							# deallocates memory exits only if branch jumps
		lw $s0, 4($sp) # store i in $s0
		lw $s1, 8($sp) # store j in $s4
		lw $s2, 12($sp) # store k in $s2
		li $v0, 10
		syscall										# terminates function