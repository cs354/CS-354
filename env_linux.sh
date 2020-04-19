#!/usr/bin/env bash
IMG_NAME=cs354/student-env
if [[ $(docker ps -qf ancestor\=$IMG_NAME)  ]]
then
  echo "The environment is already running. If you can't exit it normally, run:"
  echo "sudo docker stop " `docker ps -qf ancestor=$IMG_NAME`
  exit
fi

if ! docker start -i `docker ps -qaf ancestor=$IMG_NAME` 2> /dev/null; then
  docker run -it --network host cs354/student-env
fi
