.data
temporary: .space 4
integer: .space 80
start: .asciiz "Welcome to the Auto Coder!\n\n"
newString: .asciiz "\n"
addComma: .asciiz ", "
promptM1: .asciiz "Please enter the "
ordinalNumbers: .asciiz "1st", "2nd", "3rd", "4th", "5th"
promptM2: .asciiz " opcode:  "
completedCode: .asciiz "\n\nThe completed code is:\n"
machineCode: .asciiz "\n\nThe machine code is:\n"
registers: .asciiz "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8", "$t9"
opCodes: .asciiz "\tadd ", "\taddi ", "\tor ", "\tori ", "\tlw ", "\tsw ", "\tj ", "\tbeq ", "\tbne "
validOpCodes: .asciiz "The Opcodes: 1=add, 2=addi, 3=or, 4=ori, 5=lw, 6=sw, 7=j, 8=beq, 9=bne\n"

.text

# Joey Reidell
# JMR240@pitt.edu
# Project 1 - The Auto Coder
# This program takes integer inputs from the user and prints out coding instructions and machine code.
# I started off by getting the prompt to print out correctly and just get the inputs from the user. 
# From there I built off of that and made the functions that equal to the integers that they should correspond
# with. Every single function in this program is just built off each other and is almost close to a step by step 
# process as it is presented. As seen throughout the program, no syscall 34 is used to display what is needed 
# to be displayed. Figuring out how to add the special B case and the other loading counters that are put in here
# were kind of difficult to put together. One minor bug in this program is at the function codeLabel but it is a 
# little bit more explained in the ReadMe.txt. Like I said it is a minor bug that doesn't take away anything from
# the program itself.
 

# Displays greeting then displays the opcodes along with loading the numbers 
# for the prompts as it keeps track of the immediate value. 
main:
la $a0, start
	addi, $v0, $zero, 4
	syscall			
	la $a0, validOpCodes
	syscall			
	la $t4, ordinalNumbers	
	la $s0, integer		
	la $s1, temporary		
	addi $k0, $zero, 100	
	addi $k1, $zero, 1	
	
# Prompts the user for 5 different integer inputs within the loop and depending 
# on whether or not it is in the valid range of 1-9, it will create a certain 
# instruction based on that number.	
promptLoop:
	addi $v0, $zero, 4
	la $a0, promptM1
	syscall				
	addi $a0, $t4, 0
	syscall				
	la $a0, promptM2
	syscall				
	addi $v0, $zero, 5
	syscall				
	addi $t0, $v0, 0		
	beq $t0, 1, addInstruct		
	beq $t0, 2, addiInstruct  	
	beq $t0, 3, orInstruct    	
	beq $t0, 4, oriInstruct   	
	beq $t0, 5, lwInstruct   	
	beq $t0, 6, swInstruct   	
	beq $t0, 7, jInstruct	   	
	beq $t0, 8, beqInstruct		
	beq $t0, 9, bneInstruct		
	j exit				
	
# Increments an internal counter for the prompt and then advances the number address
# to the next string. Loops until counter hits 5 then jumps to next part of the program(PrintPrep) 	
promptReturn:
	addi $t8, $t8, 1	
	addi $t4, $t4, 4	
	bne $t8, 5, promptLoop	
	j loadRegisters		

# The next 9 functions are building instructions for the opcodes. Depending which number(1-9) is put in,
# it will build that instruction, create a label, the code, etc. 
# As well as jump to R-I-J Type depending which opcode is used.
addInstruct:
	sb $t0, 0($s1)		
	j R_Type		
	
addiInstruct:
	sb $t0, 0($s1)		
	j I_Type		
	
orInstruct:
	sb $t0, 0($s1)		
	j R_Type		
	
oriInstruct:
	sb $t0, 0($s1)		
	j I_Type		
  
lwInstruct:
	sb $t0, 0($s1)		
	addi $t0, $k1, 1	
	sb $t0, 1($s1)		
	sb $k0, 2($s1)		
	sb $k1, 3($s1)		
	lw $s2, 0($s1)		
	sw $s2, 0($s0)		
	addi $k1, $k1, 1	
	addi $k0, $k0, 1	
	addi $s0, $s0, 4	
	lui $s2, 0x0000
	ori $s2, $s2, 0x0000	
	sw $s2, 0($s1)		
	j promptReturn		
	
