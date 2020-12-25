./stop.sh
set -e
acme  --cpu m65 -o main.prg -r main.lst main.asm
./m65 -F -r main.prg

