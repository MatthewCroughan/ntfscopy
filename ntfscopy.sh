#!/bin/bash

display_usage() {
  echo "Usage: ntfscopy [COMMAND]... OR [DISKNAME]... OR [OPTION]... ARGUMENT"
  echo "Examples:"  
  echo "    ntfscopy sda1"  
  echo "    ntfscopy monitor"  
  echo "    ntfscopy -d /home/pi/files"  
  echo "Commands:"  
  echo "    monitor                               Tail the output of the ntfscopy log"
  echo "    monitor verbose                       A more verbose version of monitor"
  echo "Options:"  
  echo "    -d                                    Specify the directory containing files with which to copy over with rsync"
  echo "    -r                                    Reset the activity LED on the Pi"
  exit 1
}

# Applies config settings from /etc/ntfscopy/config
source /etc/ntfscopy/config

# Tails the output of /var/log/ntfscopy
monitor() {
  tail -f /var/log/ntfscopy
  exit 1
}

monitor_verbose() {
  tail -f /var/log/ntfscopy-verbose
  exit 1
}

# If more than 2 arguments are specified, then prints out too many arguments
if (( $# > 2 )); then echo "too many arguments"; exit 1; fi

if [[ $# -eq 0 ]] ; then
    display_usage
    echo 'No parameter supplied'
    exit 0
fi

# Runs monitor() if monitor is present.
if [[ "$1" == "monitor" && "$2" == "verbose" ]]; then
  monitor_verbose
  exit 0
fi

# Runs monitor() if monitor is present.
if [[ "$1" == "monitor" ]]; then
  monitor
  exit 0
fi

# Displays usage information if -h is present
if [ "$1" == "-h" ]; then
  display_usage
  exit 0
fi

if [[ $USER != "root" ]]; then
  echo "You must be root to do this!"
  exit 1
fi

# Resets the activity LED of the pi, in case it is stuck.
if [[ "$1" == "-r" ]]; then
  echo mmc0 | sudo tee /sys/class/leds/led0/trigger
  exit 0
fi

# Parses the contents of the second parameter if -d is present, and outputs that to the relative config directory.
if [[ "$1" == "-d" && -d "$2" ]]
then
  echo "COPYPATH=$2" > /etc/ntfscopy/config
  exit 0
elif [[ "$1" == "-d" && "$2" -eq 0 ]]
then
  echo "The path specified is not a directory"
  exit 0
fi

DISK=/dev/$1
MOUNTPOINT=$(mktemp -dp /mnt/)

if [ -b "$DISK" ]
then

# Start the logging process
dt=$(date +'%b %d %T:')
echo $dt Processing drive $1 | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose

# Debian 10 automounts usbs, this remedies that, and is good practice anyway.
echo $dt Attempting to unmount all partitions on $1 | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose
	umount -v /dev/"$1"?* | sudo tee --append /var/log/ntfscopy-verbose

# Place green LED on Pi3 in control mode
	echo gpio | sudo tee /sys/class/leds/led0/trigger
# Turn on the LED heatbeat mode to show activity 
	echo heartbeat | sudo tee /sys/class/leds/led0/trigger

echo $dt Zapping $1 with dd and sfdisk | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose
echo $dt $(lsblk -o name,size,fstype,label,model,serial,mountpoint $DISK) | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose
	dd if=/dev/zero of=$DISK bs=4096 count=1 conv=notrunc,fsync | sudo tee --append /var/log/ntfscopy-verbose
	echo ',,L' | sudo sfdisk --wipe-partitions=always --wipe=always $DISK --no-reread --force | sudo tee --append /var/log/ntfscopy-verbose

# Using using sfdisk to create a new DOS partition on the drive
echo $dt Creating DOS partition on $1 | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose
	echo 'type=83' | sudo sfdisk $DISK | sudo tee --append /var/log/ntfscopy-verbose

#Formatting, mounting and copying files to the device
echo $dt Formatting drive $1 as NTFS | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose
        sudo mkfs.ntfs -f /dev/"$1"1 | sudo tee --append /var/log/ntfscopy-verbose
echo $dt Mounting $DISK"1" to $MOUNTPOINT | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose
	mount $DISK"1" $MOUNTPOINT | sudo tee --append /var/log/ntfscopy-verbose
echo $dt Copying files from $COPYPATH to $MOUNTPOINT | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose
	sudo rsync -avz $COPYPATH/* $(df "$DISK"1 | awk 'END{print $NF}') | sudo tee --append /var/log/ntfscopy-verbose

echo $dt Unmounting $DISK"1" | sudo tee --append /var/log/ntfscopy /var/log/ntfscopy-verbose
	umount -v $DISK"1" | sudo tee --append /var/log/ntfscopy-verbose

# Turn off LED 
	echo 0 | sudo tee /sys/class/leds/led0/brightness 

# Play a sound upon completion
	( speaker-test -t sine -c 1 -s 1 -f 800 & TASK_PID=$! ; sleep 0.09 ; kill -s SIGINT $TASK_PID ) > /dev/null

else
	echo "$DISK does not exist, or is not a block device, you must specify a disk such as /dev/sda" 
fi
