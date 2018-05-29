.data
    store_data: .word
.text
    addi $s0, $zero, 82
    # 0101 0010
    la $t0, store_data
    sb $s0, 0($t0)
    sb $s0, 1($t0)
    sh $s0, 2($t0)
    # 5395026
out:
    j out