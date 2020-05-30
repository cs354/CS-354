#!/bin/bash

id=local
if [ $(hostname) = vicious ]
then
  id=$(whoami)
fi

docker exec -it firewall-lab-${id} /bin/bash