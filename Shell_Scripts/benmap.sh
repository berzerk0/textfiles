#!/bin/bash

# $1 = machine name
# $2 machine IP

#RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


mkdir ~/CTFs/$1 && cd ~/CTFs/$1
touch "NOTES_$1.txt"

printf "Running Fast Portscan on $2\nSaving FastPorts to nmap_$1_fastports... \n"
nmap -F -r -T4 "$2"| grep '\/tcp' | cut -d '/' -f 1 | tr '\n' ',' > "nmap_$1_fastports"
benmap_fastports=$(cat "nmap_$1_fastports")
printf "Ports found: ${GREEN} $benmap_fastports ${NC} \n \n"


printf "Running FastPort Service Version ID... \n \n"
nmap -sV -p"$benmap_fastports" -T4 $2 -oA nmap_$1_fastVersions | grep '\/tcp' 




printf "\n\nRunning Full TCP Portscan on $2\nSaving found ports to nmap_$1_TCPports... \n"
nmap -p- -r -T4 "$2" | grep '\/tcp' | cut -d '/' -f 1 | tr '\n' ',' > nmap_$1_TCPports
benmap_TCPports=$(cat nmap_$1_TCPports)
printf "Ports found: ${GREEN} $benmap_tcpports ${NC} \n \n"


printf "\nRunning TCP-Port Service Version ID... \n"
nmap -sV -p"$benmap_TCPports" -T4 "$2" -oA nmap_$1_TCPVersions | grep '\/tcp' 



#printf "\n\nRunning Full UDP Portscan on $2\nSaving found ports to nmap_$1_UDPports... \n"
#nmap -p- -r -T4 "$2" | grep '\/tcp' | cut -d '/' -f 1 | tr '\n' ',' > nmap_$1_UDPports
#benmap_UDPports=$(cat nmap_$1_UDPports)
#printf "Ports found: ${GREEN} $benmap_UDPports ${NC} \n \n"


printf "\n\n Running TCP Port VulnScan... \n"
nmap -p"$benmap_tcpports" -T4 --script=vuln "$2" -oA nmap_$1_tcpVuln


unset benmap_tcpports
unset benmap_fastports
#unset benmap_UDPports





