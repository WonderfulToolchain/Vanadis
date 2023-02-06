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

; VanadisBIOS

bits 16
cpu 186
org 0x0000

; WonderWitch BIOS header

	db 'E'
	db 'L'
	db 'I'
	db 'S'
	db 'A'

; Font data
	align 2
font_ank:
	incbin "build/font_ank.dat"
font_sjis:
	incbin "build/font_sjis.dat"

start:
	cli
	cld
	xor ax, ax
	mov es, ax ; Zero out ES
	; TODO: Validate SS/SP initialization
	mov ss, ax
	mov sp, 0x800

	; Initialize interrupt handlers
	push cs
	pop ds
	mov si, int_handler_ptr
	mov di, (0x10 * 4)
	mov cx, 9 * 2
	rep movsw 
	mov ds, ax ; Zero out DS

	; TODO: Validate DS/ES initialization

	; Jump to "Soft"
	jmp 0xE000:0x0000

%include "system/utils.asm"
%include "system/exception.asm"

; Interrupt handlers
%include "system/int_bank.asm"
%include "system/int_comm.asm"
%include "system/int_display.asm"
%include "system/int_exit.asm"
%include "system/int_key.asm"
%include "system/int_sound.asm"
%include "system/int_system.asm"
%include "system/int_text.asm"
%include "system/int_timer.asm"

int_handler_ptr:
	dw int_exit ; 0x10
	dw 0xf000
	dw int_key ; 0x11
	dw 0xf000
	dw int_display ; 0x12
	dw 0xf000
	dw int_text ; 0x13
	dw 0xf000
	dw int_comm ; 0x14
	dw 0xf000
	dw int_sound ; 0x15
	dw 0xf000
	dw int_timer ; 0x16
	dw 0xf000
	dw int_system ; 0x17
	dw 0xf000
	dw int_bank ; 0x18
	dw 0xf000

times 0xFFF0-($-$$) db 0xFF ; Padding

; WonderSwan ROM header

	jmp 0xf000:start
	db 0 ; Maintenance
	db 0 ; Publisher ID
	db 1 ; Color
	db 0 ; Game ID
	db 0x80 ; Game version
	db 2 ; ROM size
	db 4 ; RAM size
	db 4 ; Flags
	db 1 ; Mapper
	dw 0xFFFF ; Checksum
