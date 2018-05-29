.text
    addi $s0, $zero, 10
    move $s1, $zero

loop:
    add $s1, $s1, $s0
    addi $s0, $s0, -1
    bgez $s0, loop
    
    # $s1 = 55
out:
    j out