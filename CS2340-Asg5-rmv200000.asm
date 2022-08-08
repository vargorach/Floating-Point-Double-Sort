# Written by Rachel Vargo, CS2340 NetId: rmv200000
# Started March 28th, 2022	
# This program takes in user entered floating point doubles and places them into an
# array list to be sorted. It exits when the digit entered is a 0 and then sorts the
# list and prints out the sum, average, and total amount entered.	
	
	.data
	.include	"SysCalls.asm"
enterNum:
	.asciiz		"Please enter a number: "

sorted:	.asciiz		"\nSorted list: \n"
total:	.asciiz		"Count: "	
sum:	.asciiz		"\nSum: "	
average:
	.asciiz		"\nAverage: "
	.align		3
list:	.space		800			#array for the doubles
	.eqv		newline	10
	.text
main:
	la	$t0, list			#holds the address of list of numbers
	li	$t1, 0				#counter of how many entered
enterDouble:	
	la	$a0, enterNum			#prompts user to enter a double
	li	$v0, SysPrintString
	syscall
	li	$v0, SysReadDouble		#reads in the user entered double
	syscall
	c.eq.d	$f0, $f2			#checks if the double is 0
	bc1t	exit				#branches to sort step if 0 is entered
	s.d	$f0, 0($t0)			#load the double into the list
	addi	$t0, $t0, 8			#add space for next float
	addi	$t1, $t1, 1			#increments when each double is stored
	b	enterDouble			#continues to ask for more doubles
exit:
	mul	$t5, $t1, 8			#for length of doubles 8 
	sub	$t0, $t0, $t5			#to reset array to sort
	li	$a0, 0				#for $a0 to contain the count
	li	$t3, 0				#initiated to 0 for sort counter
	jal	sort				#jumps to sort the array
	jal	print				#jumps to print the array 
	li	$v0, SysExit			#terminates the program
	syscall
	
	
sort:		#MAKE A BUBBLE SORT
	addi	$a0, $a0, 1			#$a0 contains the count
	ldc1	$f2, 0($t0)			#loads the first double
	ldc1	$f4, 8($t0)			#loads the second double
	c.eq.d	$f4, $f6			#checks if second double is 0
	bc1t	sortFin				#branches to end if 0
	addi	$t0, $t0, 8			#add 8 to go to the next double
	c.lt.d	$f2, $f4			#compares the two and if $f2<$f4 =1, if not =0
	bc1t	sort				#CHANGED FROM SORT 1 TO SORT
	sdc1	$f2, 0($t0)			#store the moved larger double
	sdc1	$f4, -8($t0)			#-8 to swap and store the smaller double before
	mul	$a0, $a0, 8			#for the length of the doubles
	sub	$t0, $t0, $a0			#to reset the array and start from beginning
	li	$a0, 0				#restart the count 
	b	sort				#continues the loop for all doubles
sortFin:
	jr	$ra				#sort is finished, back to main


print:		#PRINT THE VALUES W TOTAL, SUM, AND AVERAGE
	li	$t3, 0				#holds the average NEEDS TO BE FLOAT
	la	$a0, sorted
	li	$v0, SysPrintString
	syscall
	li	$t4, 0				#initiate counter for printing array
	addi	$t5, $t5, -8			#subtract 8 as it is one double over
	sub	$t0, $t0, $t5			#to reset the array to print
	#LOOP TO PRINT ARRAY HERE
printarray:
	beq	$t1, $t4, printFinal
	ldc1	$f2, 0($t0)			#loads the double to be printed
	mov.d	$f12, $f2
	li	$v0, SysPrintDouble
	syscall
	addi	$t0, $t0, 8
	li	$a0, newline
	li	$v0, SysPrintChar
	syscall
	add.d	$f6, $f6, $f2
	addi	$t4, $t4, 1			#increment counter to check when array is over
	b	printarray
printFinal:		
	la	$a0, total			#prints the total message
	li	$v0, SysPrintString
	syscall
	move	$a0, $t1
	li	$v0, SysPrintInt		#prints how many doubles were enered
	syscall
	la	$a0, sum			#prints the sum message
	li	$v0, SysPrintString
	syscall
	mov.d	$f12, $f6
	li	$v0, SysPrintDouble		#prints what the sum of all the doubles is
	syscall
	mtc1	$t1, $f14			#moves total to be a float value
	cvt.d.w	$f14, $f14			#converts total to a double value
	div.d	$f6, $f6, $f14			#computes the average
	la	$a0, average
	li	$v0, SysPrintString		#prints the average message
	syscall
	mov.d	$f12, $f6
	li	$v0, SysPrintDouble		#prints what the average of all the doubles is
	syscall
	jr	$ra				#everything is printed, jumps back to main
	
