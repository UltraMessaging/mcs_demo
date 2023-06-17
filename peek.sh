#!/bin/sh
# peek.sh

if [ ! -f mcs.out ]; then :
  echo "File 'mcs.out' not found; must first run 'tst.sh'" >&2
  exit 1
fi

echo "umesrc last source record:"
egrep '"applicationId":"umesrc".*"sourceFlag":"SOURCE_NORMAL"' mcs.out | tail -1 | python -m json.tool
echo ""

echo "umercv last receiver record:"
egrep '"applicationId":"umercv".*"sourceFlag":"SOURCE_NORMAL"' mcs.out | tail -1 | python -m json.tool
echo ""

echo "store last receive record:"
egrep '"applicationId":"store_appid_topic1".*"naksSent":' mcs.out | tail -1 | python -m json.tool
echo ""

echo "store last daemon stats record:"
egrep '"applicationId":"store_topic1".*"srcRepoStats":\[{"srcRegid":' mcs.out | tail -1 | python -m json.tool
echo ""

echo "DRO last proxy receiver record:"
egrep '"applicationId":"Gateway_Portal_TRD1_rcv_ctx".*"sourceFlag":"SOURCE_NORMAL"' mcs.out | tail -1 | python -m json.tool
echo ""

echo "DRO last proxy source record:"
egrep '"applicationId":"Gateway_Portal_TRD2_src_ctx".*"sourceFlag":"SOURCE_NORMAL"' mcs.out| tail -1 | python -m json.tool
echo ""

echo "DRO last daemon stats record:"
egrep '"applicationId":"dro1".*' mcs.out| tail -1 | python -m json.tool
echo ""
