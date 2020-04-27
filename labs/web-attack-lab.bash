#!/bin/bash

web_server_port=5000
student_env_port=6000
id=local

if [ $(hostname) = vicious ]
then
  id=$(whoami)
fi

NETWORK_NAME=cs354-$id

# Make sure network is up before we create the web-attack-lab forum container
docker network create $NETWORK_NAME > /dev/null 2>&1

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

lab_running=$(docker ps | grep "web-attack-lab-${id}" | wc -l)

if [ $lab_running -gt 0 ]
then
  echo Looks like the project is already running, we will restart it...
  docker stop web-attack-lab-${id}
fi

if [ $id = local ]
then
  echo "LOCAL"
  docker run --rm -d --name web-attack-lab-${id} -p 5000:5000 -p 5555:5555 --network cs354-${id} cs354/web-attack-lab:latest > /dev/null
else
  read_port=0
  while (( read_port < 1000 || read_port >  65535))
  do
    echo "Enter the port number of vicious you want to use for the webserver (1000 -> 65535)"
    echo "This will be forwarded to localhost:5000"
    read;
    read_port=${REPLY}
    if ! [ -z "$(lsof -i:${REPLY} -P -n | grep LISTEN)" ]
    then
      echo " "
      echo "!! That port is in use, pick another !!"
      echo " "
      read_port=0
    fi
  done
  web_server_port=$read_port

  docker run --rm -d --name web-attack-lab-${id} -p ${web_server_port}:5000 --network cs354-${id} cs354/web-attack-lab:latest

  read_port=0
  while (( read_port < 1000 || read_port >  65535))
  do
    echo " "
    echo "Enter a second port # to use (1000 -> 65535) REMEMBER THIS NUMBER"
    echo "This port will allow you to reach your attack container on vicious"
    echo "from your browser to allow XSS attacks."
    read;
    read_port=${REPLY}
    if ! [ -z "$(lsof -i:${REPLY} -P -n | grep LISTEN)" ]
    then
      echo " "
      echo "!! That port is in use, pick another !!"
      echo " "
      read_port=0
    fi
  done
  student_env_port=$read_port
fi

echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo " "
echo "   README"
echo " "
if [ $id != local ]
then
  echo "   To make the lab server available on your local machine, run this command"
  echo "   on your LOCAL machine (not in this shell):"
  echo "   --> ssh -L 5000:localhost:${web_server_port} ${id}@vicious.cs.northwestern.edu"
fi
echo " "
echo "   After this script finishes you will be dropped into the student container "
echo "   you will need it later in the lab to attack the webserver. For now you can"
echo "   minimize it. Nothing in this container will survive a restart. Don't store "
echo "   anything it!"
echo " "
echo "   The site is available to attack @ http://localhost:5000"
echo " "
echo "   To exit: control+a+d"
echo " "
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

path=$(realpath $0)
stu_env="${path%labs/web-attack-lab.sh}"student_environment.bash
sh $stu_env
