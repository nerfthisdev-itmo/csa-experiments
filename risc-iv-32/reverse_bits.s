    .data
input_addr:      .word  0x80
output_addr:     .word  0x84
mask:            .word  0x00000001
bit_count:       .word  32
    .text
    .org     0x88
_start:

    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)         ;load input_addr address in t0

    lw       t0, 0(t0)                       ;load from input addr to t0 (0x80)
    lw       a0, 0(t0)                       ;load value from t0 to a0

    lui      sp, %hi(0x256)
    addi     sp, sp, %lo(0x256)
    jal      ra, reverse_bits

write_output:
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)        ;load output_addr address
    lw       t0, 0(t0)
    sw       a1, 0(t0)

    halt

reverse_bits:
    addi     sp, sp, -4                      ;allign stack
    sw       ra, 0(sp)

    lui      a2, %hi(mask)
    addi     a2, a2, %lo(mask)
    lw       a2, 0(a2)                       ;load mask

    lui      t1, %hi(bit_count)
    addi     t1, t1, %lo(bit_count)
    lw       t1, 0(t1)                       ;load bit_count

    addi     t2, zero, 1
    mv       a1, zero

reverse_loop:
    beqz     t1, return
    sll      a1, a1, t2                      ;shift result
    jal      ra, get_bit
    srl      a0, a0, t2                      ;shift input

    addi     t1, t1, -1                      ;decrement counter

    j        reverse_loop

return:
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jr       ra                              ;return

get_bit:
    and      t3, a0, a2                      ;isolate bit with mask that is loaded in a1
    add      a1, a1, t3
    jr       ra                              ;return
