#!/bin/sh
# bld.sh - build the programs on Linux.

if [ ! -f "lbm.sh" ]; then :
  echo "Must create 'lbm.sh' file (use 'lbm.sh.example' as guide)." >&2
  exit 1
fi

. ./lbm.sh

if [ "`uname`" = "Darwin" ]; then :
  LIBS="-L $LBM/lib -l lbm -l pthread -l m"
else : 
  LIBS="-L $LBM/lib -l lbm -pthread -l m -l rt"
fi

gcc -Wall -g -I $LBM/include -I $LBM/include/lbm -o lbmmon lbmmon.c $LIBS
if [ $? -ne 0 ]; then echo error in lbmmon.c; exit 1; fi
