BUILDDIR := build
NASM := nasm
PYTHON3 := python3

ANK_FONT := fonts/font_ank.png
SJIS_FONT := fonts/misaki/misaki_gothic.png

.PHONY: all clean

all: vbios.raw vbios.bin

vbios.bin: vbios.raw
	$(PYTHON3) tools/convert_update.py vbios.raw vbios.bin

vbios.raw: system/main.asm $(BUILDDIR)/font_ank.dat $(BUILDDIR)/font_sjis.dat
	$(NASM) -M -MG -o $@ system/main.asm > build/main.d
	$(NASM) -o $@ system/main.asm

$(BUILDDIR)/font_ank.dat: $(ANK_FONT) tools/ank_font_pack.py
	@mkdir -p $(@D)
	$(PYTHON3) tools/ank_font_pack.py $(ANK_FONT) $@

$(BUILDDIR)/font_sjis.dat: $(SJIS_FONT) tools/sjis_font_pack.py
	@mkdir -p $(@D)
	$(PYTHON3) tools/sjis_font_pack.py $(SJIS_FONT) $@

clean:
	rm -r $(BUILDDIR)

-include build/main.d
