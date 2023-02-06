# Vanadis

The Vanadis project aims to replace the [WonderWitch](http://wonderwitch.qute.co.jp/) "Freya" system components
with open and free variants.

The WonderWitch is a noteworthy homebrew platform from the early 2000s; however, acquiring the original hardware
is proving increasingly expensive with time. At the same time, the software components of WonderWitch are
copyrighted; and, as such, not possible to acquire in a legal manner.

At this time, Vanadis seeks to reimplement the "System" component (BIOS), which acts as an abstraction layer
on top of the WonderSwan hardware.

## Implementation status

At the moment, the Vanadis BIOS is not usable by end users.

## Directory layout

* **fonts/** - Fonts utilized by Vanadis:
  * **misaki/** - [Misaki](https://littlelimit.net/misaki.htm) by Little Limit
  * **font_ank.png** - ASCII font, derived from [Unscii](http://viznut.fi/unscii/).
* **system/** - VanadisBIOS ("System" component) source code
* **tools/** - Development/build tools
  * **ank_font_pack.py** - ASCII font data converter
  * **concat_roms.py** - .raw to .wsc concatenator
  * **convert_update.py** - binary (.raw) to/from update (.bin) converter
  * **sjis_font_pack.py** - JIS font data converter
* **Makefile** - build script

## Build instructions

### Requirements

* GNU Make
* NASM (Netwide Assembler)
* Python 3.x + Pillow library
* Binary of the "Soft" component (FreyaOS, as no free reimplementation exists)

### Acquiring "Soft" (WonderWitch Player update)

1. Download the [FreyaOS 1.2.0 update](http://wonderwitch.qute.co.jp/WWPlayer/download/fbin/freya120.bin).
2. Decode the update: `python3 tools/convert_update.py -d freya120.bin soft.raw`

### Acquiring "Soft" (WonderWitch cartridge)

1. Download "Soft" data from Freya Monitor using XMODEM transfer and the serial cable. (TODO: Document in greater detail.)
2. Decode the data: `python3 tools/convert_update.py -d soft.bin soft.raw`

### Building

1. Run `make` to build the Vanadis components. This should result in the following files:
  * `vbios.raw` - decoded VanadisBIOS build.
  * `vbios.bin` - encoded VanadisBIOS build, suitable for Freya Monitor.
2. If you need one, create a ROM image: `python3 tools/concat_roms.py vbios.raw soft.raw rom.wsc`