swInstruct:
	sb $t0, 0($s1)		
	sb $k1, 1($s1)		
	sb $k0, 2($s1)		
	addi $t0, $k1, 1
	sb $t0, 3($s1)		
	lw $s2, 0($s1)		
	sw $s2, 0($s0)		
	addi $k1, $k1, 1	
	addi $k0, $k0, 1	
	addi $s0, $s0, 4	
	lui $s2, 0x0000
	ori $s2, $s2, 0x0000	
	sw $s2, 0($s1)		
	j promptReturn		
	
jInstruct:
	jal createLabel	
	addi $t0, $zero, 7
	sb $t0, 0($s1)		
	sb $k0, 1($s1)		
	lw $s2, 0($s1)		
	sw $s2, 0($s0)		
	addi $k0, $k0, 1	
	addi $k1, $k1, 1	
	addi $s0, $s0, 4	
	lui $s2, 0x0000
	ori $s2, $s2, 0x0000	
	sw $s2, 0($s1)		
	j promptReturn		
	
beqInstruct:
	jal createLabel	
	addi $t0, $zero, 8
	sb $t0, 0($s1)		
	j I_Type		
	
bneInstruct:
	jal createLabel	
	addi $t0, $zero, 9
	sb $t0, 0($s1)		
	j I_Type		

# R_Type is used only when building instructions for Add or Or is called. 
# This builds the stored word from temporary memory.
# Plus resets the temporary memory by setting it all to 0 and jumps back to promptReturn. 	
R_Type:	
	addi $t0, $k1, 2
	sb $t0, 1($s1)		
	sb $k1, 2($s1)		
	addi $t0, $k1, 1
	sb $t0, 3($s1)		
	lw $s2, 0($s1)		
	sw $s2, 0($s0)		
	addi $k1, $k1, 2	
	addi $s0, $s0, 4	
	lui $s2, 0x0000
	ori $s2, $s2, 0x0000	
	sw $s2, 0($s1)		
	j promptReturn		
	
# I_Type builds words for addi, ori, beq, and bne instructions since they share common syntax
# for source and destination registers and the immediate.
I_Type:	
	addi $t0, $k1, 1
	sb $t0, 1($s1)		
	sb $k1, 2($s1)		
	sb $k0, 3($s1)		
	lw $s2, 0($s1)		
	sw $s2, 0($s0)		
	addi $k1, $k1, 1	
	addi $k0, $k0, 1	
	addi $s0, $s0, 4	
	lui $s2, 0x0000
	ori $s2, $s2, 0x0000	
	sw $s2, 0($s1)		
	j promptReturn		
	
# createLabel is called before any instructions are created. It does this by moving the last instruction word in the
# input memory by 4 bytes. Doing this leaves a gap between words in input memory then another word containing 
# information is inserted in said gap. It should end up creating a label then return to the proper input 
# memory address. It then branches out to nextCount if the counter is at 0. At the end it resets the word in 
# memory to all zeros.   
createLabel:
	beq $t8, 0, nextCount	
	addi $s0, $s0, -4	
	lw $s3, 0($s0)		
	sw $s2, 0($s0)	
	
# nextCount stores an integer(88) as the first byte in temporary memory then the second byte stores the immediate.
# It then goes on to load the built word from temporary memory into $s2. After all that it reset the memory address
# and temp memory. It then branches out to advanceCount if the counter is at 0. It restores the stored word into the
# next available space in input memory. 			
nextCount:
	addi $t0, $zero, 88
	sb $t0, 0($s1)		
	sb $k0, 1($s1)		
	lw $s2, 0($s1)		
	sw $s2, 0($s0)		
	lui $s2, 0x0000
	ori $s2, $s2, 0x0000	
	sw $s2, 0($s1)		
	beq $t8, 0, advanceCount	
	sw $s3, 4($s0)		
	addi $s0, $s0, 8	
	jr $ra			

