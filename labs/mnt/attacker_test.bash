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

points=0

echo "Testing traffic redirection, connecting to port 80..."
echo "If you successfully redirected traffic, you should end up contacting port 6666."
nc firewall-lab-${id} 80
if [ $? -eq 0 ]
then
echo "Test 1: Passed"
points=$((points+1))
else
echo "Test 1: Failed"
fi

# Get the IP address of the machine
ip_address=$(hostname -I | awk '{print $1}')
echo $ip_address
# Check if the IP address is in the private IP address range
if [[ $ip_address == 10.* || $ip_address == 172.* || $ip_address == 192.168.* ]]; then
    # If the IP address is in the private IP address range, test inbound traffic on port 5555
    echo "Testing inbound traffic on port 5555"
    nc firewall-lab-${id} 5555
    if [[ $? -eq 0 ]]; then
        # If inbound traffic is allowed on port 5555, print a success message
        echo "Inbound traffic allowed on port 5555"
   	points=$((points+1)) 
else
        # If inbound traffic is not allowed on port 5555, print a failure message
        echo "Inbound traffic not allowed on port 5555"
    fi
else
    # If the IP address is not in the private IP address range, skip the test and print a message
    echo "Machine IP address not in private IP address range, skipping test"
fi


echo "Testing extra credit, connecting directly to port 6666..."
nc firewall-lab-${id} 6666
if [ $? -eq 0 ]
then
echo "Test 3: Passed"
points=$((points+1))
else
echo "Test 3: Failed"
fi

echo "You earned $points point(s) out of 2."
