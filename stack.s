# $sp (stack pointer) - starts at a high memory address and decrements to expand as needed

#int main() {
#	int y;
#	...
#	y = diffofsums(2, 3, 4, 5);
#	...
#}

#int diffofsums(int f, int g, int h, int i) {
#	int result;
#	result = (f + g) - (h + i);
#	return result;
#}

# $s0 = result
diffofsums:	addi $sp, $sp, -12 # make space on stack to store three registers
			sw $s0, 8($sp) # save $s0 on stack (0x0..08 - 0x0..0C)
			sw $t0, 4($sp) # save $t0 on stack (0x0..04 - 0x0..08)
			sw $t1, 0($sp) # save $t1 on stack (0x0..00 - 0x0..04)
			add $t0, $a0, $a1 # $t0 = f + g
			add $t1, $a2, $a3 # $t1 = h + i
			sub $s0, $t0, $t1 # result = (f + g) − (h + i)
			add $v0, $s0, $0 # put return value in $v0
			lw $t1, 0($sp) # restore $t1 from stack
			lw $t0, 4($sp) # restore $t0 from stack
			lw $s0, 8($sp) # restore $s0 from stack
			addi $sp, $sp, 12 # deallocate stack space
			jr $ra # return to caller


# a further improved version of diffofsums that saves only $s0 on the stack. 
# $t0 and $t1 are nonpreserved registers, so they need not be saved.

# $s0 = result
diffofsums:	addi $sp, $sp, -12 # make space on stack to store three registers
			sw $s0, 8($sp) # save $s0 on stack
			add $t0, $a0, $a1 # $t0 = f + g
			add $t1, $a2, $a3 # $t1 = h + i
			sub $s0, $t0, $t1 # result = (f + g) − (h + i)
			add $v0, $s0, $0 # put return value in $v0
			lw $s0, 8($sp) # restore $s0 from stack
			addi $sp, $sp, 12 # deallocate stack space
			jr $ra # return to caller