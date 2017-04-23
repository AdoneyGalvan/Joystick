.Global  main
    .include "SPI.s"
    .include "UART2.s"
    .include "UART1.s"
.Data
    char_num: .byte 0,0,0,0
    x_label: .asciiz "X:"
    y_label: .asciiz "Y:"
    clear_disp2: .byte 0x1B, '[', 'j', 0x00
.Text
.ent main
    main:
    JAL setup_UART2
    JAL setup_SPI
    JAL setup_timer_1
    LA $a0, clear_disp2
    JAL send_char_arr_to_UART2
    
    while:
    JAL JOYSTICK
    J while
.end main

.ent convert_to_ascii
    convert_to_ascii:
    ADDI $sp, $sp, -4
    SW $ra, 0($sp)
    
    LI $t6, 10
    DIV $a1, $t6
    LA $t0, char_num
    MFHI $t1
    ADDI $t1, $t1, 48
    SB $t1, 3($t0)
    MFLO $a1

    DIV $a1, $t6
    LA $t0, char_num
    MFHI $t1
    ADDI $t1, $t1, 48
    SB $t1, 2($t0)
    MFLO $a1

    DIV $a1, $t6
    LA $t0, char_num
    MFHI $t1
    ADDI $t1, $t1, 48
    SB $t1, 1($t0)
    MFLO $a1

    DIV $a1, $t6
    LA $t0, char_num
    MFHI $t1
    ADDI $t1, $t1, 48
    SB $t1, 0($t0)
    MFLO $a1
    
    LW $ra, 0($sp)
    ADDI $sp, $sp, 4
    JR $ra
.end convert_to_ascii

  .ent JOYSTICK
    JOYSTICK:
    ADDI $sp, $sp, -4
    SW $ra, 0($sp)
    
    JAL send_spi
    
    MOVE $a1, $v0 # x data
    JAL convert_to_ascii
    LA $a0, x_label
    JAL send_char_arr_to_UART2
    LA $a0, char_num
    JAL send_char_arr_to_UART2
    
    MOVE $a1, $v1 # y data
    JAL convert_to_ascii
    LA $a0, y_label
    JAL send_char_arr_to_UART2
    LA $a0, char_num
    JAL send_char_arr_to_UART2
    
    LW $ra, 0($sp)
    ADDI $sp, $sp, 4
   .end JOYSTICK