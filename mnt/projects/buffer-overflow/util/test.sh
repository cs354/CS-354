#!/bin/bash

# convert the argument to envar to emulate the grading server

if [ -z ${NETID+x} ]; then
  NETID=$1
fi

if ! make > /dev/null 2>&1; then
  echo "FAIL_BUILD"
  exit
fi

if ! ./nulltest > /dev/null 2>&1; then
  echo "FAIL_NULL"
  exit
fi

if [[ $(timeout -k 1 1 ./name) == $NETID ]]
then
  echo "PASS"
else
  echo "FAIL_NAME"
fi

exit
