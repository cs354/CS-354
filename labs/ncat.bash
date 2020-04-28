#!/bin/bash

if [ $(hostname) != vicious ]
then
  if [[ $EUID != 0 ]]
  then
    echo "This script must be run as root"
    exit
  fi
  id=local
else
  id=$(whoami)
fi

NETWORK_NAME=cs354-$id
CTR_NAME=ncat-${id}
IMG_NAME=cs354/student-env:latest

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

readme() {
  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  echo "   "
  echo "   NCAT server enviornment"
  echo "   "
  echo "   You will use ncat to make connections between this and your student"
  echo "   container. You need to have both running at the same time in"
  echo "   separate shells. See the instructions on hamsa for more."
  echo "   The hostname of this container is:"
  echo "   -> ${CTR_NAME}"
  echo " "
  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

docker network create $NETWORK_NAME > /dev/null 2>&1
lab_running=$(docker ps | grep "${CTR_NAME}" | wc -l)
if [ $lab_running -gt 0 ]
then
  echo Looks like the ncat project is already running. Type 'stop' to stop it or 'exit' to exit.
  echo If you need to open up a new shell, exit and then run this script again.
    read;
    response=${REPLY}
    if [ ${response} = stop ]
    then
      docker stop ${CTR_NAME}
      echo "Stopping victim container..."
      exit
    elif [ ${response} = exit ]
    then
      echo "Exiting, project still running."
      exit
    fi
fi

readme
if ! docker start --rm -it --network $NETWORK_NAME  `docker ps -qaf name=$CTR_NAME` 2> /dev/null; then
  docker run --rm -it --network $NETWORK_NAME --name $CTR_NAME $IMG_NAME
fi


