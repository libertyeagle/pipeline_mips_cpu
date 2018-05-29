.text
    addi $s0, $zero, 1
    sll $s0, $s0, 3
    # $s0 = 8
    addi $s1, $zero, 2
    sllv $s0, $s0, $s1
    # $s0 = 32

    addi $s2, $zero, 512
    srl $s2, $s2, 2
    # $s2 = 128
    addi $s3, $zero, 1
    srlv $s2, $s2, $s3
    # $s2 = 64

    addi $t0, $zero, -512
    sra $t0, $t0, 2
    # $t0 = -128
    addi $t1, $zero, 1
    srav $t0, $t0, $t1
    # $t0 = -64

    # final result:
    # $t0 = -64, $s0 = 32, $s2 = 64
out:
    j out