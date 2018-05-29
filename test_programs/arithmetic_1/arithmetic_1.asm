.text
    addi $s1, $zero, 1
    addi $s0, $zero, 4
    add $s0, $s0, $s1
    # $s0 = 5
    add $s0, $s0, $s0
    # $s0 = 10
    add $s0, $s0, $s0
    # $s0 = 20
    addu $s1, $s0, $s1
    # $s1 = 21
    addi $s1, $s1, 7
    # $s1 = 28
    addiu $s1, $s1, 8
    # $s1 = 36
    sub $s2, $s1, $s0
    # $s2 = 16
    subu $s3, $s0, $s2
    # $s3 = 4

    addi $t0, $zero, 167
    # 1010 0111
    addi $t1, $zero, 77
    # 0100 1101
    xor $t0, $t0, $t1
    # 1110 1010
    # $t0 = 234
    xori $t0, $t0, 64
    # 64 = 0100 0000
    # 1010 1010
    # $t0 = 170
    and $t1, $t0, $t1
    # 0000 1000
    # $t1 = 8
    andi $t1, $t1, 1
    # $t1 = 0
    or $t1, $t1, $t0
    # $t1 = 170
    ori $t0, $t1, 50
    # 50 = 1011 1010
    # $t0 = 186
    nor $t2, $t0, $t1
    # $t2 = 4294967109

    # final result:
    # $s0 = 20, $s1 = 36, $s2 = 16, $s3 = 4
    # $t0 = 186, $t1 = 170, $t2 = 4294967109
out:
    j out