# Advances the memory address by 4 then jumps to return address	
advanceCount:
	addi $s0, $s0, 4	
	jr $ra			

# loadRegisters loads the associated addresses into registers in order to print the instructions
# in the proper format.
loadRegisters:
	la $s0, integer		
	la $s4, registers	
	la $s5, opCodes		
	la $s6, newString		
	la $s7, addComma		
	addi $v0, $zero, 4
	la $a0, completedCode
	syscall			

# printFunction loads the first byte of the input address word at the specified address. It then goes on to 
# check each integer to see which function it needs to go to first. The range of the integers is 1-9. All of 
# these functions except for codeLabel will jump into the function output. codeLabel jumps back into printFunction
# so it does not cause another iteration and end the program early. 
printFunction:	
	lb $t0, 0($s0)			
	beq $t0, 1, addFunction		
	beq $t0, 2, addiFunction	
	beq $t0, 3, orFunction		
	beq $t0, 4, oriFunction	
	beq $t0, 5, lwFunction		
	beq $t0, 6, swFunction		
	beq $t0, 7, jFunction		
	beq $t0, 8, beqFunction		
	beq $t0, 9, bneFunction		
	beq $t0, 88, codeLabel		
	
# output first increments the print instruction counter by 1 then advances to the next instruction word. 
# It will go to printFunction if the counter is NOT at 5. Once it is done it jump to machineMessage to 
# continue the program.	
output:
	addi $t9, $t9, 1		
	addi $s0, $s0, 4		
	addi $v0, $zero, 4
	addi $a0, $s6, 0
	syscall				
	bne $t9, 5, printFunction		
	la $s0, integer			
	j machineMessage			

# These 7 functions will end up printing either an add, addi, or, ori, sw, lw, or j. Depending on which 
# function is called, it will jump to R_TypeFunctions, I_TypeFunctions, or W_TypeFunctions to finish 
# building the operation. 		
addFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 0
	syscall				
	jal R_TypeFunctions		
	j output			
	
addiFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 6
	syscall				
	jal I_TypeFunction		
	j output			
	
orFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 13
	syscall				
	jal R_TypeFunctions		
	j output			
	
oriFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 18
	syscall				
	jal I_TypeFunction		
	j output			
	
lwFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 24
	syscall				
	jal W_TypeFunction			
	j output			
	
swFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 29
	syscall				
	jal W_TypeFunction			
	j output			
	
jFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 34
	syscall				
	addi $v0, $zero, 11
	addi $a0, $zero, 0x4c
	syscall				
	addi $v0, $zero, 1
	lb $a0, 1($s0)
	syscall				
	j output			

# beqFunction and bneFunction print out each word respectivly then jumps to a specific function used for them 
# called beqAndbneOperations, which should end up printing out the rest of the instructions for those functions. 	
beqFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 38
	syscall				
	jal beqAndbneOperations		
	j output			
	
bneFunction:
	addi $v0, $zero, 4
	addi $a0, $s5, 44
	syscall				
	jal beqAndbneOperations		
	j output			
	
# R_TypeFunctions prints out the instructions for the operations of add or or. It prints the associated register
# and then loads the stored return address from the stack.
R_TypeFunctions:
	sw $ra, 0($sp)		
	lb $t0, 1($s0)		
	jal registerType	
	addi $a0, $s7, 0
	syscall			
	lb $t0, 2($s0)		
	jal registerType	
	addi $a0, $s7, 0
	syscall			
	lb $t0, 3($s0)		
	jal registerType	
	lw $ra, 0($sp)		
	jr $ra			

# I_TypeFunction prints out the instructions for the operations of addi and ori. It prints the associated register 
# and then loads the stored return address from the stack.
I_TypeFunction:
	sw $ra, 0($sp)		
	lb $t0, 1($s0)		
	jal registerType	
	addi $a0, $s7, 0
	syscall			
	lb $t0, 2($s0)		
	jal registerType	
	addi $a0, $s7, 0
	syscall			
	lb $a0, 3($s0)		
	addi $v0, $zero, 1
	syscall			
	lw $ra, 0($sp)		
	jr $ra			

