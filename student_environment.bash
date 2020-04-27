#!/usr/bin/env bash
IMG_NAME=cs354/student-env


ID=local
if [ $(hostname) != vicious ]
then
  ID=$(whoami)
  if [[ $EUID != 0 ]]
  then
    echo "This script must be run as root"
    exit
  fi
fi

CTR_NAME=cs354-$ID
NETWORK_NAME=cs354-$ID

if [[ $(docker ps -qf name=$CTR_NAME) ]]
then
  echo "The environment is already running. If you can't exit it normally, run:"
  echo "docker stop " `docker ps -qf name=$CTR_NAME`
  echo "then run this script again."
  exit
fi

docker network create $NETWORK_NAME > /dev/null 2>&1
if ! docker start -i `docker ps -qaf name=$CTR_NAME` 2> /dev/null; then
  docker run -it --network $NETWORK_NAME --name $CTR_NAME $IMG_NAME
fi
