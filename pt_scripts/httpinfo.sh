#!/bin/sh

# $1 = hosts file, one hostname per line

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf " ${RED}Usage: ${NC} ./http_info.sh HOSTSFILE\nHosts file must have one hostname per line.\n"
	exit 1
fi

if [ ! -f "$1" ]; then
printf " ${RED}Error: ${NC} Hosts file not found\n"
	exit 1
fi


http_info_thisdir=$(pwd)/http_info_results

if [ -d "$http_info_thisdir" ]; then
	printf " ${RED}Error: ${NC} Directory already exists.\n Delete${YELLOW} $http_info_thisdir\n${NC}"
	exit 1
fi

# Create host directories
http_info_numOfHosts=$(egrep -v '^\s*$' $1 | wc -l | cut -d ' ' -f 1)


mkdir $http_info_thisdir


for i in $(cat $1 | egrep -v '^\s*$');
do
		http_info_url=$i #URL
    http_info_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)

		http_info_title=$(echo $http_info_url | tr 'a-z' 'A-Z' ) #URL
		echo "---- $http_info_title ---- \n\n" > "$http_info_thisdir/$http_info_cleanname.txt" # create host results directory
done

#List HTTP Options

printf "\nRetrieving HTTP Methods from ${GREEN}$tlstriad_numOfHosts${NC} target(s):\n\n"
for http_info_url in $(cat $1 | egrep -v '^\s*$');
do

	http_info_title=$(echo $http_info_url | tr 'a-z' 'A-Z' ) #URL
  http_info_cleanname=$(echo $http_info_url | tr '.' '_') #name for files/dirs (no dits)

	printf "   Retrieving  ${YELLOW}$http_info_urll${NC}'s supported HTTP methods...\n"
	longline_a=$(printf "\r\nOPTIONS / HTTP/1.0\n\r\n\r" | nc $http_info_url 80 | grep -Ei allow )
	http_info_options=$(printf "$longline_a" | cut -d ' ' -f 2- | tr -d ' ' | tr ',' ' ')


	printf "HTTP Methods\n" >> "$http_info_thisdir/$http_info_cleanname.txt"

		if [ ! "$http_info_options" ]; then
			echo "    Error retrieving OPTIONS - see nmap results" >> "$http_info_thisdir/$http_info_cleanname.txt"
		else
			echo "   $http_info_options" >> "$http_info_thisdir/$http_info_cleanname.txt"
		fi

	done


# Nmap scripting engine information
printf "\nRunning informational ${YELLOW}nmap${NC} HTTP scripts on ${GREEN}$tlstriad_numOfHosts${NC} target(s):\n\n"

for http_info_url in $(cat $1 | egrep -v '^\s*$');
do

		http_info_title=$(echo $http_info_url | tr 'a-z' 'A-Z' ) #URL
	  http_info_cleanname=$(echo $http_info_url | tr '.' '_') #name for files/dirs (no dits)

		printf "   Running NSE scripts on  ${YELLOW}$http_info_urll${NC}...\n"
		nmap -Pn -p80 --script "http-generator,http-mobileversion-checker,http-robots.txt,http-comments-displayer,http-methods" $http_info_url >> "$http_info_thisdir/$http_info_cleanname.txt"

	done


unset http_info_thisdir
unset http_info_url
unset http_info_cleanname

printf "\n--------Process Completed---------\n"
