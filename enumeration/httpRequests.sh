#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
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




#1 = hosts file

hostsFile="$1"


if [ ! -d "GET_requests" ]; then
	mkdir "GET_requests"
fi

#split into two lines because line length limits and scrubbery
UA_A="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, "
UA_B="like Gecko) Chrome/74.0.3729.169 Safari/537.36"
ranString=$(tr -dc 'a-zA-Z\_\-0-9' < /dev/urandom | fold -w10 | head -1)


for i in $(cat aquatone_urls.txt);
do

	getFileName=$(echo -n "$i" | tr -d '/' | tr '.:' '_')

	http --verify=no -v "$i" User-Agent:"$UA_A$UA_B" Referer:"$i" \
> GET_requests/"$getFileName"

	http --verify=no -v "$i$ranString" User-Agent:"$UA_A$UA_B" Referer:"$i" \
> 404_requests/"$getFileName-404"


	http --verify=no -v "$i" User-Agent:"$UA_A$UA_B" Host:" " \
> noHost_requests/"$getFileName-noHost"

done


unset getFileName UA_A UA_B ranString



printf "Process complete!\n\n"
