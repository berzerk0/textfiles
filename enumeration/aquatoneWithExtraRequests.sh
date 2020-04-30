#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


#aquatone - for scanning and reporting
gotAquatone=$(command -v aquatone 2>/dev/null)
if [ ! "$gotAquatone" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}aquatone${NC} binary not in PATH\n"
	printf " Using the precompiled aquatone binary from GitHub is most reliable\n"

	exit 1
fi
unset gotAmass

#chromium - used by aquatone
gotChromium=$(command -v chromium 2>/dev/null)
if [ ! "$gotChromium" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}chromium${NC} binary not in PATH\n"
	printf " Chromium is required for aquatone to function\n"
	exit 1
fi
unset gotChromium

#httpie - used by to fetch pretty requests
gotHttpie=$(command -v http 2>/dev/null)
if [ ! "$gotHttpie" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}httpie${NC} binary not in PATH\n"
	printf " httpie is required for obtaining pretty requests function\n"
	exit 1
fi
unset gotHttpie




#1 = hosts file

hostsFile="$1"


## aquatone - performs an "extra large" portscan of the subdomains provided,
## takes a screenshot of each found webserver, gathers headers, and more

## extra large portscan scans the following 72 TCP ports
## xlarge: 80, 81, 300, 443, 591, 593, 832, 981, 1010, 1311, 2082, 2087, 2095
## 2096, 2480, 3000, 3128, 3333, 4243, 4567, 4711, 4712, 4993, 5000, 5104, 5108,
## 5800, 6543, 7000, 7396, 7474, 8000, 8001, 8008, 8014, 8042, 8069, 8080, 8081,
## 8088, 8090, 8091, 8118, 8123, 8172, 8222, 8243, 8280, 8281, 8333, 8443, 8500,
## 8834, 8880, 8888, 8983, 9000, 9043, 9060, 9080, 9090, 9091, 9200, 9443, 9800,
## 9981, 12443, 16080, 18091, 18092, 20720, 28017

if [ ! -f "$hostsFile" ]; then
    printf 'Hosts file not found\n Aquatone scan cancelled'
		exit 1
fi

printf "Beginning ${GREEN}aquatone${NC} scan...\n\n"
cat "$hostsFile" | aquatone -ports "xlarge"


# HTTP requests, as well as 404's
printf "Beginning ${GREEN}GET, 404 Request, and no Host Header ${NC} \
gathering...\n\n"


if [ ! -f "aquatone_urls.txt" ]; then
    printf 'aquatone urls file not found\n Request gathering cancelled'
		exit 1
fi

if [ ! -d "GET_requests" ]; then
	mkdir "GET_requests"
fi

if [ ! -d "404_requests" ]; then
	mkdir "404_requests"
fi

if [ ! -d "noHost_requests" ]; then
	mkdir "noHost_requests"
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


unset getFileName
unset UA_A
unset UA_B
unset ranString



printf "Process complete!\n\n"
