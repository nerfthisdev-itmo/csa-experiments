\ ===== MAIN =====


.text


_start:
lit 0x80     \ адрес входной строки
@+           \ читаем длину
dup
lit 0x84
!p           \ mem[0x84] = len (новая строка)
lit 0x83
!p           \ mem[0x83] = len (вспомогательная переменная)

lit 0        \ i = 0

reverse_loop:
    dup          \ stack: i i
    lit 0x83
    @p           \ читаем len
    -            \ len - i
    if end       \ если i == len, выходим

    dup          \ дублируем i
    >r           \ сохранить i в return stack для процедуры

    call reverse_copy_byte

    r>           \ восстановить i
    lit 1
    +            \ i += 1
    jump reverse_loop

end:
    halt


\ ===== PROC reverse_copy_byte =====
\ Описание:
\ - i лежит в return stack
\ - len берём из памяти (0x83)
\ - копируем байт с addr_src = 0x80 + 1 + i
\   в       addr_dst = 0x84 + 1 + (len - 1 - i)
reverse_copy_byte:
    r>              \ i
    dup             \ stack: i i
    lit 0x80
    lit 1
    +               \ 0x81
    +               \ addr_src = 0x81 + i
    >r              \ сохранить addr_src

    lit 0x83
    @p              \ len
    lit 1
    -               \ len - 1
    swap            \ (len-1) i
    -               \ len - 1 - i
    lit 0x84
    lit 1
    +               \ 0x85
    +               \ addr_dst = 0x85 + (len - 1 - i)

    r>              \ addr_src
    dup             \ сохранить addr_src
    @p              \ val = mem[addr_src]
    swap            \ val addr_dst
    !p              \ mem[addr_dst] = val

    ;               \ return

