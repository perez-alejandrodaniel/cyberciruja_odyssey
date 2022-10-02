;------------------------------------------------------------------------------
;
;                                                        +-------------------+
;	                                                     |     | |     |     |
;	                                                     |     | |     |     |
;	                                                     |     +-------+     |
;	San Floppy, a cyberciruja odyssey                    |                   |
;	                                                     |     #       #     |
;	                                                     |                   |
;   Demo 256 bytes intro for the glorious                |        ---        |
;           Magnabox Odyssey 2	                         |                  .|
;	                                                     +-------------------+
;
;------------------------------------------------------------------------------
;
; <-<- Flashparty 2022 - 256 bytes intro by Ale Perez
; Platform: Magnabox Odyssey 2 (Philips Videopac PAL) (MCS-48 assembler).
;
; Software:
;   * Compiler ASW 1.42 to compile
;   * Emulator "o2em"
;

    cpu    8048
    org    400h

    ; thanks Soeren Gust for this file!
    include    "g7000.h"

; internal RAM vars
frame_skip                      equ     10
counter                         equ     010h             ;frame counter
init_pattern                    equ     00010001b
background_pattern              equ     011h

;we can't show more than 12 chars at same time (without tricks)
message_size                    equ     12
message_pos_x                   equ     012h
message_pos_y                   equ     013h

; Following lines are part of the "normal" boot of the common carts
    jmp selectgame  ; first screen
    jmp irq         ; interrupt
    jmp timer       ; timer
    jmp vsyncirq    ; VSYNC-interrupt
    jmp start       ; the start of the program
    jmp soundirq    ; sound-interrupt
    
timer
    ret
    ; no used but this must be accounted for or else it won't work.

start
    ; we don't want to modify anything while the image is displayed
    call gfxoff

    ; setup of the first sprite
    mov r0, #vdc_spr0_ctrl
    mov a, #060h                  ; y position
    movx @r0, a                    
    inc r0                        ; change to x position data register
    mov a, #050h                  ; x position
    movx @r0, a                   ; update the x position register
    inc r0                        ; change to color register
    call set_color
    
    mov r0, #vdc_spr0_shape       ; take the address of first part of 
                                  ;the shape
    mov r1, #diskette_head_left & 0ffh    ; use the cyberciruja diskette shape
    call set_figure                       ; use the "set_figure" subroutine

    ; Repeat the process for other parts of the diskette
    ; second part
    mov r0, #vdc_spr1_ctrl
    mov a, #060h
    movx @r0, a
    inc r0
    mov a, #050h - 16
    movx @r0, a    
    inc r0            
    call set_color

    mov r0, #vdc_spr1_shape                
    mov r1, #diskette_head_rigth & 0ffh    
    call set_figure                    

    ; third part
    mov r0, #vdc_spr2_ctrl
    mov a, #060h + 22
    movx @r0, a
    inc r0
    mov a, #050h
    movx @r0, a
    inc r0    
    call set_color

    ; last part
    mov r0, #vdc_spr2_shape                    
    mov r1, #diskette_bottom_left & 0ffh        
    call set_figure                        

    mov r0, #vdc_spr3_ctrl                    
    mov a, #060h + 22                        
    movx @r0, a
    inc r0
    mov a, #050h - 16                        
    movx @r0, a
    inc r0
    call set_color


    mov r0, #vdc_spr3_shape                    
    mov r1, #diskette_bottom_rigth & 0ffh    
    call set_figure                        

    ; copy parameters of the message from program ROM to internal RAM
    mov r0, #message_pos_x
    mov @r0, #0A0h
    mov r0, #message_pos_y
    mov @r0, #020h


; GRID (background)
    ; set block fill mode for grid
    mov r0, #vdc_control
    mov a, #vdc_ctrl_fill
    movx @r0, a

    mov r0, #background_pattern         
    mov @r0, #init_pattern

    mov r0, #counter
    mov @r0, #frame_skip
    mov a, #frame_skip

main:
    call waitvsync          ; we need to wait until the beggining of the frame

    call gfxoff

    mov r0, #counter        ; slow down grid updates
    mov a, @r0
    dec a
    mov @r0, a

    jnz paint_message       ; I don't want to update the background always

    mov r0, #counter        ; ok, I continue to update the background
    mov @r0, #frame_skip

set_grid:
    mov r2, #9                     ; columns count
    mov r0, #background_pattern    ; current pattern address    
    mov a, @r0
    mov r1, #vdc_gridv0            ; first column to update

next_column:
    movx @r1, a                    ; move the pattern of the column to vdc
    rr a                           ; I shift the pattern to produce the effect
    inc r1                         ; move to the next column
    djnz r2,next_column            ; until all columns are updated

    mov @r0, a                     ; save the last pattern

    mov r0, #vdc_color             ; set a color for the grid. color register.
    anl a, #007h                   ; I don't want a black foreground
    jnz paint_grid
    inc a                          ; if it's black, I chose the next color

paint_grid:    
    movx @r0, a                    ; change the color

paint_message:
    mov r0, #message_pos_x
    mov a, @r0
    mov r3, a
    mov r0, #message_pos_y
    mov a, @r0
    mov r4, a    
    mov r0, #vdc_char0
    mov r1, #message & 0FFh
    mov r2, #message_size

print_char_loop:
    mov a, r1                     ; complete params of BIOS call
    movp a, @a
    mov r5, a
    inc r1
    mov r6, #col_chr_white
    call printchar                ; print it
    djnz r2, print_char_loop
    
    mov r0, #message_pos_x        ; move the message to left
    mov a, @r0
    dec a
    mov @r0, a
    add a, # -10h
    jb6 move_one_row
    jmp same_row

move_one_row:
    mov r0, #message_pos_y
    mov a, @r0
    inc a
    mov @r0, a

same_row:
    call gfxon

    jmp main

set_figure
    mov  r7, #8                        ; how many rows?
copy_sprite_data:
    mov  a, r1
    movp a, @a
    movx @r0, a
    inc r0                         ; increase for repeating process
    inc r1                         ; increase for repeating process
    djnz r7, copy_sprite_data      ; if it is before r7 (8) then repeat process
    ret

set_color
    mov a, #col_spr_green        ; the color of the sprite
    orl a, #00000100b
    movx @r0, a                  ; put it in that position
    ret


; ================= DATA ===================
message:
    db        03Dh
    db        028h
    db        01Bh
    db        00Eh
    db        020h
    db        019h
    db        01Dh
    db        00Fh
    db        020h
    db        013h
    db        014h
    db        02Ch

diskette_head_left:
    db        11111111b
    db        10100000b
    db        10100000b
    db        10100000b
    db        10100000b
    db        10111111b
    db        10000000b
    db        10000000b

diskette_head_rigth:
    db        11111111b
    db        00000101b
    db        00010101b
    db        00010101b
    db        00000101b
    db        11111101b
    db        00000001b
    db        00000001b

diskette_bottom_left:
    db        10000000b
    db        10001100b
    db        10001100b
    db        10000000b
    db        10000000b
    db        10000011b
    db        10000000b
    db        11111111b

diskette_bottom_rigth:
    db        00000001b
    db        00110001b
    db        00110001b
    db        00000001b
    db        00000001b
    db        11000001b
    db        00000001b
    db        11111111b
