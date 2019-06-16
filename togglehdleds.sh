#! /usr/local/bin/bash
# Turn on/off all drive failure LEDs
# This script is useful if a drive is unavailable from the controller, as the
# controller will not be able to locate the LED in question.

if [[ ! "$1" || ("${1,,}" != "on" && "${1,,}" != "off") ]]; then
  echo "Usage: togglehdleds.sh <ON|OFF>"
  echo "Turn on/off all drive failure LEDs"
  exit
fi
action="$1"

controllerlist=$(sas2ircu list | grep -E ' [0-9]+ ' | sed -E $'s/^[\t ]+//;s/([0-9]+).*/\\1/')
for controller in $controllerlist;
do
  encaddrlist=$(sas2ircu $controller display | awk '/Enclosure #/,/Slot #/' | sed -E 'N;s/^.*: ([0-9]+)\n.*: ([0-9]+)/\1:\2/')
  for encaddr in $encaddrlist;
  do
  	sas2ircu $controller locate $encaddr $action 1>/dev/null
  done
done
echo Turned $action all LEDs available to controllers