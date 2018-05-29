.data
    test_data: .word 2410173989
    # 1000 1111 1010 1000 0101 0110 0010 0101
.text
    la $t0, test_data
    lw $s0, 0($t0)
    # -1884793307
    lb $s1, 2($t0)
    # -88
    lbu $s2, 1($t0)
    # 86
    lh $s3, 2($t0)
    # -28760
    lhu $s4, 0($t0)
    # 20053

out:
    j out
