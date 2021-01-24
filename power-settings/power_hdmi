#!/bin/bash 

if [ "$(whoami)" != "root" ]
then
    echo "You do NOT have permission to run $0 as non-root user."
    exit 1
fi

if [ "$1" == "ON" ]
then
    echo "Turning HDMI on."
    /opt/vc/bin/tvservice -p
elif [ "$1" == "OFF" ]
then 
    echo "Turning HDMI off."
    /opt/vc/bin/tvservice -o
else
    echo "usage: $0 <ON|OFF>"
    exit 2
fi 




