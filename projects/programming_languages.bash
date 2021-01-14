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
CTR_SQL_NAME=mysqld-${id}
CTR_PL_NAME=proglang-${id}
IMG_PL_NAME=cs354/proglang:latest
IMG_SQL_NAME=cs354/mysqld:latest


start_mysql() {
  if ! docker start `docker ps -qaf name=$CTR_SQL_NAME` 2> /dev/null; then
    docker run --rm -d --network $NETWORK_NAME --name $CTR_SQL_NAME $IMG_SQL_NAME
  fi
}

start_proglan() {
  if ! docker start -i `docker ps -qaf name=$CTR_PL_NAME` 2> /dev/null; then
    docker run  -e MYSQLD_HOST="${CTR_SQL_NAME}" -it --network $NETWORK_NAME --name $CTR_PL_NAME $IMG_PL_NAME
  fi
}


stop_mysql() {
  lab_running=$(docker ps | grep "${CTR_PL_NAME}" | wc -l)
  if [ $lab_running -gt 0 ]
  then
    docker stop $CTR_SQL_NAME
  fi
}

stop_proglang() {
  lab_running=$(docker ps | grep "${CTR_PL_NAME}" | wc -l)
  if [ $lab_running -gt 0 ]
  then
    docker stop ${CTR_PL_NAME}
  fi
}



readme() {
  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  echo "   "
  echo "   Programming Languages Project"
  echo "   "
  echo "   You are being dropped into the programming languages project."
  echo "   We use a slightly different container for this project since it"
  echo "   requires some tools that aren't easily available on kali linux."
  echo "   This container will not wipe when you leave it."
  echo "  "
  echo "   There is a mysql server deployed on the same network, you can "
  echo "   reach it at hostname:"
  echo "   -> ${CTR_SQL_NAME}"
  echo "   with command 'mysql --host ${CTR_SQL_NAME}'"
  echo "  "
  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
}

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

docker network create $NETWORK_NAME > /dev/null 2>&1
lab_running=$(docker ps | grep "${CTR_PL_NAME}" | wc -l)
if [ $lab_running -gt 0 ]
then
  echo Looks like the programming languages project is already running. Type 'stop' to stop it or 'resume' to resume.
  read;
  response=${REPLY}
  if [ ${response} = stop ]
  then
    stop_proglang
    echo "Stopping proglang container"
    exit
  elif [ ${response} = resume ]
  then
    echo "Resuming..."
  else
    echo "Choose stop or resume. Exiting."
    exit
  fi
fi

docker network create $NETWORK_NAME > /dev/null 2>&1
readme
start_mysql
start_proglan
