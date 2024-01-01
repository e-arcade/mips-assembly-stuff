# STEP 1 - COMPILATION (FROM HIGH-LEVEL LANG TO ASSEMBLY)

#int f, g, y; // global variables
#int main(void) {
#	f = 2;
#	g = 3;
#	y = sum(f, g);
#	return y;
#}

#int sum(int a, int b) {
#	return (a + b);
#}

# global/dynamic data
.data
f:
g:
y:

# code segment
.text
main: addi $sp, $sp, -4 # make stack frame for one register
	  sw $ra, 0($sp) # store $ra on stack
	  addi $a0, $0, 2 # f = 2
	  sw $a0, f # store 2 in global variable f
	  addi $a1, $0, 3 # g = 3
	  sw $a1, g # store 3 in global variable g
	  jal sum # get $v0
	  sw $v0, y # y = sum(f, g); store result in global variable y
	  lw $ra, 0($sp) # load $ra from stack
	  addi $sp, $sp, 4 # restore stack pointer
	  jr $ra # return to operating system

sum:  add $t0, $a0, $a1 # $t0 = a + b
	  add $v0, $v0, $t0 # store result in $v0
	  jr $ra # return to caller



# STEP 2 - TRANSLATION (FROM ASSEMBLY TO MACHINE CODE)
# The assembler makes two passes through the assembly code:
# 1) the assembler assigns instruction addresses and finds all the symbols, such as labels and global variable names,
# the names and addresses of the symbols are kept in a symbol table.
# The symbol addresses are filled in after the first pass, when the addresses of labels are known

0x00400000 main: addi $sp, $sp, -4
0x00400004 		 sw $ra, 0($sp)
0x00400008 		 addi $a0, $0, 2
0x0040000C 		 sw $a0, f
0x00400010 		 addi $a1, $0, 3
0x00400014 		 sw $a1, g
0x00400018 		 jal sum
0x0040001C 		 sw $v0, y
0x00400020 	 	 lw $ra, 0($sp)
0x00400024 		 addi $sp, $sp, 4
0x00400028 		 jr $ra
0x0040002C sum:  add $v0, $a0, $a1
0x00400030		 jr $ra

#               Symbol table
#       Symbol                Address
#         f                 0x10000000
#         g                 0x10000004
#         y                 0x10000008
#        main               0x00400000
#        sum                0x0040002C


# 2) the assembler produces the machine language code

0x00400000		 0x23BDFFFC # addi $sp, $sp, -4
0x00400004		 0xAFBF0000 # sw $ra, 0 ($sp)
0x00400008		 0x20040002 # addi $a0, $0, 2
0x0040000C		 0xAF848000 # sw $a0, 0x8000 ($gp)
0x00400010		 0x20050003 # addi $a1, $0, 3
0x00400014		 0xAF858004 # sw $a1, 0x8004 ($gp)
0x00400018		 0x0C10000B # jal 0x0040002C
0x0040001C		 0xAF828008 # sw $v0, 0x8008 ($gp)
0x00400020		 0x8FBF0000 # lw $ra, 0 ($sp)
0x00400024		 0x23BD0004 # addi $sp, $sp, 4
0x00400028		 0x03E00008 # jr $ra
0x0040002C		 0x00851020 # add $v0, $a0, $a1
0x00400030		 0x03E00080 # jr $ra


# STEP 3 - LINKING
# The job of the linker is to combine all of the object files into one machine language file called the executable

# Executable header file         Text size (bytes) Data size (bytes)
					                   0x34              0xC
# Text segment                        Adress         Instruction
									0x00400000		 0x23BDFFFC   # addi $sp, $sp, -4
									0x00400004		 0xAFBF0000   # sw $ra, 0 ($sp)
									0x00400008		 0x20040002   # addi $a0, $0, 2
									0x0040000C		 0xAF848000   # sw $a0, 0x8000 ($gp)
									0x00400010		 0x20050003   # addi $a1, $0, 3
									0x00400014		 0xAF858004   # sw $a1, 0x8004 ($gp)
									0x00400018		 0x0C10000B   # jal 0x0040002C
									0x0040001C		 0xAF828008   # sw $v0, 0x8008 ($gp)
									0x00400020		 0x8FBF0000   # lw $ra, 0 ($sp)
									0x00400024		 0x23BD0004   # addi $sp, $sp, 4
									0x00400028		 0x03E00008   # jr $ra
									0x0040002C		 0x00851020   # add $v0, $a0, $a1
									0x00400030		 0x03E00080   # jr $ra
# Data segment                        Address           Data
									0x10000000           f
									0x10000004           g
									0x10000008           y


# STEP 4 - LOADING
#The operating system loads a program by reading the text segment of the executable file from a storage device 
# (usually the hard disk) into the text segment of memory. The operating system sets $gp to 0x10008000
#the middle of the global data segment) and $sp to 0x7FFFFFFC (the top of the dynamic data segment), 
# then performs a jal 0x00400000 to jump to the beginning of the program


