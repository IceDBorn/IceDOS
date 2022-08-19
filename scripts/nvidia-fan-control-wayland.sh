#!/bin/bash

# cool_gpu2.sh  This script will enable or disable fixed gpu fan speed
#
# Description:  A script to control GPU fan speed on headless (non-X) linux nodes

# Original Script by Axel Kohlmeyer <akohlmey@gmail.com>
# https://sites.google.com/site/akohlmey/random-hacks/nvidia-gpu-coolness
#
# Modified for newer drivers and removed old work-arounds
# Tested on Ubuntu 14.04 with driver 352.41
# Copyright 2015, squadbox

# Requirements:
# * An Nvidia GPU
# * Nvidia Driver V285 or later
# * xorg
# * Coolbits enabled and empty config setting
#     nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration

# You may have to run this as root or with sudo if the current user is not authorized to start X sessions.


# Paths to the utilities we will need
SMI='/usr/bin/nvidia-smi'
SET='/usr/bin/nvidia-settings'

# Determine major driver version
VER=`awk '/NVIDIA/ {print $8}' /proc/driver/nvidia/version | cut -d . -f 1`

# Drivers from 285.x.y on allow persistence mode setting
if [ ${VER} -lt 285 ]
then
    echo "Error: Current driver version is ${VER}. Driver version must be greater than 285."; exit 1;
fi

# Read a numerical command line arg between 0 and 100
if [ "$1" -eq "$1" ] 2>/dev/null && [ "0$1" -ge "0" ]  && [ "0$1" -le "100" ]
then
    $SMI -pm 1 # enable persistance mode
    speed=$1   # set speed

    echo "Setting fan to $speed%."

    # how many GPU's are in the system?
    NUMGPU="$(nvidia-smi -L | wc -l)"

    # loop through each GPU and individually set fan speed
    n=0
    while [  $n -lt  $NUMGPU ];
    do
        # start an x session, and call nvidia-settings to enable fan control and set speed
        xinit ${SET} -a [gpu:${n}]/GPUFanControlState=1 -a [fan:${n}]/GPUTargetFanSpeed=$speed --  :10 -once
        let n=n+1
    done

    echo "Complete"; exit 0;

elif [ "x$1" = "xstop" ]
then
    $SMI -pm 0 # disable persistance mode

    echo "Enabling default auto fan control."

    # how many GPU's are in the system?
    NUMGPU="$(nvidia-smi -L | wc -l)"

    # loop through each GPU and individually set fan speed
    n=0
    while [  $n -lt  $NUMGPU ];
    do
        # start an x session, and call nvidia-settings to enable fan control and set speed
        xinit ${SET} -a [gpu:${n}]/GPUFanControlState=0 --  :10 -once
        let n=n+1
    done

    echo "Complete"; exit 0;

else
    echo "Error: Please pick a fan speed between 0 and 100, or stop."; exit 1;
fi
