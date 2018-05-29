.text
    addi $s0, $zero, 20
    addi $s1, $zero, 24
    slt $t0, $s0, $s1
    # $t0 = 1

    addi $s0, $zero, -1
    sltu $t1, $s0, $s1
    # $t1 = 0

    slti $t2, $s1, 5
    # $t2 = 0

    sltiu $t3, $s1, -1
    # $t3 = 1

out:
    j out