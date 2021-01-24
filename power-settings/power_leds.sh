#!/bin/bash 

if [ "$(whoami)" != "root" ]
then
  echo "You do NOT have permission to run $0 as non-root user."
  exit 1
fi


# "global" vars
target_file=/etc/rc.local

# functions
function show_help {
  echo "Usage:    power_leds <option> <ON|OFF>"
  echo "Options:  --pwr/-p  --  Power LED         (led0)" 
  echo "          --act/-a  --  Activity LED      (led1)" 
  echo "          --both/-b --  Both pwr/act LEDs (led0/led1)"
  echo "          --help/-h --  Print help and exit"
  echo ""
}

function toggle_power {
  led=$1
  power=$2
  case $power in
    "ON")  sed -i 's|^sh -c "echo none > /sys/class/leds/'$led'/trigger"|#sh -c "echo none > /sys/class/leds/'$led'/trigger"|' $target_file
           sed -i 's|^sh -c "echo 0 > /sys/class/leds/'$led'/brightness"|#sh -c "echo 0 > /sys/class/leds/'$led'/brightness"|' $target_file
           ;;
    "OFF") sed -i 's|^#sh -c "echo none > /sys/class/leds/'$led'/trigger"|sh -c "echo none > /sys/class/leds/'$led'/trigger"|' $target_file
           sed -i 's|^#sh -c "echo 0 > /sys/class/leds/'$led'/brightness"|sh -c "echo 0 > /sys/class/leds/'$led'/brightness"|' $target_file
           ;;
  esac
}


# map long args to short args
for arg in "$@"
do
  shift
  case $arg in
    "--help") set -- "$@" "-h" ;;
    "--both") set -- "$@" "-b" ;;
    "--pwr")  set -- "$@" "-p" ;;
    "--act")  set -- "$@" "-a" ;;
    *)        set -- "$@" "$arg"
  esac
done

# default
pwr="OFF"
act="OFF"

# parse args using getopts
while getopts "hb:p:a:" arg
do
  case $arg in
    h) show_help; exit 0;;
    b) pwr=$OPTARG; act=$OPTARG; break;;
    p) pwr=$OPTARG;;
    a) act=$OPTARG;;
  esac
done

# set uppercase
pwr=${pwr^^}
act=${act^^}
echo "PWR LED: $pwr"
echo "ACT LED: $act"

# determine if rc.local has previously been modidified by this script
#   add modifiying line if not
if grep -q "/sys/class/leds" $target_file
then
  echo "found changes."
else
  sed -i '/exit 0/i sh -c "echo none > /sys/class/leds/led0/trigger"' $target_file 
  sed -i '/exit 0/i sh -c "echo none > /sys/class/leds/led1/trigger"' $target_file
  sed -i '/exit 0/i sh -c "echo 0 > /sys/class/leds/led0/brightness"' $target_file
  sed -i '/exit 0/i sh -c "echo 0 > /sys/class/leds/led1/brightness"' $target_file
fi

# set LED power settings
toggle_power led0 $act
toggle_power led1 $pwr

grep "/sys/class/leds" $target_file

