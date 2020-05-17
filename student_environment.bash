#!/usr/bin/env bash
IMG_NAME=cs354/student-env:latest

readme() {
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
}

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
  echo "The environment is already running. You can start another session or stop the container."
  echo "This will not create a new container just a new terminal to access it."
  echo "Type 'stop' or 'new'"
  read;
  reply=${REPLY}
  if [ ${reply} = stop ]
  then
    echo "Stopping"
    docker stop `docker ps -qf name=$CTR_NAME`
    exit
  elif [ ${reply} = new ]
  then
    echo "New session..."
    readme
    docker exec -it `docker ps -qf name=$CTR_NAME` /bin/bash
    exit
  else
    echo "You must type stop or new... Exiting."
    exit
  fi
fi

DOCKER_ARGS="-it --network $NETWORK_NAME --name $CTR_NAME -v${PWD}/mnt:/mnt"

docker network create $NETWORK_NAME > /dev/null 2>&1
if ! docker start -i `docker ps -qaf name=$CTR_NAME` 2> /dev/null; then
  if [[ "$OSTYPE" == "darwin"* ]]
  then
    DOCKER_ARGS+=" --privileged"
    docker run $DOCKER_ARGS $IMG_NAME
  else
    docker run $DOCKER_ARGS $IMG_NAME
  fi
fi
