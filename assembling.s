# EXAMPLE 1

#if (g > h)
#	g = g + h;
#else
#	g = g - h;

# have to use "slt" instruction
# $s0 = g
# $s1 = h
slt $t0, $s1, $s0
addi $t1, $0, 1
bne $t0, $t1, else
add $s0, $s0, $s1
j done
else:
sub $s0, $s0, $s1
done:



# EXAMPLE 2

#if (g >= h)
#	g = g + h;
#else
#	g = g - h;

# have to use "slt" instruction
# $s0 = g
# $s1 = h
slt $t0, $s0, $s1
bne $t0, $0, else
add $s0, $s0, $s1
j done
else:
sub $s0, $s0, $s1
done:



# EXAMPLE 3

#if (g <= h)
#	g = g + h;
#else
#	g = g - h;

# have to use "slt" instruction
# $s0 = g
# $s1 = h
slt $t0, $s1, $s0
bne $t0, $0, else
add $s0, $s0, $s1
j done
else:
sub $s0, $s0, $s1
done:



# EXAMPLE 4

#int square(int num) {
#	 return num * num;
#}

# $fp = stack frame pointer
# $a0 = num
square:
addi $sp, $sp, -8 # make room for 2 stack frames
sw $fp, 4($sp) # $fp = first stack frame
move $fp, $sp # $fp = $sp
sw $a0, 8($fp)
lw $v0, 8($fp) # $v0 = $a0
mult $v0, $v0 # $a0 * $a0
mflo $v0 # move from LO register after mul to $v0
move $sp, $fp
lw $fp, 4($sp)
addi $sp, $sp, 8
jr $ra



# EXAMPLE 5

# void setArray(int num) {
# 	int i;
# 	int array[10];
# 	for (i = 0; i < 10; i++) {
# 		array[i] = compare(num, i);
# 	}
# }

# int compare(int a, int b) {
# 	if (subb(a, b) >= 0)
# 		return 1;
# 	else
# 		return 0;
# }

# int subb(int a, int b) {
# 	return a - b;
# }

# $s0 = i
# $s1 = array
# $s2 = num
# $s3 = comparison value
addi $s0, $s0, 0
addi $s3, $0, 10
setArray: 	slt $t0, $s0, $s3 # if i < 10
			beq $t0, $0, done # no: done
			add $a0, $a0, $s2 # a = num
			add $a1, $a1, $s0 # b = i
			jal compare
			add $t0, $s1, $s0 # base array address + i
			lw $t1, 0($t0) # get array[i]
			add $t1, $t1, $v0 # $t1 = compare(num, i)
			sw $t1, 0($t0) # array[i] = compare(num, i)
			addi $s0, $s0, 1 # i = i + 1
			j setArray
# $a0 = a
# $a1 = b
compare:	jal subb # calculate $v0 = a - b
			slt $t0, $0, $v0 # if 0 < (a - b)
			bne $t0, $0 else # yes: else
			add $v0, $v0, 1 # no: return 1
else:		add $v0, $v0, 0 # return 0
			jr $ra
# $a0 = a
# $a1 = b
subb:		sub $t0, $a0, $a1
			add $v0, $0, $t0 # return a - b
			jr $ra
done:



# EXAMPLE 6

#int main() {
#   ...
#	int n, y;
#	n = 5;
#	y = factorial(n);
#	...
#}

#int factorial(int n) {
#	if (n <= 1)
#		return 1;
#	else
#		return (n * factorial(n − 1));
#}


# $s0 = y, $a0 = n
0x80 main:		addi $a0, $0, 5 # $a0 = 5
0x84			jal factorial # $ra = 0x88
0x88			add $s0, $s0, $v0 # get result from factorial function
0x8C			...
0x90 factorial: addi $sp, $sp, -8 # make room on stack
0x94 			sw $a0, 4($sp) # store argument value (n) on stack
0x98 			sw $ra, 0($sp) # store return address
0x9C 			slt $t0, $a0, 2 # if n <= 1:
OxAO 			beq $t0, $0, else # no: go to else
0xA4 			addi $v0, $0, 1 # yes: return 1
0xA8 			addi $sp, $sp, 8 # restore stack
OxAC 			jr $ra # return
OxBO else:      addi $a0, $a0, -1 # n = n - 1
0xB4 	        jal factorial	
0xB8            lw $a0, 4($sp)
OxBC			lw $ra, 0($sp)
OxCO			addi $sp, $sp, 8 
0xC4			mul $v0, $v0, $a0 # return n * factorial(n-1)
0xC8 			jr $ra



# EXAMPLE 7

#int fib(int n) {
#	if (n == 0) 
#		return 0;
#	else if (n == 1)
#		return 1;
#	else return fib(n-1) + fib(n-2);
#}

# $s0 = n
# $v0 = result
addi $t0, $0, 1 # comparison value for bne = 1
addi $s0, $0, 4 # n = 8
addi $v0, $0, 0 # general result
fib:		addi $sp, $sp, -8 # make room on stack for $ra register
			sw $s0, 4($sp) # store n on stack
			sw $ra, 0($sp) # store $ra on stack
			bne $s0, $0, else_if
			addi $t1, $0, 0
			addi $sp, $sp, 8
			jr $ra
else_if: 	bne $s0, $t0, else
			addi $t2, $0, 1
			addi $sp, $sp, 8
			jr $ra
else:		addi $s0, $s0, -1 # n = n - 1
			jal fib
			addi $s0, $s0, -1 # n = n - 1
			jal fib
			lw $s0, 4($sp) # restore n from stack
			lw $ra, 0($sp) # restore $ra from stack
			add $v0, $v0, $t1 # $t1 = $t1 + f(n-2)
			add $v0, $v0, $t2 # $t1 = $t1 + f(n-1)
			addi $t1, $0, 0 # reset $v0
			addi $t2, $0, 0 # reset $v1
			addi $sp, $sp, 8
			jr $ra



# EXAMPLE 8

#int find42(int array[], int size) {
#   int result = -1;
#	for (int i = 0; i < size; i++)
#		if (array[i] == 42) {
#			result = i + 1;
#			break;
#		}
#	
#	return result;
#}


# $s0 = i
# $s1 = comparing value
# $a0 = array
# $a1 = size
# $v0 = result
addi $s0, $0, 0
addi $s1, $0, 42
addi $v0, $0, -1
for:
	slt $t0, $s0, $a1 # $t0 = result of comparing
	beq $t0, $0 not_found # if i >= 42
	add $t1, $a0, $s0 # $t1 = array base address + i
	lw $t2, 0($t1) # $t2 = array[i]
	beq $t2, $s1 done # check if array[i] == 42
	addi $s0, $s0, 1 # i = i + 1
	j for

done:
	addi $s0, $s0, 1 # i = i + 1
	addi $v0, $s0, $0 # $v0 = i
not_found:
