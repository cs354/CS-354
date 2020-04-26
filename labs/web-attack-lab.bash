#!/bin/bash

## student-env container name is : attacker-id
## lab container name is web-attack-lab-id
## network name is web-attack-lab-id
##  id is either 'local' or their vicious username

web_server_port=5000
student_env_port=6000
id=local
if [ $(hostname) = vicious ]
then
  id=$(whoami)
fi

start_attacker() {
  network_created=$(docker network ls | grep "web-attack-lab-${id}" | wc -l)
  if [ $network_created -gt 0 ]
  then
    echo "Network already exists"
  else
    echo Creating network web-attack-lab-${id}
    docker network create web-attack-lab-${id}
    echo Created network
  fi

  running=$(docker ps | grep "attacker-${id}" | wc -l)

  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  echo " "
  echo "   README"
  echo " "
  if [ $id != local ]
  then
    echo "   To make the server available on your local machine (not on vicious) run :"
    echo "   ssh -L 5000:localhost:${web_server_port} ${id}@vicious.cs.northwestern.edu"
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

  if [ $running -gt 0 ]
  then
    echo "Resuming existing container..."
    docker exec -it /bin/bash attacker-${id}
  else
    echo "Starting new attacker container"
    docker run -it --rm --name attacker-${id} -p ${student_env_port}:5555 --network web-attack-lab-${id} cs354/student-env:latest
  fi
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
  docker run --rm -d --name web-attack-lab-${id} -p 5000:5000 -p 5555:5555 --network web-attack-lab-${id} cs354/web-attack-lab:latest
else
  read_port=0
  while (( read_port < 1000 || read_port >  65535))
  do
    echo "Enter the port number of vicious you want to use for the webserver (1000 -> 65535)"
    echo "This will be forwarded to localhost:5000"
    read;
    read_port=${REPLY}
  done
  web_server_port=$read_port
  docker run --rm -d --name web-attack-lab-${id} -p ${web_server_port}:5000 --network web-attack-lab-${id} cs354/web-attack-lab:latest

  read_port=0
  while (( read_port < 1000 || read_port >  65535))
  do
    echo "Enter a second port # to use (1000 -> 65535) REMEMBER THIS NUMBER"
    echo "This port will allow you to reach your attack container on vicious"
    echo "from your browser to allow XSS attacks."
    read;
    read_port=${REPLY}
  done
  student_env_port=$read_port

fi

start_attacker
