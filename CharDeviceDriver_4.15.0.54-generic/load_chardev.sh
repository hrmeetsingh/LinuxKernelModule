#!/bin/bash


# ----- Color codes
G="\033[1;32m"  # GREEN
Y="\033[1;33m"  # YELLOW
R="\033[1;31m"  # RED
W="\033[1;37m"  # WHITE
NC="\033[0m"    # NO COLOR

# ----- Check if not root
if [[ $EUID -ne 0 ]]; then
	/usr/bin/printf "${R}>>>> Please run as root:\nsudo %s ${NC}\n" "${0}"
	exit 1
fi

module="chardev.ko"
device="chardev"
group="root"
mode="666"

# /sbin/insmod $module || exit 1

if /sbin/insmod $module; then
        /usr/bin/printf "${G}>>>> Inserted module succesfully ${NC}\n"
else
        /usr/bin/printf "${R}>>>> Error inserting module ${NC}\n"
	exit 1
fi

major=`cat /proc/devices | awk "\\$2==\"$device\" {print \\$1}"`

if [[ -c "/dev/${device}" ]]; then
        /usr/bin/printf "${Y}>>>> Device file already exists, deleting it first...  ${NC}\n"
        rm -f /dev/${device}
fi

if mknod /dev/${device} c $major 0; then
	/usr/bin/printf "${G}>>>> Created character device ${NC}\n"
else
	/usr/bin/printf "${R}>>>> Error creating character device ${NC}\n"
	exit 1
fi

chgrp $group /dev/${device}
chmod $mode /dev/${device}

/usr/bin/printf "${G}>>>> Inserted the device with major number %s ${NC}\n" "${major}"
/usr/bin/printf "${G}>>>> Run \"#cat /dev/chardev\" multiple times to verify everything is working ${NC}\n"
/usr/bin/printf "${G}>>>> Run \"#rmmod chardev\" to unload module ${NC}\n"

