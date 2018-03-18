#!/bin/bash

# ideas for this script
# support https
# support non-port 80

# $1 = machine name
# $2 machine IP
# $3 interface


#This script is not stealthy!
#messes up if you don't use the raw ip


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Display error if not enough arguments given
if [ $# -lt 3 ]; then
	printf " ${RED}Usage: ${NC} ./httpSalvo.sh target_nickname target_IP interface port (if not 80)\n"
	exit 1
fi

#if [ $# -eq 4 ]; then
#	$salvo_port=$4
#else
#	$salvo_port="80"
#fi



printf "\n\n${YELLOW}fimap ${NC} running now, with depth ${YELLOW}3${NC}.\nSaving to ${GREEN}$(pwd)/fimap_result ${NC} \n"
fimap -H -d 3 -u "http://$2" -w /tmp/fimap_output | tee fimap_result



printf "\n\n${YELLOW}Nikto${NC} running now:\nSaving to ${GREEN}$(pwd)/nikto_result.txt ${NC} \n"
nikto -h "$1" > nikto_result.txt &


#nikto -h "$1" -o nikto_result.txt
dirsearch -u "" -e php,txt,sh,html,htm,js --simple-report=dirsearch_quick


#only show 200s ? separate file for 200s?
