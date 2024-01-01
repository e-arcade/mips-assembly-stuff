#void strcpy(char dst[], const char src[]) {
#	int i = 0;
#	do {
#		dst[i] = src[i];
# 	} while (src[i++]);
#}

# char* strcpy(char *dest, const char *src) {
#       char *tmp = dest;
#       while (*src != '\0') {
#               *dest++ = *src++;
#       }
#       *dest = '\0';
#       return tmp;
# }


# $s0 = i
# $a0 = dst
# $a1 = src
# $t0 = '\0'
strcpy: addi $sp, $sp, -4 # make room for two frames
        sw $a0, 0($sp) # store base dst address on stack
        add $t0, $a1, $s0 # $t0 = base src address + i
        lb $t1, 0($t0) # $t1 = src[i]
        beq $t1, $0, done # if src[i] == '\0', exit
        add $t0, $a0, $s0 # dst = dst + i
        sb $t1, 0($t0) # dst[i] = src[i]
        addi $s0, $s0, 1 # i = i + 1
        j strcpy
done:   lw $a0, 0($sp) # restore base dst address from stack
        addi $sp, $sp, 4 # deallocate stack space
        add $v0, $0, $a0 # $v0 = base dst address
        jr $ra # return to operating system


# strcpy:
#         addiu   $sp,$sp,-24
#         sw      $fp,20($sp)
#         move    $fp,$sp
#         sw      $4,24($fp)
#         sw      $5,28($fp)
#         sw      $0,8($fp)
# $L2:
#         lw      $2,8($fp)
#         lw      $3,28($fp)
#         addu    $3,$3,$2
#         lw      $2,8($fp)
#         lw      $4,24($fp)
#         addu    $2,$4,$2
#         lb      $3,0($3)
#         sb      $3,0($2)
#         lw      $2,8($fp)
#         addiu   $3,$2,1
#         sw      $3,8($fp)
#         move    $3,$2
#         lw      $2,28($fp)
#         addu    $2,$2,$3
#         lb      $2,0($2)
#         bne     $2,$0,$L2
#         move    $sp,$fp
#         lw      $fp,20($sp)
#         addiu   $sp,$sp,24
#         jr      $31

