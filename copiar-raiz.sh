#!bin/bash
_APP=${1:-/bin/bash}
_LIBS=$(ldd $_APP | awk ' NF > 2 {system("echo "$3"*")}' | xargs)
_RAIZ=${2:-raiz}
rsync -PRan $_APP $_LIBS $_RAIZ
