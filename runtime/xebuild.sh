./stop.sh
set -e
acme -f cbm --cpu m65 -o main.prg -r main.lst main.asm
../bin/xmega65.native -prg main.prg -besure
rm -f dump.bin


