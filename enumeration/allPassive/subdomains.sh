#!/bin/bash

## All passive, just DNS requests to public servers and HTTP GET requests
## $1 = the "output" name

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	echo "Usage: ./subdomains.sh 'Output Name'"
  echo "Where 'Output Name' is a suffix you want to apply to generated files"
	exit 1
fi


#findomain - for fast subdomain enum
gotFindomain=$(which findomain 2>/dev/null)
if [ ! "$gotFindomain" ]; then
	printf "[-] Error: findomain binary not in PATH\n"
	exit 1
fi
unset gotFindomain

#amass - for more subdomain enum
gotAmass=$(which amass 2>/dev/null)
if [ ! "$gotAmass" ]; then
	printf " [-] Error: amass binary not in PATH\n"
	printf " Using the precompiled Amass binary from GitHub has been more \
	reliable than installing with 'apt-get' from Kali repos. \n"
	exit 1
fi
unset gotAmass



foundDomainFile="found_Domains_$1.txt"
findomain_RawSubFile="findomain_RawSubdomains_$1.txt"
amass_RawSubdomainOutput="amass_RawSubdomains_$1"
amass_LiveSubdomainOutput="amass_LiveSubdomains_$1"


findomainQuestion=$'Would you like to use findomain before amass?

findomain can be used to identify subdomains much more quickly than Amass can
but you will not be able to tell what technique (Scraping, APIs, etc.) was
used to identify subdomains found with findomain.\n
Yes or no: '

read -p "$findomainQuestion" findomainFlag

while [ "$findomainFlag" != "yes" ] && [ "$findomainFlag" != "no" ]
  do
    read -p "$findomainQuestion" findomainFlag
  done

unset findomainQuestion

if [ "$findomainFlag" == "yes" ]; then
  ## Use findomain to grab some subdomains a little bit quicker than amass will
  printf " [+] Running findomain for %s domain(s)... \n" \
  "$(wc -l "$foundDomainFile" | cut -d ' ' -f 1)"

  findomain -f "$foundDomainFile" -u "$findomain_RawSubFile"


  printf "\n [+] findomain identified %s domains \n\n" \
  "$(wc -l "$findomain_RawSubFile" | cut -d ' ' -f 1)"

  printf "\n [+] Passively enumerating subdomains with Amass... \n"

  ## using found domains, use Amass to find more subdomains
  ## include those already found by findomain
  ## this step does not include brute forcing subdomains
  ## Use this when going purely passive
  amass enum -passive -oA "$amass_RawSubdomainOutput" -df "$foundDomainFile" \
  -nf "$findomain_RawSubFile"

# if user opts not to use findomain
else
  echo -n "" > "$findomain_RawSubFile"
	printf "User opted not to use findomain\n"

  printf "\n [+] Passively enumerating subdomains with Amass... \n"

  ## using found domains, use Amass to find more subdomains
  ## include those already found by findomain
  ## this step does not include brute forcing subdomains
  ## Use this when going purely passive
  amass enum -passive -oA "$amass_RawSubdomainOutput" -df "$foundDomainFile"

fi


printf "\n [+] Passively identified %s unverified subdomains \n\n" \
"$(wc -l "$amass_RawSubdomainOutput" | cut -d ' ' -f 1)"


printf " [+] Performing DNS grinding to find/verify subdomains with Amass... \n"

## Using the passively enumerated subdomains, use amass AGAIN
## to resolve subdomains, and do subdomain bruteforcing
amass enum -brute --public-dns -oA "$amass_LiveSubdomainOutput" \
-df "$foundDomainFile" -nf "$amass_RawSubdomainOutput.txt"

printf "Found %s unverified subdomains\n" \
"$(wc -l "$amass_RawSubdomainOutput.txt" | cut -d ' ' -f 1)"

printf "And %s verified subdomains\n" \
"$(wc -l "$amass_LiveSubdomainOutput.txt" | cut -d ' ' -f 1)"
