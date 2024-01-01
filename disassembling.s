# EXAMPLE 1

0x00400004    0x20090001
0x00400008    0x0089502A
0x0040000C    0x15400003
0x00400010    0x01094020
0x00400014    0x21290002
0x00400018    0x08100002
0x0040001C    0x01001020
0x00400020    0x03E00008

#             opcode   			
0x00400004    001000_00000_01001_0000000000000001 # opcode = 8 -> addi -> I-type                  # addi $t1, $0, 1
0x00400008    000000_00100_01001_01010_00000_101010 # opcode = 0 -> R-type, funct = 42 -> slt     # slt $t2, $a0, $t1
0x0040000C    000101_01010_00000_0000000000000011 # opcode = 5 -> bne -> I-type                   # bne $t2, $0, 0x0040001C
0x00400010    000000_01000_01001_01000_00000_100000 # opcode = 0 -> R-type, funct = 32 -> add     # add $t0, $t0, $t1
0x00400014    001000_01001_01001_0000000000000010 # opcode = 8 -> addi -> I-type                  # addi $t1, $t1, 2
0x00400018    000010_00000100000000000000000010 # opcode = 2 -> j -> J-type; label = addr << 2    # j 0x00400008
0x0040001C    000000_01000_00000_00010_00000_100000 # opcode = 2 -> R-type, funct = 32 -> add     # add $v0, $t0, $0
0x00400020    000000_11111_00000_00000_00000_001000 # opcode = 0 -> R-type, funct = 8 -> jr       # jr $ra

# $a0 = n
# $v0 = result
0x00400004    addi $t1, $0, 1 # $t1 = 1
0x00400008    slt $t2, $a0, $t1 # check if n < 1, $t2 = 0/1
0x0040000C    bne $t2, $0, 0x0040001C # yes: go to 0x0040001C
0x00400010    add $t0, $t0, $t1 # no: $t0 = $t0 + $t1
0x00400014    addi $t1, $t1, 2 # $t1 = 2
0x00400018    j 0x00400008 # jump to 0x00400008
0x0040001C    add $v0, $t0, $0 # $v0 = $t0
0x00400020    jr $ra # return to operation system




# EXAMPLE 2

0x00400000    0x2008001F
0x00400004    0x01044806
0x00400008    0x31290001
0x0040000C    0x0009482A
0x00400010    0xA0A90000
0x00400014    0x20A50001
0x00400018    0x2108FFFF
0x0040001C    0x1500FFF9
0x00400020    0x03E00008

#             opcode
0x00400000    001000_00000_01000_0000000000011111 # opcode = 8 -> addi -> I-type                  # addi $t0, $0, 31
0x00400004    000000_01000_00100_01001_00000_000110 # opcode = 0 -> R-type, funct = 6 -> srlv     # srlv $t1, $a0, $t0
0x00400008    001100_01001_01001_0000000000000001 # opcode = 12 -> andi -> I-type                 # andi $t1, $t1, 1
0x0040000C    000000_00000_01001_01001_00000_101010 # opcode = 0 -> R-type, funct = 42 -> slt     # slt $t1, $0, $t1
0x00400010    101000_00101_01001_0000000000000000 # opcode = 40 -> sb -> I-type                   # sb $t1, 0($a1)
0x00400014    001000_00101_00101_0000000000000001 # opcode = 8 -> addi -> I-type                  # addi $a1, $a1, 1
0x00400018    001000_01000_01000_1111111111111111 # opcode = 8 -> addi -> I=type                  # addi $t0, $t0, -1
0x0040001C    000101_01000_00000_1111111111111001 # opcode = 1 ->
0x00400020    000000_11111_00000_00000_00000_001000 # opcode = 0 -> R-type, funct = 8 -> jr       # jr $ra

# $a0 = 0x00000100 (random 32-bit number)
# $a0 = 0x45FF12CC (random address of chararray)
0x00400000    addi $t0, $0, 31 # $t0 = 31
0x00400004    srlv $t1, $a0, $t0 # $t1 = $a0 >> $t0
0x00400008    andi $t1, $t1, 1 # $t1 = $t1 & 1
0x0040000C    slt $t1, $0, $t1 # check if 0 < $t1
0x00400010    sb $t1, 0($a1) # chararray[0] = $t1
0x00400014    addi $a1, $a1, 1 # $a1 = $a1 + 1
0x00400018    addi $t0, $t0, -1 # $t0 = $t0 - 1
0x0040001C    bne $t0, $0, -7 # while $t0 != 0, go to 0x00400004 ((PC+4) - 7*4)
0x00400020    jr $ra # return to operating system