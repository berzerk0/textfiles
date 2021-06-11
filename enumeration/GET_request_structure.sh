#!/bin/bash

RED='\033[0;31m'
#GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


#httpie - used by to fetch pretty requests
# from kali, apt-get install http
gotHttpie=$(command -v http 2>/dev/null)
if [ ! "$gotHttpie" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}httpie${NC} binary not in PATH\n"
	printf " httpie is required for obtaining pretty requests functionality\n"
	exit 1
fi
unset gotHttpie

if [ $# -ne 1 ]; then
	printf "Usage: ./GET_REQ_SCRIPT.sh [Hosts File]\n \
Where the hosts file has one domain per line and is in the current directory.\n"
	exit 1
fi


#1 = hosts file
# include the domains to send GET requests
hostFile="$1"

# does the host file exist?
# show error if not
if [ ! -f "$hostFile" ] || [ ! -s "$hostFile" ]
then
    printf "\n [-] Error: %s host file not found in current directory,\
 or is empty\n"  "$hostFile"
    exit 1
fi


# check to see that a directory called "GET_requests" exists in the current dir
# if not, create one
if [ ! -d "GET_requests" ]; then
	mkdir "GET_requests"
fi

#split into two lines because line length limits and scrubbery
UA_A="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, "
UA_B="like Gecko) Chrome/74.0.3729.169 Safari/537.36"
# ranString=$(tr -dc 'a-zA-Z\_\-0-9' < /dev/urandom | fold -w10 | head -1)

protocol="https://"
path="pathNameHere"

printf "Checking %s domains...\n\n" $(wc -l "$hostFile" | cut -d ' ' -f 1)

# read each line from the hosts file
for domain in $(cat "$hostFile")
do

	#create a filename for each of the paths
	getFileName=$(echo "$domain" | tr -d '/' | tr '.:' '_')

	# send the request, ignoring HTTPS problems (which caused false negatives)
	http --verify=no --print=hb --timeout=2 --check-status \
  "$protocol$domain$path" Host:"$domain" User-Agent:"$UA_A$UA_B" \
  Referer:"$domain" > GET_requests/"$getFileName" 2>/dev/null

done


unset getFileName UA_A UA_B ranString hostFile protocol path domain



printf "Process complete!\n\n"
