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
test1passed=false
echo "Testing traffic redirection, connecting to port 80..."
echo "If you successfully redirected traffic, you should end up contacting port 6666."
output=$(nc firewall-lab-${id} 80)
if echo "$output" | grep -q "You have contacted the service listening on port 6666. Goodbye."
then
echo "Test 1: Passed"
points=$((points+1))
test1passed=true
else
echo "Test 1: Failed"
fi

# Get the IP address of the machine
ip_address=$(hostname -I | awk '{print $1}')
echo "ip address is $ip_address"
# Check if the IP address is in the private IP address range
IFS=. read -r i1 i2 i3 i4 <<< "$ip_address"
if [[ ($i1 == 10) || ($i1 == 172 && $i2 -ge 16 && $i2 -le 31) || ($i1 == 192 && $i2 == 168) ]]
then
    # If the IP address is in the private IP address range, test inbound traffic on port 5555
    echo "Testing inbound traffic on port 5555"
    nc firewall-lab-${id} 5555
    if [[ $? -eq 0 ]]; then
        # If inbound traffic is allowed on port 5555, print a success message
        echo "Inbound traffic allowed on port 5555"
	echo "Test 2: Passed"
   	points=$((points+1)) 
else
        # If inbound traffic is not allowed on port 5555, print a failure message
        echo "Inbound traffic not allowed on port 5555"
    fi
else
    # If the IP address is not in the private IP address range, skip the test and print a message
    echo "Machine IP address not in private IP address range, skipping test"
fi

if [ "$test1passed" = true ]
then
echo "Testing extra credit, connecting directly to port 6666..."
nc -w 3 firewall-lab-${id} 6666
if [ $? -ne 0 ]
then
echo "Test 3: Passed"
points=$((points+1))
else
echo "Test 3: Failed"
fi
else
echo "skipping test 3 since test 1 did not pass"
fi

echo "You earned $points point(s) out of 2."