# W_TypeFunction prints out the instructions for the operations of lw and sw. It prints the associated register 
# and then loads the stored return address from the stack. 
W_TypeFunction:
	sw $ra, 0($sp)		
	lb $t0, 1($s0)		
	jal registerType	
	addi $a0, $s7, 0
	syscall			
	lb $a0, 2($s0)		
	addi $v0, $zero, 1
	syscall			
	addi $v0, $zero, 11
	addi $a0, $zero, 0x28
	syscall			
	addi $v0, $zero, 4
	lb $t0, 3($s0)		
	jal registerType	
	addi $v0, $zero, 11
	addi $a0, $zero, 0x29
	syscall			
	lw $ra, 0($sp)		
	jr $ra			

# beqAndbneOperations prints the rest of the instructions for the beq and bne operations because they
# share a common syntax.
beqAndbneOperations:
	sw $ra, 0($sp)		
	lb $t0, 1($s0)		
	jal registerType	
	addi $a0, $s7, 0
	syscall			
	lb $t0, 2($s0)		
	jal registerType	
	addi $a0, $s7, 0
	syscall			
	addi $v0, $zero, 11
	addi $a0, $zero, 0x4c
	syscall			
	lb $a0, 3($s0)		
	addi $v0, $zero, 1
	syscall			
	lw $ra, 0($sp)		
	jr $ra			

# codeLabel starts the beginning of creating a label and prints the immediate value. Once completed it will jump
# back to the function printFunction.
# BUG WARNING: Will end up printing only one label or none at all. Read ReadMe.txt for more details.
codeLabel:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x4c
	syscall			
	lb $a0, 1($s0)
	addi $v0, $zero, 1
	syscall			
	addi $v0, $zero, 11
	addi $a0, $zero, 0x3a
	syscall	
	addi $s0, $s0, 4	
	j printFunction			

# Prints the certain register $t0-$t9 depending on if the integer entered is 1-9		
registerType:
	beq $t0, 1, registert0	
	beq $t0, 2, registert1	
	beq $t0, 3, registert2	
	beq $t0, 4, registert3	
	beq $t0, 5, registert4	
	beq $t0, 6, registert5	
	beq $t0, 7, registert6	
	beq $t0, 8, registert7	
	beq $t0, 9, registert8	
	beq $t0, 0x0a, registert9	
	beq $t0, 0x0b, registert0	

# Prints out a register $t0-$t9 then each function jumps to the return address 	
registert0:	
	addi $a0, $s4, 0
	syscall			
	jr $ra			
	
registert1:	addi $a0, $s4, 4
	syscall			
	jr $ra			
	
registert2:	addi $a0, $s4, 8
	syscall			
	jr $ra			
	
registert3:	addi $a0, $s4, 12
	syscall			
	jr $ra			
	
registert4:	addi $a0, $s4, 16
	syscall			
	jr $ra			
	
registert5:	addi $a0, $s4, 20
	syscall			
	jr $ra			
	
registert6:	addi $a0, $s4, 24
	syscall			
	jr $ra			
	
registert7:	addi $a0, $s4, 28
	syscall			
	jr $ra			
	
registert8:	addi $a0, $s4, 32
	syscall			
	jr $ra			
	
registert9:	addi $a0, $s4, 36
	syscall			
	jr $ra			

# Displays the machineCode message
machineMessage:
	la $a0, machineCode
	addi $v0, $zero, 4
	syscall			

# Starts the hexidecimal machine code by printing out a horizontal tab followed by "0x".
hexStart:
	li $v0, 11
	addi $a0, $zero, 0x09
	syscall			
	addi $a0, $zero, 0x30
	syscall			
	addi $a0, $zero, 0x78
	syscall			

# beginMachineCode builds the machine code for each instruction using what was built from the past functions.
# It loads the first byte and determines which number, 1-9, goes with said instruction that is loaded. If it 
# is not a number within 1-9 it ends up advancing to the next word in the input memory. Depending on the 
# certain integer that the byte equals it will then print out the beginning of one of the 9 opcodes. It then jumps
# back to beginMachineCode to restart the loop. 
beginMachineCode:
	lb $t1, 0($s0)			
	beq $t1, 1, R_TypeMachine	
	beq $t1, 2, addAddi	
	beq $t1, 3, R_TypeMachine	
	beq $t1, 4, addOri		
	beq $t1, 5, addLw		
	beq $t1, 6, addSw		
	beq $t1, 7, addJ		
	beq $t1, 8, addBeq		
	beq $t1, 9, addBne		
	add $s0, $s0, 4			
	j beginMachineCode	

