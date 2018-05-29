.text
    addi $s0, $zero, 10
    move $t0, $zero
    move $s1, $zero

    la $t1, loop

loop:
    beq $t0, $s0, out
    addi $t0, $t0, 1
    add $s1, $s1, $t0
    jr $t1

    # $s1 = 55
out:
    j out