#!/bin/bash 

if [ "$(whoami)" != "root" ]
then
    echo "You do NOT have permission to run $0 as non-root user."
    exit 1
fi

if [ "$1" == "ON" ]
then
    echo "Turning USB on."
    echo '1-1' | tee /sys/bus/usb/drivers/usb/bind
elif [ "$1" == "OFF" ]
then 
    echo "Turning USB off."
echo '1-1' | tee /sys/bus/usb/drivers/usb/unbind
else
    echo "usage: $0 <ON|OFF>"
    exit 2
fi 