# machineCounter increments the machine code counter and advances the input memory address to the 
# next word. It then jumps to hexStart and iterates 5 times until it is done. 						
machineCounter:
	addi $t5, $t5, 1		
	addi $s0, $s0, 4	
	bne $t5, 5, hexStart	
	j exit				
	
# R_TypeMachine builds machine code for the operations of add and or. The third, fourth, and second byte is loaded 
# into the instruction word. It will however, branch to the function addOr if the first byte of the word is 3. 
# It then stores the completed machine code to print then jumps to nybbleLoader to finish the machine code. 
R_TypeMachine:
	lb $t0, 2($s0)		
	jal registerCode		
	sll $t2, $t2, 5		
	lb $t0, 3($s0)		
	jal registerCode		
	sll $t2, $t2, 5		
	lb $t0, 1($s0)		
	jal registerCode		
	sll $t2, $t2, 8		
	beq $t1, 3, addOr	
	ori $t2, $t2, 0x20	
	sw $t2, 0($s1)		
	j nybbleLoader	
	
# addOr adds the or function code to the sequence and stores it to print. 
# It then jumps to nybbleLoader to finish the rest of the machine code.			
addOr:
	ori $t2, $t2, 0x25	
	sw $t2, 0($s1)		
	j nybbleLoader		

# addAddi and addOri adds the opcode of addi or ori to the sequence. It then jumps to the function I_TypeMachine
# to continue writing the machine code.		
addAddi:
	ori $t2, $t2, 0x20	
	sll $t2, $t2, 6		
	j I_TypeMachine	
	
addOri:
	ori $t2, $t2, 0x34	
	sll $t2, $t2, 6		
	j I_TypeMachine
	
# I_TypeMachine finishes machine code for the operations of addi and ori. The third and second byte is loaded 
# into the instruction word. It then adds the immediate to the sequence then stores it to print. It then
# jumps to nybbleLoader to finish the rest of the machine code.
I_TypeMachine:
	lb $t0, 2($s0)		
	jal registerCode		
	sll $t2, $t2, 5		
	lb $t0, 1($s0)		
	jal registerCode		
	sll $t2, $t2, 13	
	lb $t0, 3($s0)		
	or $t2, $t2, $t0	
	sw $t2, 0($s1)		
	j nybbleLoader		

# addLw and addSw adds the opcode of lw or sw to the sequence. It then jumps to the function W_Machine
# to continue writing the machine code.	  		
addLw:
	ori $t2, $t2, 0x8c	
	sll $t2, $t2, 6		
	j W_Machine		
	
addSw:
	ori $t2, $t2, 0xac	
	sll $t2, $t2, 6		
	j W_Machine		
	
# W_Machine finishes machine code sequence for the specific operations of lw and sw. It then adds the register binary 
# code to the sequence. It then loads the instruction word and adds the immediate to the sequence. After that
# it stores the completed machine code and prints it.  
W_Machine:
	lb $t0, 3($s0)		
	jal registerCode		
	sll $t2, $t2, 5		
	lb $t0, 1($s0)		
	jal registerCode		
	sll $t2, $t2, 13	
	lb $t0, 2($s0)		
	or $t2, $t2, $t0	
	sw $t2, 0($s1)		
	j nybbleLoader		
	
# addJ generates machine code for the jump operation. It uses the machine code counter to figure out where an address
# is located on a certain label. The address of said label is logically shifted right 2 bits and added with the opcode
# to complete the address. It starts off with adding the J opcode then shifts all bits to the left by 24 then checks if
# the counter is 0, 1, 2, 3, or 4. 
addJ:
	ori $t2, $t2, 0x08	
	sll $t2, $t2, 24	
	beq $t5, 0, loadCounter0	
	beq $t5, 1, loadCounter0	
	beq $t5, 2, loadCounter1	
	beq $t5, 3, loadCounter2	
	beq $t5, 4, loadCounter3	
	
