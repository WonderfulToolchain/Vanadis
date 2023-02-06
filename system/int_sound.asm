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

int_sound:
    cmp ah, 0x06
    je int_sound_set_pitch

    cmp ah, 0x07
    je int_sound_get_pitch

    cmp ah, 0x08
    je int_sound_set_volume

    cmp ah, 0x09
    je int_sound_get_volume

    cmp ah, 0x0C
    je int_sound_set_noise

    cmp ah, 0x0D
    je int_sound_get_noise

    cmp ah, 0x0E
    je int_sound_get_random

    push 0x15
    jmp exc_dump

int_sound_set_pitch:
    push ax
    push dx
    mov dx, IO_SND_FREQ_CH1
    add dl, al
    add dl, al
    mov ax, bx
    out dx, ax
    pop dx
    pop ax
    iret

int_sound_get_pitch:
    push dx
    mov dx, IO_SND_FREQ_CH1
    add dl, al
    add dl, al
    in ax, dx
    pop dx
    iret

int_sound_set_volume:
    push ax
    push dx
    mov dx, IO_SND_VOL_CH1
    add dl, al
    mov al, bl
    out dx, al
    pop dx
    pop ax
    iret

int_sound_get_volume:
    push dx
    mov dx, IO_SND_VOL_CH1
    add dl, al
    in al, dx
    pop dx
    iret

int_sound_set_noise:
    push ax
    mov al, bl
    out IO_SND_NOISE_CTRL, al
    pop ax
    iret

int_sound_get_noise:
    in al, IO_SND_NOISE_CTRL
    iret

int_sound_get_random:
    in ax, IO_SND_RANDOM
    iret