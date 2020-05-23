#!/bin/bash
if ! tar -xf /tmp/submission/submission.tar.gz -C /tmp/submission; then# > /dev/null 2> /dev/null; then
  echo "FAIL_UNTAR"
  exit
fi

touch /tmp/submission/name.h
cp /tmp/submission/name.h /grading/name.h
/grading/util/test.sh
