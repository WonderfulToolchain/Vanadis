#!/usr/bin/env python3
#
# Copyright (c) 2023 Adrian "asie" Siekierka
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from PIL import Image
import argparse
import struct
import sys

# -- Format --
#
# uint16_t data_length; // excluding self
# /* row headers */
# uint16_t end = 0x0000;
# /* row data */
#
# -- Row headers --
# Each row header marks the beginning of a given set of characters.
#
# uint8_t jis_0208_high;
# uint8_t jis_0208_low;
# uint16_t glyph_index; // index in row_data >> 3
#
# -- Row data --
# Row data is 8x8 1BPP glyphs.

parser = argparse.ArgumentParser(
    prog = 'sjis_font_pack',
    description = 'PNG to WonderWitch-format JIS font converter'
)
parser.add_argument('input')
parser.add_argument('output')
args = parser.parse_args()

jis_whitespace = {
    0x2121: True
}

# Read PNG glyph data, removing empty rows.
rows = []
glyph_index = 0
last_glyph_x = 0
last_glyph_y = 0

im = Image.open(args.input).convert("RGBA")
glyph_width = int(im.size[0] / 8)
glyph_height = int(im.size[1] / 8)

for iy in range(0, glyph_height):
    cy = 0x21 + iy
    current_row = None

    for ix in range(0, glyph_width):
        cx = 0x21 + ix
        has_data = ((cx << 8) | cy) in jis_whitespace
        row_data = []
        for gy in range(0, 8):
            b = 0
            for gx in range(0, 8):
                pxl = im.getpixel((ix*8+gx, iy*8+gy))
                if pxl[0] < 128:
                    b = b | (0x80 >> gx)
            row_data.append(b)
            if b != 0:
                has_data = True

        if not has_data:
            if current_row is not None:
                rows.append(current_row)
                current_row = None
            continue

        if current_row is None:
            current_row = {"x": cx, "y": cy, "i": glyph_index, "d": []}
        
        current_row["d"] += row_data
        glyph_index += 1
        last_glyph_x = cx
        last_glyph_y = cy

    if current_row is not None:
        rows.append(current_row)
        current_row = None

# Write glyph data.
with open(args.output, "wb") as fout:
    data_length = (glyph_index * 8) + (len(rows) * 4) + 2
    fout.write(struct.pack("<H", data_length))
    for row in rows:
        fout.write(struct.pack("<BBH", row["x"], row["y"], row["i"]))
    fout.write(struct.pack("<H", 0))
    for row in rows:
        fout.write(bytes(row["d"]))