# loadCounter0 loads 0x00400000 into register $t3 and logically shifts all bits the right by 2 while 
# also adding the target address to the sequence.Then stores the completed machine code to print out the input. 
# loadCounter1 loads 0x00400004 into register $t3 and logically shifts all bits the right by 2 while 
# also adding the target address to the sequence.Then stores the completed machine code to print out the input. 
# loadCounter2 loads 0x00400008 into register $t3 and logically shifts all bits the right by 2 while 
# also adding the target address to the sequence.Then stores the completed machine code to print out the input. 
# loadCounter3 loads 0x0040000c into register $t3 and logically shifts all bits the right by 2 while 
# also adding the target address to the sequence.Then stores the completed machine code to print out the input.
# After all that they all jump back to nybbleLoader to continue the program. 	
loadCounter0:
	lui $t3, 0x0040		
	srl $t3, $t3, 2		
	or $t2, $t2, $t3	
	sw $t2, 0($s1)		
	j nybbleLoader		
	
loadCounter1:
	lui $t3, 0x0040
	ori $t3, 0x0004		
	srl $t3, $t3, 2		
	or $t2, $t2, $t3	
	sw $t2, 0($s1)		
	j nybbleLoader		
	
loadCounter2:
	lui $t3, 0x0040
	ori $t3, 0x0008		
	srl $t3, $t3, 2		
	or $t2, $t2, $t3	
	sw $t2, 0($s1)		
	j nybbleLoader		
	
loadCounter3:
	lui $t3, 0x0040
	ori $t3, 0x000c		
	srl $t3, $t3, 2		
	or $t2, $t2, $t3	
	sw $t2, 0($s1)		
	j nybbleLoader		

# All these 2 functions is add beq or bne opcode to the sequence then logically shift left by 6. After that it then
# enters into I_BranchMachine to finish off the machine code.		
addBeq:
	ori $t2, $t2, 0x10	
	sll $t2, $t2, 6		
	j I_BranchMachine		
	
addBne:
	ori $t2, $t2, 0x14	
	sll $t2, $t2, 6		
	j I_BranchMachine		
	
# I_BranchMachine finishes the machine code for operations beq and bne. The immediate should always be 0xfffe. If 
# bne or beq are called first in the sequence, then it will jump to specialCase_B and display that immediate(0xffff).
I_BranchMachine:
	lb $t0, 1($s0)			
	jal registerCode			
	sll $t2, $t2, 5			
	lb $t0, 2($s0)			
	jal registerCode			
	sll $t2, $t2, 13		
	beq $t5, 0, specialCase_B	
	ori $t2, $t2, 0xfffe		
	sw $t2, 0($s1)			
	j nybbleLoader			
	
# specialCase_B is called if and only if the function beq or bne is one of the first operation functions that is
# built and displayed in the sequence. The branch operation jumps to itself and makes the immediate 0xffff.
specialCase_B:
	ori $t2, $t2, 0xffff	
	sw $t2, 0($s1)		
	j nybbleLoader		

# registerCode compares loaded bytes from the instruction word with the integers ranging fomr 1-10. 
# Each integer goes with a register from $t0-$t9. Once it figures out which integer, it will branch out to
# the specific function and adds the binary code to the word sequence.
registerCode:
	beq $t0, 1, addt0	
	beq $t0, 2, addt1	
	beq $t0, 3, addt2	
	beq $t0, 4, addt3	
	beq $t0, 5, addt4	
	beq $t0, 6, addt5	
	beq $t0, 7, addt6	
	beq $t0, 8, addt7	
	beq $t0, 9, addt8	
	beq $t0, 0x0a, addt9	
	
addt0:
	ori $t2, $t2, 0x40	
	jr $ra			
	
addt1:
	ori $t2, $t2, 0x48	
	jr $ra			
	
addt2:
	ori $t2, $t2, 0x50	
	jr $ra			
	
addt3:
	ori $t2, $t2, 0x58	
	jr $ra			
	
