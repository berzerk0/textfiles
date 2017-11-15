#!/bin/bash

# $1 = machine name
# $2 machine IP

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Display error if not enough arguments given
if [ $# -ne 2 ]; then
	printf " ${RED}Usage: ${NC} ./benmap.sh target_nickname target_IP \n"
	exit 1
fi

#Alias for output directory
benmap_dir="$HOME/CTFs/$1"

# If output directory does not exist, create and move into it.
if [ ! -d "$benmap_dir" ]; then
	mkdir ~/CTFs/$1 && cd ~/CTFs/$1 || return
	touch "NOTES_$1.txt"
fi

#If output dir does exist, but not NOTES file, create notes file.
if [ ! -f "$HOME/CTFs/NOTES_$1.txt" ]; then
	touch "NOTES_$1.txt"
fi

#Open notes file (I like to use gedit for notes)
printf "\n${GREEN}Opening NOTES_$1.txt... ${NC}\n\n\n"
gedit "NOTES_$1.txt" &

#Move to working directory
cd "$benmap_dir" || return
unset benmap_dir

#Announce and run fast portscan (Top 100 ports only)
printf "Running ${GREEN}Fast${NC} Portscan on $2...\nSaving FastPorts to ${GREEN}nmap_$1_fastports${NC}... \n"
nmap -F -r -T4 "$2"| grep '\/tcp' | cut -d '/' -f 1 | tr '\n' ',' > "nmap_$1_fastports"
benmap_fastports=$(cat "nmap_$1_fastports")
printf "${GREEN}FastPorts${NC} found: ${GREEN} $benmap_fastports ${NC} \n \n"


#Announce and run service ID on found fast ports
printf "Running ${GREEN}FastPort${NC} Service Version ID... \n \n"
nmap -sV -p"$benmap_fastports" -T4 $2 -oA nmap_$1_fastVersions | grep '\/tcp' 



#Announce and run Full TCP Portscan
printf "\n\nRunning ${RED}Full TCP${NC} Portscan on $2...\nSaving found ports to ${RED}nmap_$1_TCPports${NC}\n"
nmap -p- -r -T4 "$2" | grep '\/tcp' | cut -d '/' -f 1 | tr '\n' ',' > "nmap_$1_TCPports"
benmap_TCPports=$(cat "nmap_$1_TCPports")
printf "${RED}TCP Ports${NC} found: ${RED} $benmap_TCPports ${NC} \n \n"


#Announce and run service ID on found full tcp ports
printf "\nRunning ${RED}TCP Port${NC} Service Version ID... \n"
nmap -sV -p"$benmap_TCPports" -T4 "$2" -oA nmap_$1_TCPVersions | grep '\/tcp' 



## --- may include UDP functionality if deemed necessary -----
#printf "\n\nRunning Full UDP Portscan on $2\nSaving found ports to nmap_$1_UDPports... \n"
#nmap -p- -r -T4 "$2" | grep '\/tcp' | cut -d '/' -f 1 | tr '\n' ',' > nmap_$1_UDPports
#benmap_UDPports=$(cat nmap_$1_UDPports)
#printf "Ports found: ${GREEN} $benmap_UDPports ${NC} \n \n"


##Anounce and run VulnScan on all run ports
printf "\n\n ${YELLOW}Running TCP Port VulnScan${NC}... \n -oA flag used, saving output to ${YELLOW}nmap_$1_tcpvuln${NC} \n\n"

nmap -p"$benmap_TCPports" -T4 --script=vuln "$2" -oA "nmap_$1_tcpVuln"


unset benmap_tcpports
unset benmap_fastports
#unset benmap_UDPports

unset RED
unset NC
unset GREEN




