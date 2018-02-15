___________________   
   
   Joey Reidell
  JMR240@pitt.edu
____________________



____________________________________
                                    |
                                    |
        Table of Contents           |
       ———————————————————          | 
____________________________________|


1. Algorithm 
2. Any Known Issues/Bugs
3. Mapping out the Functions



————————————————————
1. Algorithm
————————————————————

	The basic algorithm of my Auto Coder game program is built around using a 4-byte word containing information for displaying both 
	the instructions and the machine code. This is applicable in a few steps. First I start off by reading an integer that is typed in from 
	the user that is in the range of 1-9 where 1=add, 2=addi, 3=or, 4=ori, 5=lw, 6=sw, 7=j, 8=beq, and 9=bne. Secondly I then build and store 
	the word by having the proper registers and immediates on hand. Thirdly, I then after the user enters in 5 different integers, it displays 
	the instructions using the proper formatting, labels, register names, etc. Lastly, I then display the machine code in hexadecimal format 
	without using a syscall 34.
 
——————————————————————————
2. Any Known Issues/Bugs
——————————————————————————

	This program is able to handle when the first instruction is a jump or
	branch operation (j, beq, bne).  This results in the instruction jumping or
	branching to itself. However, the only known issue occurs when the first instruction is a jump or
	branch instruction and is subsequently followed by a jump or branch instruction.  This results in 
	2 labels being printed in the first line of displayed instructions. The only solution to this behavior 
	I could think of is to reuse the immediate of the first instruction as the immediate of the second instruction.  Then,
	the second instruction could bypass creating a label for the first one as it
	already exists. However, this breaks the rules established in the project requirements as the
	immediate must be incremented once it is used.  As such, this is not a valid solution to this issue.

——————————————————————————————
3. Mapping out the Functions
——————————————————————————————
	Firstly I start in the main function that displays the welcome message and the beginning prompt. It then moves into the function promptLoop.
	promptLoop iterates the prompt 5 times till it gets the 5 integer inputs. From there it goes to either addInstruct, addiInstruct, orInstruct, 
	oriInstruct, beqInstruct, bneInstruct, jInstruct, lwInstruct, or swInstruct. Those functions build those specific operations and goes into 
	input memory to display it later. The real building starts within the functions of R_Type, I_Type, and createLabel. R_Type build the operations 
	for addInstruct and orInstruct. I_Type then builds the other operations like addiInstruct, oriInstruct, etc. Beq and Bne Instructions go to 
	createLabel first and then iterates through to nextCount and advanceCount. The function nextCount loads the instruction word into temporary 
	memory and advanceCount advances the memory by 4 bytes. Side Note: Only createLabel, nextCount, and advanceCount only happen if an integer 
	equals the function beqInstruct, bneInstruct, and jInstruct. They all back to the function promptReturn and that begins to iterate the prompt 
	5 times. After the 5 iterations it then moves to the function loadRegisters. The function loadRegisters loads the associated addresses into 
	registers in order to print the instructions in the proper format. After that it then goes to the function printFunction. The function printFunction 
	loads the first byte of the input address word at the specified address. It then goes on to check each integer to see which function it needs to go to first. 
	The range of the integers is 1-9.
	1. addFunction  2. addiFunction  3. orFunction  4. oriFunction  5. lwFunction  6. swFunction  7. jFunction 8. beqFunction 9. bneFunction 
	
	All of these functions except for codeLabel will jump into the function output. codeLabel jumps back into printFunction so it does not cause 
	another iteration and end the program early. All of those functions go to either R_TypeFunctions, I_TypeFunctions, or W_TypeFunction. These 
	build up the rest of the code that needs to display depending on which function is called. Another function that is only called when beqFunction
	and bneFunction is called is the function beqAndbneOperations. This function builds the remaining instructions needed for the functions bneFunction
	and beqFunction. It all then goes to the function registerType. That function chooses a specific register based on the the integer that is inputted in.
	That function uses the functions of registert0-registert9 and then moves to the function output. The function output is where the code is displayed. 
	After 5 iterations of that it moves into building machine code. It starts with displaying the “machine code is:” message in the function machineMessage.
	Then moves into the function hexStart which puts “0x” in the memory to display. Then to the function beginMachineCode where it starts the build the machine 
	code for the instructions that are inputted in. Another function to account for is machineCount which iterates through the loop so it helps create a new
	machine code instruction each time. From there it moves into addAdd, addOr, addAddi, addOri, addJ, addSw, addLw, addBne, and addBeq. addAdd and addOr only uses
	the R_TypeMachine. R_TypeMachine can branch out to addOr but only if the first byte of the word is 3. It builds the machine code for those specific functions alone.
	I_TypeMachine is only used for addAddi and addOri. I_TypeMachine then adds the immediate to the sequence just like R_TypeMachine. There is also W_Machine that does the 	same thing as the others but only works for addLw and addSw. addJ works differently because it uses multiple load counters, the functions are called loadCounter0-3.
	There is a function called specialCase_B which is called if and only if bne or beq is the first instruction called. It all goes right to the function that builds
	the core of the machine code which is called nybbleLoader. The function nybbleLoader manipulates nybbles in order to create machine code. After that it goes to the 
	function registerCode which looks through all the functions that are addt0-addt9. Those just add the registers in the display without using syscall 34. Then there is one 	more function which is called printHexadecimal which all it does is print hexadecimal version of 0-9 and a-f. Once everything is built and goes through the iteration 
	5 times, it exits out the program. All functions work around the loop to create the precise instructions and machine code to displayed in the correct manner.  
	      
	
	      
           
     