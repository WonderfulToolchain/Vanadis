; Copyright (c) 2023 Adrian "asie" Siekierka
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

int_display:
    cmp ah, 0x00
    je int_display_control

    cmp ah, 0x01
    je int_display_status

    cmp ah, 0x0B
    je int_display_sprite_set_range

    cmp ah, 0x15
    je int_display_screen2_set_window

    cmp ah, 0x17
    je int_display_sprite_set_window

    cmp ah, 0x19
    je int_display_palette_set_color

    cmp ah, 0x1A
    je int_display_palette_get_color

    cmp ah, 0x1B
    je int_display_lcd_set_color

    cmp ah, 0x1D
    je int_display_lcd_set_segments
    
    push 0x12
    jmp exc_dump

int_display_control:
    push ax
    mov ax, bx
    out IO_DISPLAY_CTRL, ax
    pop ax
    iret

int_display_status:
    in ax, IO_DISPLAY_CTRL
    iret

int_display_sprite_set_range:
    push ax
    mov al, bl
    out IO_SPR_FIRST, al
    mov al, cl
    out IO_SPR_COUNT, al
    pop ax
    iret

int_display_screen2_set_window:
    push ax
    push cx
    mov ax, bx
    out IO_SCR2_WIN_X1, ax
    add bl, cl
    add bh, ch
    dec cl ; TODO: Is this subtraction correct?
    dec ch
    out IO_SCR2_WIN_X2, ax
    pop cx
    pop ax
    iret

int_display_sprite_set_window:
    push ax
    push cx
    mov ax, bx
    out IO_SPR_WIN_X1, ax
    add bl, cl
    add bh, ch
    dec cl ; TODO: Is this subtraction correct?
    dec ch
    out IO_SPR_WIN_X2, ax
    pop cx
    pop ax
    iret

int_display_palette_set_color:
    push ax
    push dx
    mov dx, bx
    mov ax, cx
    shl bx, 1
    add bx, IO_SCR_PAL_0
    out dx, ax
    pop dx
    pop ax
    iret    

int_display_palette_get_color:
    push dx
    mov dx, bx
    shl bx, 1
    add bx, IO_SCR_PAL_0
    in ax, dx
    pop dx
    iret

int_display_lcd_set_color:
    push ax
    mov ax, bx
    out IO_LCD_SHADE_01, ax
    mov ax, cx
    out IO_LCD_SHADE_45, ax
    pop ax
    iret

int_display_lcd_set_segments:
    push ax
    mov al, bl
    out IO_LCD_SEG, al
    pop ax
    iret