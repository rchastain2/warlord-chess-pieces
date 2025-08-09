
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

cd ../lazarus-txt2bmp

magick montage \
-tile 6x2 \
-geometry +0+0 \
wp.bmp wr.bmp wn.bmp wb.bmp wq.bmp wk.bmp \
bp.bmp br.bmp bn.bmp bb.bmp bq.bmp bk.bmp \
$SCRIPT_DIR/warlord-chess-graphics.bmp
