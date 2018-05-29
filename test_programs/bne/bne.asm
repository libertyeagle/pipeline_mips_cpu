.text
    addi $s0, $zero, 10
    move $s1, $zero

loop:
    addi $t0, $t0, 1
    add $s1, $s1, $t0
    bne $t0, $s0, loop
    
    # $s1 = 55
out:
    j out