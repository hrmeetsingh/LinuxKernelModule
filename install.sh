# Color codes

G="\033[1;32m"  # GREEN
Y="\033[1;33m"  # YELLOW
R="\033[1;31m"  # RED
W="\033[1;37m"  # WHITE
NC="\033[0m"    # NO COLOR

# --------------- Check if root ----------------

if [[ $EUID -ne 0 ]]; then
	/usr/bin/printf "${R}>>>> Please run as root: sudo -H %s ${NC}\n" "${0}"
	exit 1
fi


# -------------- Check for required packages ---------------

# gcc

if ! /usr/bin/dpkg-query -W -f='${Status}' gcc 2>&1 | /bin/grep "ok installed" > /dev/null; then
	
	$(which apt) install -y build-essential
	exit 0
	
fi
