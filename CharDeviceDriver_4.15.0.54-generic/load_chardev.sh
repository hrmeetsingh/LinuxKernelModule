#!/bin/bash


# ----- Color codes
G="\033[1;32m"  # GREEN
Y="\033[1;33m"  # YELLOW
R="\033[1;31m"  # RED
W="\033[1;37m"  # WHITE
NC="\033[0m"    # NO COLOR

# ----- Check if not root
if [[ $EUID -ne 0 ]]; then
	/usr/bin/printf "${R}>>>>${NC} Please run as root:\nsudo -H %s\n" "${0}"
	exit 1
fi

module="chardev.ko"
device="chardev"
group="root"
mode="666"

/sbin/insmod $module || exit 1

major=`cat /proc/devices | awk "\\$2==\"$device\" {print \\$1}"`

rm -f /dev/${device}
mknod /dev/${device} c $major 0

chgrp $group /dev/${device}
chmod $mode /dev/${device}

/usr/bin/printf "${G}>>>> Inserted the device with major number %s ${NC}\n" "${major}"
/usr/bin/printf "${G}>>>> Run \"#cat /dev/chardev\" multiple times to verify everything is working ${NC}\n"
/usr/bin/printf "${G}>>>> Run \"#rmmod chardev\" to unload module ${NC}\n"

