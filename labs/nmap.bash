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

NETWORK_NAME=bridge #cs354-$id
CTR_NAME=attackme-${id}

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

readme() {
  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  echo " "
  echo "   nmap victim started"
  echo " "
  echo "   You are going to be dropped into your student container now."
  echo "   Later in the lab you will use nmap to exploit the other container"
  echo "   on the network. Its host name is: "
  echo "   -> ${CTR_NAME}"
  echo " "
  echo "   For now leave this up and return to the instructions on hamsa."
  echo " "
  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

start_victim() {
  readme
  docker run --network $NETWORK_NAME --name ${CTR_NAME} -d --rm cs354/nmap:latest
}

docker network create $NETWORK_NAME > /dev/null 2>&1

lab_running=$(docker ps | grep "${CTR_NAME}" | wc -l)
if [ $lab_running -gt 0 ]
then
  echo Looks like the project is already running. Type 'stop' or 'resume'
    read;
    response=${REPLY}
    if [ ${response} = stop ]
    then
      docker stop ${CTR_NAME}
      echo "Stopping victim container..."
      exit
    elif [ ${response} = resume ]
    then
      echo "Resuming..."
      readme
    else
      echo "Exitting."
      exit
    fi
else
  start_victim
fi

path=$(realpath $0)
stu_env="${path%labs/nmap.bash}"student_environment.bash
bash $stu_env


