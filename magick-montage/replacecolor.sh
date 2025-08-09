
ORIGINAL=white
REPLACEMENT=magenta

magick warlord-chess-graphics.bmp \
-fill $REPLACEMENT \
-opaque $ORIGINAL \
warlord-chess-graphics-without-outline.bmp
