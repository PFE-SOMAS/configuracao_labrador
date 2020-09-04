#!/bin/bash

#Editar esta linha!
IP_Professor=192.168.15.4

function check_online
{
    netcat -z -w 5 $IP_Professor 53 && echo 1 || echo 0
}

# Initial check to see if we are online
IS_ONLINE=check_online
# How many times we should check if we're online - this prevents infinite looping
MAX_CHECKS=5
# Initial starting value for checks
CHECKS=0

# Loop while we're not online.
while [ $IS_ONLINE -eq 0 ]; do
    # We're offline. Sleep for a bit, then check again

    sleep 10;
    IS_ONLINE=check_online

    CHECKS=$[ $CHECKS + 1 ]
    if [ $CHECKS -gt $MAX_CHECKS ]; then
        break
    fi
done

if [ $IS_ONLINE -eq 0 ]; then
    # We never were able to get online. Kill script.
    exit 1
fi

# Now we enter our normal code here. The above was just for online checking
sshfs professor@$IP_Professor:/home/professor/SOMAS /home/aluno/SOMAS -o nonempty
