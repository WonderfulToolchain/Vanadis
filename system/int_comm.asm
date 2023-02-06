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

int_comm:
    cmp ah, 0x00
    je int_comm_open

    cmp ah, 0x01
    je int_comm_close

    cmp ah, 0x09
    je int_comm_set_baudrate

    cmp ah, 0x0A
    je int_comm_get_baudrate

    push 0x14
    jmp exc_dump

int_comm_open:
    push ax
    in al, IO_SERIAL_STATUS
    or al, SERIAL_ENABLE | SERIAL_OVERRUN_RESET
    out IO_SERIAL_STATUS, al
    pop ax
    iret

int_comm_close:
    push ax
    in al, IO_SERIAL_STATUS
    and al, ~SERIAL_ENABLE
    out IO_SERIAL_STATUS, al
    pop ax
    iret

int_comm_set_baudrate:
    push ax
    mov ah, bl
    shl ah, 6
    in al, IO_SERIAL_STATUS
    and al, ~SERIAL_BAUD_38400
    or al, ah
    out IO_SERIAL_STATUS, al
    pop ax
    iret

int_comm_get_baudrate:
    xor ah, ah
    in al, IO_SERIAL_STATUS
    shr al, 6
    and al, 0x01
    iret