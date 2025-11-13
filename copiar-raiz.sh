#!bin/bash

_uso(){
echo "
Uso bash ./$0 APP DIR_RAIZ:

Ejemplo
./$0 /bin/ps nroot"

exit 123
}

test $# -lt 2 && _uso

_APP=$1
_RAIZ=$2
test ! -x $_APP && _uso

_LD_LINUX="/lib64/ld-linux-x86-64.so.2 /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2"
_LIBS=$(ldd $_APP | awk ' NF > 2 {system("echo "$3"*")}' | xargs)

rsync -PRa -v $_APP $_LD_LINUX $_LIBS $_RAIZ
