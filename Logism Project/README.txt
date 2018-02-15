
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


1. Design Build
2. Main Components 
3. Any Known Issues/Bugs



————————————————————
1. Design Build
————————————————————
	Going into this project I wasn’t entirely sure where to go with it but, then after awhile the pieces started to fall together. I built components that could handle each type of instructions that need to be built. The ALU, Branch(Jump in Mips), W-Types or Word Operations, and a System Operation. Along with that I also built a decoder that generates a number of control bits rather than trying to manipulate the instructions. It isn’t as easy as I thought it would look but it gets the job done, sort of. I’ll explain the sort of in the Known Issues/Bugs section. With all these circuits/components created I made two main subcircuits in order to make it all work together. In the circuit you’ll see them as ALU Main Circuit and Decoder Main Circuit. These are the main circuits that works the whole entire circuit. I will go more in depth in the next part with what they contain and how they should work. 
	

——————————————————————————
2. Main Components
——————————————————————————
The table down below displays what I want and what should display without the bug messing it up:

|  Instruction  | Control Component |  Opcode  |
|———————————————|———————————————————|————-—————|
|     add       |     ALU_Ctrl      |   000    |
|     sub       |     ALU_Ctrl      |   001    |
|     addi      |     ALU_Ctrl      |   000    |
|     addui     |     ALU_Ctrl      |   000    |
|     and       |     ALU_Ctrl      |   010    |
|     nor       |     ALU_Ctrl      |   011    |
|     sll       |     ALU_Ctrl      |   100    |
|     srl       |     ALU_Ctrl      |   101    |
|     bx        |     Br_Ctrl       |   000    |
|     bz        |     Br_Ctrl       |   001    |
|     jr        |     Br_Ctrl       |   010    |
|     jal       |     Br_Ctrl       |   011    |
|     j         |     Br_Ctrl       |   100    |
|     lw        |     Word_Ctrl     |   0      |
|     sw        |     Word_Ctrl     |   1      |
|     put       |     Sys_Ctrl      |   0      |
|     halt      |     Sys_Ctrl      |   1      |
              
	It starts with the Main circuit which contains components like the clock, RAM, ROM, Counter, LED Display, and the Main ALU/Decoder subcircuits. The point of this project was obviously make a single cycle CPU. All components within the circuit work together to create this CPU and make it work the proper way. The clock itself controls the Counter which are components in the Main Decoder and ALU Circuits along with the RAM itself. The Counter is meant to control what instructions are read into the RAM from the ROM. The Main Decoder circuit then ends up determining which operation to use in the Main ALU circuit which outputs data into the RAM. In the Main Decoder circuit, it takes the instruction from the ROM and outputs signals and use data from the control circuits. The first circuit it runs through is the Fetch subcircuit which is outputed as a 16 bit register in the Register subcircuit. Fetch then outputs a 2 bit type to the Decoder subcircuit(This is different the Main Decoder, does not output or use the same features as the Main Decoder). It outputs 3 two bit opcodes to the Main ALU. Along with a CPU that fetch the instructions and should be the reason why the circuit halts(But will not for whatever reason, cannot figure it out). Another output is a subop bit that is sent to the sign extender subcircuit. The sign extender subcircuit is only used when the instruction “addi” or “addui” is called. This ends up outputting a sign extend or zero extend 16 bit string. After all that is said and done it is all outputted into the Main ALU Circuit. 

	The Main ALU Circuit is outputted into 4 different operations. It goes into either the Branch Circuit, the Word Circuit, the ALU Circuit(just like the decoder not being the same as the Main Decoder Circuit, this is not the same as the Main ALU Circuit), and a Display Circuit. The Main ALU is made to read in 16 bit strings, 4 bit shift, and a 3 bit opcode in order to output a 16 bit string that is determined using the Word Circuit, Branch Circuit, ALU Circuit, and Display Circuit. The Word Circuit reads in 2 sixteen bit strings so it can manipulate the RAM that is outputted on the main Circuit. It can either output control signals to the load or store function of RAM which is controlled by an enabler and a opcode. The Branch Circuit also reads 2 sixteen bit strings as well as an 8 bit immediate and the Address. A opcode is used in order to determine which Address will be outputted. The main Circuit reads in and outputs a 16 bit string for the LED Display. This all happens with the help of a 1 bit opcode and 2 bit input. What also makes it work is a clock that is used to update the LED display when a specific instruction called “put”. There is a register that is used to make this all work and that stores and sends the 16 bit string. The clock signal itself is what updates what is displayed on the LED Display. Whatever is in the register at that point is what ends up getting displayed on the LED Display.     	               




——————————————————————————
3. Any Known Issues/Bugs
——————————————————————————
	So as far I can figure out, there is only one bug or issue that I can’t seem to fix. It runs through the instructions and displays that on the LED Display. The display starts with displaying “00ff” then moves on to “0009” then all the way to “0000” which is where it should stop. However the halt instruction is not getting to the clock and it continues to display in the LED display when it doesn’t need too. In the section before this I show what should be displayed in a table but it won’t halt in order to do so. The only real fix there is, is to disconnect the wire on the clock from the other wires. Other than that I can’t seem to find any other way to stop it. As fas as I know this is the only bug I can find in the circuit.  









