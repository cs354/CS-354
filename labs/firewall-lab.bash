#!/bin/bash

## student-env container name is : firewall-attacker-id
## lab container name is firewall-lab-id
## network name is firewall-lab-id
##  id is either 'local' or their vicious username
docker pull ckotwasinski/lab-firewall:latest
CS354_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
id=local
student_env_port_80=80
student_env_port_5555=5555
student_env_port_6666=6666
if [ $(hostname) = vicious ]
then
  id=$(whoami)
fi

start_attacker() {
  network_created=$(docker network ls | grep "firewall-lab-${id}" | wc -l)
  if [ $network_created -gt 0 ]
  then
    echo "Network already exists"
  else
    echo Creating network firewall-lab-${id}
    docker network create firewall-lab-${id}
    echo Created network
  fi

  if [ $id = local ]
  then
    echo "LOCAL"
  else
    read_port=0
    while (( read_port < 1000 || read_port >  65535))
    do
      echo " "
      echo "Enter a port # to use (1000 -> 65535) REMEMBER THIS NUMBER"
      echo "This port will allow you to reach your attack container on vicious"
      echo "from your local machine through port 80 on vicious"
      read;
      read_port=${REPLY}
      result=$(netstat -tulpn |& grep ${REPLY} | grep "LISTEN")
      if ! test -z "$result"
      then
        echo " "
        echo "!! That port is in use, pick another !!"
        echo " "
        read_port=0
      fi
    done
    student_env_port_80=$read_port
    read_port=0
    while (( read_port < 1000 || read_port >  65535))
    do
      echo " "
      echo "Enter a port # to use (1000 -> 65535) REMEMBER THIS NUMBER"
      echo "This port will allow you to reach your attack container on vicious"
      echo "from your local machine through port 5555 on vicious"
      read;
      read_port=${REPLY}
      result=$(netstat -tulpn |& grep ${REPLY} | grep "LISTEN")
      if ! test -z "$result"
      then
        echo " "
        echo "!! That port is in use, pick another !!"
        echo " "
        read_port=0
      fi
    done
    student_env_port_5555=$read_port
    read_port=0
    while (( read_port < 1000 || read_port >  65535))
    do
      echo " "
      echo "Enter a port # to use (1000 -> 65535) REMEMBER THIS NUMBER"
      echo "This port will allow you to reach your attack container on vicious"
      echo "from your local machine through port 6666 on vicious"
      read;
      read_port=${REPLY}
      result=$(netstat -tulpn |& grep ${REPLY} | grep "LISTEN")
      if ! test -z "$result"
      then
        echo " "
        echo "!! That port is in use, pick another !!"
        echo " "
        read_port=0
      fi
    done
    student_env_port_6666=$read_port
  fi
  docker run --rm --privileged -d --name firewall-lab-${id} -p ${student_env_port_80}:80 -p ${student_env_port_5555}:5555 -p ${student_env_port_6666}:6666 --network firewall-lab-${id} ckotwasinski/lab-firewall:latest

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
    docker run -it --rm --name firewall-attacker-${id} --network firewall-lab-${id} -v ${CS354_DIR}/mnt:/mnt cs354/student-env:latest
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
