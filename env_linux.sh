#!/usr/bin/env bash
IMG_NAME=cs354/student-env

if [[ $EUID != 0 ]]
then
  echo "This script must be run as root"
  exit
fi

ID=local
if [ $(hostname) = vicious ]
then
  ID=$(whoami)
fi


if [[ $(docker ps -qf ancestor\=$IMG_NAME)  ]]
then
  echo "The environment is already running. If you can't exit it normally, run:"
  echo "sudo docker stop " `docker ps -qf ancestor=$IMG_NAME`
  echo "then run this script again."
  exit
fi

docker network create cs354-${ID} > /dev/null 2>&1
if ! docker start -i `docker ps -qaf ancestor=$IMG_NAME` 2> /dev/null; then
  docker run -it --network cs354-$ID --name cs354-$ID $IMG_NAME
fi
