#!/bin/bash

## $1 = the "output" name

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

function usageErrorMessage
{
	printf " ${RED}Usage: ${NC} ./pocketRocket.sh [Output Name] \
[Recurse Choice - 'r' or 'n']\n Where [Output Name] is a suffix you want to \
apply to generated files\n \and [Recurse Choice] sets recursive subdomain\
bruteforcing\n\n"

	printf " ${YELLOW}./pocketRocket ABC recursive ${NC} will create \
files like ${GREEN}amass_LiveSubdomains_ABC.txt${NC} and search for \
subdomains recursively, which may take a very long time but is more \
thorough.\n\n"

printf " ${YELLOW}./pocketRocket XYZ nonrecursive ${NC} will create \
files like ${GREEN}amass_LiveSubdomains_XYZ.txt${NC} and will not search for \
subdomains recursively, which is faster but less thorough.\n\n"

	exit 1
}


# Display error if not enough arguments given
if [ $# -ne 2 ]; then
	printf "\n ${RED}Error: ${NC} Not enough arguments\n\n"
	usageErrorMessage
fi


## CHECK FOR RECURSION INSTRUCTIONS
if [ "$2" != "r" ] && [ "$2" != "n" ]; then

	printf "\n ${RED}Error: ${NC} Invalid Recursion Flag '$2'\n\n"
	usageErrorMessage

fi

### CHECK FOR BINARIES

#findomain - for fast subdomain enum
gotFindomain=$(which findomain 2>/dev/null)
if [ ! "$gotFindomain" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}findomain${NC} binary not in PATH\n"
	exit 1
fi
unset gotFindomain

#amass - for more subdomain enum
gotAmass=$(which amass 2>/dev/null)
if [ ! "$gotAmass" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}amass${NC}binary not in PATH\n"
	printf " Using the precompiled Amass binary from GitHub has been more \
	reliable than installing with 'apt-get' from Kali repos. \n"
	exit 1
fi
unset gotAmass

#aquatone - for scanning and reporting
gotAquatone=$(which aquatone 2>/dev/null)
if [ ! "$gotAquatone" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}aquatone${NC} binary not in PATH\n"
	printf " Using the precompiled aquatone binary from GitHub is most reliable\n"

	exit 1
fi
unset gotAmass

#chromium - used by aquatone
gotChromium=$(which chromium 2>/dev/null)
if [ ! "$gotChromium" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}chromium${NC} binary not in PATH\n"
	printf " Chromium is required for aquatone to function\n"
	exit 1
fi
unset gotChromium

#httpie - used by to fetch pretty requests
gotHttpie=$(which http 2>/dev/null)
if [ ! "$gotHttpie" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}httpie${NC} binary not in PATH\n"
	printf " httpie is required for obtaining pretty requests function\n"
	exit 1
fi
unset gotHttpie



## CHECK FOR SCOPE FILES

inScopeDomainFile="./inScope_domains.txt"

if [ ! -f "$inScopeDomainFile" ]; then
    printf " ${RED}Error: ${NC} ./inScope_domains.txt does not exist\n"
		printf " Please create this file\n\n"
		exit 1
fi

blacklistFile="./blacklist.txt"

if [ ! -f "$blacklistFile" ]; then
    printf "${YELLOW}blacklist.txt not found${NC} in current directory\n"
		read  -n 1 -p "Press any key to accept this or CTRL-C to exit"
fi



findomain_RawSubFile="findomain_RawSubdomains_$1.txt"
amass_LiveSubdomainOutput="amass_LiveSubdomains_$1"


printf "Beginning enumation with ${GREEN}findomain${NC}...\n\n"

# use findomain to passively grab subdomains more quickly than amass does
findomain -f "$inScopeDomainFile" -u "$findomain_RawSubFile"


printf "Beginning enumation with ${GREEN}Amass${NC}...\n\n"

## Using the passively enumerated subdomains, use amass AGAIN
## to resolve subdomains, and do subdomain bruteforcing

if [ "$2" == "n" ]; then

# 	amass enum -brute -norecursive --public-dns -oA "$amass_LiveSubdomainOutput" \
# -df "$inScopeDomainFile" -blf "$blacklistFile" -nf "$findomain_RawSubFile"

amass enum -brute -norecursive --public-dns -oA "$amass_LiveSubdomainOutput" \
-df "$inScopeDomainFile" -nf "$findomain_RawSubFile"


else

# 	amass enum -brute --public-dns -oA "$amass_LiveSubdomainOutput" \
# -df "$inScopeDomainFile" -blf "$blacklistFile" -nf "$findomain_RawSubFile"

amass enum -brute --public-dns -oA "$amass_LiveSubdomainOutput" \
-df "$inScopeDomainFile" -nf "$findomain_RawSubFile"

fi




## aquatone - performs an "extra large" portscan of the subdomains provided,
## takes a screenshot of each found webserver, gathers headers, and more

## extra large portscan scans the following 72 TCP ports
## xlarge: 80, 81, 300, 443, 591, 593, 832, 981, 1010, 1311, 2082, 2087, 2095
## 2096, 2480, 3000, 3128, 3333, 4243, 4567, 4711, 4712, 4993, 5000, 5104, 5108,
## 5800, 6543, 7000, 7396, 7474, 8000, 8001, 8008, 8014, 8042, 8069, 8080, 8081,
## 8088, 8090, 8091, 8118, 8123, 8172, 8222, 8243, 8280, 8281, 8333, 8443, 8500,
## 8834, 8880, 8888, 8983, 9000, 9043, 9060, 9080, 9090, 9091, 9200, 9443, 9800,
## 9981, 12443, 16080, 18091, 18092, 20720, 28017

if [ ! -f "$amass_LiveSubdomainOutput.txt" ]; then
    printf 'Amass results file not found\n Aquatone scan cancelled'
		exit 1
fi

printf "Beginning ${GREEN}aquatone${NC} scan...\n\n"
cat "$amass_LiveSubdomainOutput.txt" | aquatone -ports "xlarge"




# HTTP requests, as well as 404's
printf "Beginning ${GREEN}GET and 404 Request${NC} gathering...\n\n"


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

done


unset getFileName
unset UA_A
unset UA_B
unset ranString
unset findomain_RawSubFile
unset amass_RawSubdomainOutput
unset amass_LiveSubdomainOutput

printf "pocketRocket complete!\n\n"
