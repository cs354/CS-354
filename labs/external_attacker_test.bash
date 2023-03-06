#!/bin/bash

id=northwestern.cs.edu

if [ $(hostname) != vicious ]
then
else
read -p "What is the ip address of the host? " id
fi
# Prompt the user to enter the port number for forwarding to port 80
read -p "What is the port being forwarded to port 80? " port_80

# Prompt the user to enter the port number for forwarding to port 5555
read -p "What is the port being forwarded to port 5555? " port_5555

# Prompt the user to enter the port number for forwarding to port 6666
read -p "What is the port being forwarded to port 6666? " port_6666

# Print the values of the three variables
echo "The port being forwarded to port 80 is: $port_80"
echo "The port being forwarded to port 5555 is: $port_5555"
echo "The port being forwarded to port 6666 is: $port_6666"


points=0
test1passed=false
echo "Testing traffic redirection, connecting to port 80..."
echo "If you successfully redirected traffic, you should end up contacting port 6666."
output=$(nc -w 3 ${id} ${port_80})
if echo "$output" | grep -q "You have contacted the service listening on port 6666. Goodbye."
then
echo "Test 1: Passed"
points=$((points+1))
test1passed=true
else
echo "Test 1: Failed"
fi

nc -w 3 ${id} $port_5555
if [[ $? -ne 0 ]]
then
echo "Test 2: Passed"
points=$((points+1))
else
echo "Test 2: Failed"
fi

if [ "$test1passed" = true ]
then
echo "Testing extra credit, connecting directly to port 6666..."
nc -w 3 ${id} $port_6666
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