addt4:
	ori $t2, $t2, 0x60	
	jr $ra			
	
addt5:
	ori $t2, $t2, 0x68	
	jr $ra			
	
addt6:
	ori $t2, $t2, 0x70	
	jr $ra			
	
addt7:
	ori $t2, $t2, 0x78	
	jr $ra			
	
addt8:
	ori $t2, $t2, 0xc0	
	jr $ra			
	
addt9:
	ori $t2, $t2, 0xc8	
	jr $ra			

# nybbleLoader is where every operation goes once the machine code is assembled. The program will load each nybble 
# of the machine code. It all goes back to what was built from the function beginMachineCode all the way down 
# to this. This is called a nybble loader because in order to manipulate the code, you have to manipulate the nybbles 
# directly. nybbleLoader works through the sequence backwords using a loop and increments using machineCounter.
# It ends up printing the character for whatever the hexadecimal value is returned. It also increments the hexadecimal
# printing counter by 1 and decrements the machine code memory address by 1. It will go through this for 4 iterations.
# At the end it rests $s2 and $s6 to 0.
nybbleLoader:	
	addi $v0, $zero, 11
	lb $t0, 3($s1)		
	srl $t0, $t0, 4		
	andi $t0, $t0, 0x0f	
	jal printHexadecimal		
	lb $t0, 3($s1)		
	andi $t0, $t0, 0x0f	
	jal printHexadecimal		
	addi $t6, $t6, 1	
	addi $s1, $s1, -1	
	bne $t6, 4, nybbleLoader	
	addi $s1, $s1, 4	
	addi $t2, $zero, 0	
	addi $t6, $zero, 0	
	addi $a0, $zero, 0x0a
	syscall			
	j machineCounter	

# Prints a hexadecimal by comparing the isolated nybble to integers ranging from 0-9 and
# letters a-f.  It then uses syscall 11 to print out the equivalent character.
printHexadecimal:
	beq $t0, 0x00, print0	
	beq $t0, 0x01, print1	
	beq $t0, 0x02, print2	
	beq $t0, 0x03, print3	
	beq $t0, 0x04, print4	
	beq $t0, 0x05, print5	
	beq $t0, 0x06, print6	
	beq $t0, 0x07, print7	
	beq $t0, 0x08, print8	
	beq $t0, 0x09, print9	
	beq $t0, 0x0a, printA	
	beq $t0, 0x0b, printB	
	beq $t0, 0x0c, printC	
	beq $t0, 0x0d, printD	
	beq $t0, 0x0e, printE	
	beq $t0, 0x0f, printF	

# Prints either an integer 0-9 or a character a-f then jumps back to return address	
print0:
	addi $a0, $zero, 0x30
	syscall			
	jr $ra			
	
print1:
	addi $a0, $zero, 0x31
	syscall			
	jr $ra			
	
print2:
	addi $a0, $zero, 0x32
	syscall			
	jr $ra			
	
print3:
	addi $a0, $zero, 0x33
	syscall			
	jr $ra			
	
print4:
	addi $a0, $zero, 0x34
	syscall			
	jr $ra			
	
print5:
	addi $a0, $zero, 0x35
	syscall			
	jr $ra			
	
print6:
	addi $a0, $zero, 0x36
	syscall			
	jr $ra			
	
print7:
	addi $a0, $zero, 0x37
	syscall			
	jr $ra			
	
print8:
	addi $a0, $zero, 0x38
	syscall			
	jr $ra			
	
print9:
	addi $a0, $zero, 0x39
	syscall			
	jr $ra			
	
printA:
	addi $a0, $zero, 0x61
	syscall			
	jr $ra			
	
printB:
	addi $a0, $zero, 0x62
	syscall			
	jr $ra			
	
printC:
	addi $a0, $zero, 0x63
	syscall			
	jr $ra			
	
printD:
	addi $a0, $zero, 0x64
	syscall			
	jr $ra			
	
printE:
	addi $a0, $zero, 0x65
	syscall			
	jr $ra			
	
printF:
	addi $a0, $zero, 0x66
	syscall			
	jr $ra			

# Exits out of the program		
exit:	addi $v0, $zero, 10
	syscall			
	
	
