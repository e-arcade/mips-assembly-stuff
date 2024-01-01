# EXAMPLE 1

0x00401000 			beq $t0, $s1, Loop
0x00401004 			...
0x00401008 			...
0x0040100C Loop: 	...

# beq rs, rt, label - I-type instruction (opcode = 4)
# beq uses PC-relative addressing (so label equals to 16-bit immediate constant)
# PC+4 = 0x00401004, BTA = 0x0040100C -> Loop = 2
machine code = 000100_01000_10001_0000000000000010

0x00401000 			beq $t7, $s4, done
					... ...
0x00402040 done: 	...

# PC+4 = 0x00401004, BTA = 0x00402040 -> done = 1039
machine code = 000100_01111_10100_0000010000001111



# EXAMPLE 2

0x00403000 			jal func
					... ...
0x0041147C func: 	...

# jal addr - J-type instruction (opcode = 3)
# jal uses pseudo-direct addressing (so label equals to addr)
# JTA (jump target address) of junc = 0x0041147C = 00000000010000010001010001111100
# discarding the 2 lsb bits and leaving only the first 26 bits, we get machine code addr
machine code = 000011_00000100000100010100011111



# EXAMPLE 3

0x00400028 			add $a0, $a1, $0  # add rd, rs, rt; R-type, funct = 32; register addressing
0x0040002C 			jal f2 # jal addr; J-type, opcode = 3;
						   # f2 = 0x00400034 => addr = 00000100000000000000001101; pseudo-direct addressing
0x00400030 f1: 		jr $ra # jr rs(reg num); R-type, funct = 8; register addressing
0x00400034 f2: 		sw $s0, 0($s2) # sw rt, imm(rs); I-type, opcode = 43; base addressing
0x00400038 			bne $a0, $0, else # bne rs, rt, label; I-type, opcode = 5; PC-relative addressing
0x0040003C 			j f1 # j addr; J-type, opcode = 2;
						 # f1 = 0x00400030 => addr = 00000100000000000000001100; pseudo-direct addressing
0x00400040 else: 	addi $a0, $a0, -1 # addi rt, rs, imm; I-type, opcode = 8; immediate addressing
0x00400044 			j f2 # j addr; J-type, opcode = 2;
						 # f2 = 0x00400034 => addr = 00000100000000000000001101; pseudo-direct addressing

0x00400028 			000000_00101_00000_00100_00000_100000
0x0040002C 			000011_00000100000000000000001101
0x00400030 f1: 		000000_11111_00000_00000_00000_001000
0x00400034 f2: 		101011_10010_10000_0000000000000000
0x00400038 			000101_00100_00000_0000000000000001
0x0040003C 			000010_00000100000000000000001100
0x00400040 else: 	001000_00100_00100_1111111111111111
0x00400044 			000010_00000100000000000000001101