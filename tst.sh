#!/bin/sh
# tst.sh

if [ ! -f "lbm.sh" ]; then :
  echo "Must create 'lbm.sh' file (use 'lbm.sh.example' as guide)." >&2
  exit 1
fi

. ./lbm.sh

rm -rf cache state *.log *.pid *.out
mkdir cache
mkdir state

lbmrd lbmrd.xml >lbmrd.log 2>&1 &
LBMRD_PID="$!"; echo "LBMRD_PID=$LBMRD_PID"

# Create sqlite database.
rm -f mcs.db
sqlite3 mcs.db <$L/MCS/bin/ummon_db.sql

MCS mcs.xml >mcs.log 2>&1 &
# Wait up to 5 seconds for MCS to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "mcs.pid" ]; then sleep 1; fi
done
if [ ! -f "mcs.pid" ]; then echo "mcs fail?" >&2; kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID; exit 1; fi
MCS_PID="`cat mcs.pid`"; echo "MCS_PID=$MCS_PID"

SRS srs.xml >srs.log 2>&1 &
# Wait up to 5 seconds for SRS to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "srs.pid" ]; then sleep 1; fi
done
if [ ! -f "srs.pid" ]; then echo "SRS fail?" >&2; kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID; exit 1; fi
SRS_PID="`cat srs.pid`"; echo "SRS_PID=$SRS_PID"

tnwgd dro.xml >dro.log 2>&1 &
# Wait up to 5 seconds for DRO to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "dro.pid" ]; then sleep 1; fi
done
if [ ! -f "dro.pid" ]; then echo "DRO fail?" >&2; kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID; exit 1; fi
DRO_PID="`cat dro.pid`"; echo "DRO_PID=$DRO_PID"
sleep 1

umestored store.xml >store.log 2>&1 &
# Wait up to 5 seconds for Store to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "store.pid" ]; then sleep 1; fi
done
if [ ! -f "store.pid" ]; then echo "Store fail?" >&2; kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID; exit 1; fi
STORE_PID="`cat store.pid`"; echo "STORE_PID=$STORE_PID"
sleep 3

LBM_XML_CONFIG_APPNAME=umesrc LBM_XML_CONFIG_FILENAME=um.xml umesrc -d 1 -l 700 -M 30 -P 1000 -L 6 topic1 >umesrc.log 2>&1 &
UMESRC_PID="$!"; echo "UMESRC_PID=$UMESRC_PID"

trap "kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID $UMESRC_PID; exit 1" 1 2 3 15

sleep 6

LBM_XML_CONFIG_APPNAME=umercv LBM_XML_CONFIG_FILENAME=um.xml umercv -v -v topic1 >umercv.log 2>&1 &
UMERCV_PID="$!"; echo "UMERCV_PID=$UMERCV_PID"

echo "wait $UMESRC_PID"
wait $UMESRC_PID

sleep 36

echo "kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID"
kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID

sqlite3 mcs.db <<__EOF__ >mcs.out
select * from umsmonmsg;
select * from umpmonmsg;
select * from dromonmsg;
select * from srsmonmsg;
__EOF__
