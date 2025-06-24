    .data

input_addr:      .word  0x80
output_addr:     .word  0x84

.org             0x88
    .text
_start:

    @p input_addr a! @
    @p output_addr b!

    reverse_string
    halt


reverse_string:
    dup
    >r
loop:
    dup
    if output_string
    @
    over

    lit -1 +
    loop ;

output_string:
    drop
    r>
    dup !b
output_loop:
    dup
    if return
    over
    !b
    lit -1 +
    output_loop ;

return:
    ;


