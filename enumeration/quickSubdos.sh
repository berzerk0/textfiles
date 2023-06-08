#!/bin/sh

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "\n ${RED}Error: ${NC} No domain provided \n\n"
  exit 1
fi

### CHECK FOR BINARIES
#Pup - # https://github.com/EricChiang/pup
gotPup=$(command -v  pup 2>/dev/null)
if [ ! "$gotPup" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}pup${NC} binary not in PATH\n"
	exit 1
fi
unset gotPup

#subfinder - # https://github.com/projectdiscovery/subfinder
gotSubfinder=$(command -v  subfinder 2>/dev/null)
if [ ! "$gotSubfinder" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}subfinder${NC} binary not in PATH\n"
	exit 1
fi
unset gotSubfinder

#findomain - # https://github.com/Findomain/Findomainr
gotFindomain=$(command -v  findomain 2>/dev/null)
if [ ! "$gotFindomain" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}findomain${NC} binary not in PATH\n"
	exit 1
fi
unset gotFindomain


singleDomain="$1"

#Find the subdos
fileNameStub=$(echo "$1" | tr '.' '_') #name for the output files


#Cert transparency a la Cale Black
printf " [+] Scraping crt.sh for %s...\n" "$singleDomain"
curl "https://crt.sh/?q=$singleDomain" -s | pup 'tr tr td text{}' | grep "$singleDomain" \
| grep -vE "^\*" | grep -v '@' | sort -u >> "$fileNameStub"_subdos_crt.txt


# subfinder
printf " [+] Running subfinder on %s...\n" "$singleDomain"

# flags: silent, single domain, output to file
subfinder -silent -d "$singleDomain" -o "$fileNameStub"_subdos_subfinder.txt 1>/dev/null


#findomain
printf " [+] Running findomain on %s...\n" "$singleDomain"

# flags: quiet, single domain, unique output
findomain -q -t "$singleDomain" -u "$fileNameStub"_subdos_crt.txt 1>/dev/null

cat "$fileNameStub"_subdos_*.txt | sort -u > "$fileNameStub"_subdos_all.txt

printf " [+] Done!\n\n"
printf "Found %s unverified subdomains for %s \n" $(wc -l "$fileNameStub"_subdos_all.txt | cut -d ' ' -f 1) "$singleDomain"

unset fileNameStub


