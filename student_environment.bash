#!/usr/bin/env bash
IMG_NAME=cs354/student-env:latest


ID=local
if [ $(hostname) == vicious ]
then
  ID=$(whoami)
else
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

echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "   "
echo "   CS-354 Student Env"
echo ""
echo "   This container will be reused across many of the labs and "
echo "   projects. You can store files in this container and they will "
echo "   not be removed unless you delete the container manually."
echo "   This is not true of the other containers used in the class"
echo " "
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"


docker network create $NETWORK_NAME > /dev/null 2>&1
if ! docker start -i `docker ps -qaf name=$CTR_NAME` 2> /dev/null; then
  docker run -it --network $NETWORK_NAME --name $CTR_NAME $IMG_NAME
fi
