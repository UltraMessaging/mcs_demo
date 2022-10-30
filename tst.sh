#!/bin/sh
# tst.sh

kill_pids()
{
  echo "`date` kill $LBMRD_PID $MCS_PID $LBMMON_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID $UMESRC_PID"
  kill $LBMRD_PID $MCS_PID $LBMMON_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID $UMESRC_PID
}

if [ ! -f "lbm.sh" ]; then :
  echo "Must create 'lbm.sh' file (use 'lbm.sh.example' as guide)." >&2
  exit 1
fi

. ./lbm.sh

javac -cp $L/MCS/lib/java-getopt-1.0.13.jar:$LBMJ/UMS_6.15.jar:$LBMJ/UMSMON_PROTO2_6.15.jar:$LBMJ/UMSMON_PROTO3_6.15.jar:$L/MCS/lib/protobuf-java-4.0.0-rc-2.jar:$L/MCS/lib/protobuf-java-util-4.0.0-rc-2.jar lbmmon.java >javac.log 2>&1
if [ "$?" -ne 0 ]; then echo "`date` Error, see javac.log" >&2; exit 1; fi

rm -rf cache state *.log *.pid *.out
mkdir cache
mkdir state

trap "kill_pids; exit 1" 1 2 3 15

# Create sqlite database for MCS.
rm -f mcs.db
echo "`date` sqlite3 mcs.db <$L/MCS/bin/ummon_db.sql >sqlite.log"
sqlite3 mcs.db <$L/MCS/bin/ummon_db.sql >sqlite.log 2>&1
if [ "$?" -ne 0 ]; then echo "`date` Error, see sqlite.log" >&2; exit 1; fi

# Unicast topic resolution using "lbmrd" for monitoring TRD.
lbmrd lbmrd.xml >lbmrd.log 2>&1 &
LBMRD_PID="$!"; echo "`date` LBMRD_PID=$LBMRD_PID"

# Start Monitoring Collector Service (MCS)
MCS mcs.xml >mcs.log 2>&1 &
# Wait up to 5 seconds for MCS to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "mcs.pid" ]; then sleep 1; fi
done
if [ ! -f "mcs.pid" ]; then echo "`date` mcs fail?" >&2; kill_pids; exit 1; fi
MCS_PID="`cat mcs.pid`"; echo "`date` MCS_PID=$MCS_PID"

# Start "lbmmon" java example application
java -cp .:$L/MCS/lib/java-getopt-1.0.13.jar:$LBMJ/UMS_6.15.jar:$LBMJ/UMSMON_PROTO2_6.15.jar:$LBMJ/UMSMON_PROTO3_6.15.jar:$L/MCS/lib/protobuf-java-4.0.0-rc-2.jar:$L/MCS/lib/protobuf-java-util-4.0.0-rc-2.jar lbmmon --transport-opts="config=mon.cfg" --format=pb --format-opts="passthrough=convert" >lbmmon.log 2>&1 &
LBMMON_PID="$!"; echo "`date` LBMMON_PID=$LBMMON_PID"

# Start Stateful Resolver Service (SRS)
SRS srs.xml >srs.log 2>&1 &
# Wait up to 5 seconds for SRS to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "srs.pid" ]; then sleep 1; fi
done
if [ ! -f "srs.pid" ]; then echo "`date` SRS fail?" >&2; kill_pids; exit 1; fi
SRS_PID="`cat srs.pid`"; echo "`date` SRS_PID=$SRS_PID"

# Start Dynamic Routing Option (DRO, a.k.a. tnwgd).
tnwgd dro.xml >dro.log 2>&1 &
# Wait up to 5 seconds for DRO to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "dro.pid" ]; then sleep 1; fi
done
if [ ! -f "dro.pid" ]; then echo "`date` DRO fail?" >&2; kill_pids; exit 1; fi
DRO_PID="`cat dro.pid`"; echo "`date` DRO_PID=$DRO_PID"
sleep 1

# Start persistence Store.
umestored store.xml >store.log 2>&1 &
# Wait up to 5 seconds for Store to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "store.pid" ]; then sleep 1; fi
done
if [ ! -f "store.pid" ]; then echo "`date` Store fail?" >&2; kill_pids; exit 1; fi
STORE_PID="`cat store.pid`"; echo "`date` STORE_PID=$STORE_PID"
sleep 3

# Start publisher
LBM_XML_CONFIG_APPNAME=umesrc LBM_XML_CONFIG_FILENAME=um.xml umesrc -d 1 -l 700 -M 30 -P 1000 -L 6 topic1 >umesrc.log 2>&1 &
UMESRC_PID="$!"; echo "`date` UMESRC_PID=$UMESRC_PID"

# Wait a bit so that subscriber has to recover messages from Store.
echo "`date` sleep 6"
sleep 6

# Start subscriber
LBM_XML_CONFIG_APPNAME=umercv LBM_XML_CONFIG_FILENAME=um.xml umercv -v -v topic1 >umercv.log 2>&1 &
UMERCV_PID="$!"; echo "`date` UMERCV_PID=$UMERCV_PID"

# Wait for publisher to complete.
echo "`date` wait $UMESRC_PID"
wait $UMESRC_PID
unset UMESRC_PID

# Wait for subscriber to time out the publisher.
echo "`date` sleep 36"
sleep 36

kill_pids

# Give sqlite a chance to gracefully close tables.
echo "`date` sleep 2"
sleep 2

# Extract monitoring data from MCS database.
sqlite3 mcs.db <<__EOF__ >mcs.out 2>&1
select * from umsmonmsg;
select * from umpmonmsg;
select * from dromonmsg;
select * from srsmonmsg;
__EOF__
if [ "$?" -ne 0 ]; then echo "`date` Error, see mcs.out" >&2; exit 1; fi
echo "`date` See mcs.out for raw data; lbmmon.log for pretty data."
