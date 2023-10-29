#!/bin/sh
# tst.sh

kill_pids()
{
  echo "`date` kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID $UMESRC_PID"
  kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID $UMESRC_PID
}

if [ ! -f "lbm.sh" ]; then :
  echo "Must create 'lbm.sh' file (use 'lbm.sh.example' as guide)." >&2
  exit 1
fi

if [ ! -f "JsonPrint.jar" ]; then :
  echo "Must get 'JsonPrint.jar' (see https://github.com/UltraMessaging/mcs_json_print)." >&2
  exit 1
fi

. ./lbm.sh

rm -rf cache state *.log *.pid *.out umercv

# Enhanced "umercv" that supports the "-q" option to use the UM event queue.
gcc -Wall -I. -I$LBM/include -I $LBM/include/lbm -L$LBM/lib -llbm -lm -o umercv verifymsg.c umercv.c
if [ "$?" -ne 0 ]; then echo "`date` Error" >&2; exit 1; fi

# Kill background processes on control-C.
trap "kill_pids; exit 1" 1 2 3 15

# Unicast topic resolution using "lbmrd" for monitoring TRD.
lbmrd lbmrd.xml >lbmrd.log 2>&1 &
LBMRD_PID="$!"; echo "`date` LBMRD_PID=$LBMRD_PID"

# Start Monitoring Collector Service (MCS) with the JsonPrint module.
MCS_CMD="java -classpath $L/MCS/lib/MCS.jar:$L/MCS/lib/UMS_6.15.jar:$L/MCS/lib/UMSMON_PROTO3.jar:./JsonPrint.jar:$L/MCS/lib/um-mondb-common.jar:$L/MCS/lib/protobuf-java-util-4.0.0-rc-2.jar:$L/MCS/lib/protobuf-java-4.0.0-rc-2.jar:$L/MCS/lib/gson-2.8.5.jar:$L/MCS/lib/java-getopt-1.0.13.jar:$L/MCS/lib/log4j-api-2.14.1.jar:$L/MCS/lib/log4j-core-2.14.1.jar:$L/MCS/lib/guava-24.1.1-jre.jar com.informatica.um.monitoring.UMMonitoringCollector -Z$L/MCS/bin/ummon.db mcs.xml"

LBM_XML_CONFIG_FILENAME=um.xml LBM_XML_CONFIG_APPNAME=mcs $MCS_CMD >mcs.log 2>&1 &
# Wait up to 5 seconds for MCS to create its PID file.
for I in 1 2 3 4 5; do :
  if [ ! -f "mcs.pid" ]; then sleep 1; fi
done
if [ ! -f "mcs.pid" ]; then echo "`date` mcs fail?" >&2; kill_pids; exit 1; fi
MCS_PID="`cat mcs.pid`"; echo "`date` MCS_PID=$MCS_PID"

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

# Clear persistent Store's files.
mkdir cache
mkdir state

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
LBM_XML_CONFIG_APPNAME=umercv LBM_XML_CONFIG_FILENAME=um.xml ./umercv -q -v -v topic1 >umercv.log 2>&1 &
UMERCV_PID="$!"; echo "`date` UMERCV_PID=$UMERCV_PID"

# Wait for publisher to complete.
echo "`date` wait $UMESRC_PID"
wait $UMESRC_PID
unset UMESRC_PID

# Wait for subscriber to time out the publisher and drop transport.
echo "`date` sleep 37"
sleep 37

kill $LBMRD_PID $MCS_PID $SRS_PID $DRO_PID $STORE_PID $UMERCV_PID $UMESRC_PID

