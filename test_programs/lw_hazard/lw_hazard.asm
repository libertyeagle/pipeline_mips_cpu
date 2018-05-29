.data
    test_data: .word 155
.text
    la $t0, test_data
    lw $s0, 0($t0)
    addi $s0, $s0, 2
    # s0 = 157

out:
    j out
