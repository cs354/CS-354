#!/bin/bash

## student-env container name is : firewall-attacker-id
## lab container name is firewall-lab-id
## network name is firewall-lab-id
##  id is either 'local' or their vicious username

id=local
if [ $(hostname) = vicious ]
then
  id=$(whoami)
fi

start_attacker() {
  network_created=$(docker network ls | grep "firewall-lab-${id}" | wc -l)
  #if [ $network_created -gt 0 ]
  #then
  #  echo "Network already exists"
  #else
  #  echo Creating network firewall-lab-${id}
  #  docker network create firewall-lab-${id}
  #  echo Created network
  #fi

  docker run --rm --privileged -d --name firewall-lab-${id} --network cs354 cs354/lab-firewall:latest

  running=$(docker ps | grep "firewall-attacker-${id}" | wc -l)

  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  echo " "
  echo "   README"
  echo " "
  echo "   We are starting a version of the general container."
  echo "   Changes you make here will not be saved!"
  echo " "
  echo "   Inside this container, the firewall system's hostname is: "
  echo "   'firewall-lab-${id}'"
  echo " "
  echo "   You can connect to the firewall system by running"
  echo "   ./firewall-connect.bash"
  echo "   in another terminal"
  echo " "
  echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

  if [ $running -gt 0 ]
  then
    echo "Resuming existing container..."
    docker exec -it /bin/bash firewall-attacker-${id}
  else
    echo "Starting new attacker container"
    docker run -it --rm --name firewall-attacker-${id} --network firewall-lab-${id} cs354/student-env:latest
  fi
}

lab_running=$(docker ps | grep "firewall-lab-${id}" | wc -l)

if [ $lab_running -gt 0 ]
then
  echo Looks like the project is already running, we will restart it...
  docker stop firewall-lab-${id}
fi

start_attacker

echo "Please wait, cleaning up the firewall-lab environment"

docker stop firewall-lab-${id} > /dev/null
