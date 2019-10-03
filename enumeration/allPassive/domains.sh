#!/bin/bash

## All passive, just DNS requests to public servers and HTTP GET requests
## $1 = the "output" name

## This script does not perform verification!

## Display error if not enough arguments given
if [ $# -ne 1 ]; then
	echo "Usage: ./domains.sh 'Output Name'"
  echo "Where 'Output Name' is a suffix you want to apply to generated files"
	exit 1
fi

## starter domains - the 'seed' domains with which to start with

starterFile="starter_domains.txt"
foundDomainFile="found_Domains_$1.txt"
amassDomainLog="amass_Domains_$1.csv"
amassDomainErrorLog="amass_Domains_$1.log"
vDNS_file="VDNS_rWhois_$1.txt"


## Starting from a list of starter domains, use amass to identify other domains
## registered to the same owner

if [ ! -f "starter_domains.txt" ]; then
    printf "%s domain file not found in current directory.\n" "$starterFile"
    exit 1
fi



## check to see if amass binary is in path
## amass
gotAmass=$(which amass 2>/dev/null)
if [ ! "$gotAmass" ]; then
	printf " [-] Error: amass binary not in PATH\n"
	printf " Using the precompiled Amass binary from GitHub has been more \
	reliable than installing with 'apt-get' from Kali repos. \n"
	exit 1
fi
unset gotAmass


## amass intel to find domains
## this happens entirely passively, and no DNS resolution is attempted



printf " [+] Gathering domains with AMASS based on %s starter domain(s)... \n" \
"$(wc -l "$starterFile" | cut -d ' ' -f 1)"

amass intel -whois -df starter_domains.txt -log "$amassDomainErrorLog" \
-dir "$(pwd)" -src -o "$amassDomainLog" && tr -s ' ' < "$amassDomainLog" \
| cut -d ' ' -f 2 >> "$foundDomainFile"

tr -s ' ' < "$amassDomainLog" | tr -d '[]' | tr ' ' '\t' \
| awk '{print $2","$1}' > tmp; mv tmp "$amassDomainLog"


printf "\n [+] AMASS identified %s domains \n\n" \
"$(wc -l "$foundDomainFile" | cut -d ' ' -f 1 )"

# Copy and paste results from ViewDNS.info since I am new to webscraping
# and manually fetch viewDNS domains

if [ ! -f "$vDNS_file" ]; then
    printf "Go and fetch results from viewDNS, and save it as %s\n" "$vDNS_file"
		printf 'Find it at https://viewdns.info/reversewhois/?q=[QUERY]\n\n'

		echo "Copy the table from the browser, paste it into a text file 'a.txt'"
		echo "Repeat as needed, including options like registrant emails, etc."
		printf "When complete, run 'cut -f 1 < a.txt > %s' \n\n" "$vDNS_file"

		read  -p  "Type 'skip' or 'ready' to continue, CTRL-C to exit: " vDNS_flag

		while [ "$vDNS_flag" != "skip" ] && [ "$vDNS_flag" != "ready" ]
			do
		  	read -p "Type 'skip' or 'ready' to continue or CTRL-C to exit: " \
vDNS_flag
			done

fi

## if user has entered viewDNS files
if [ "$vDNS_flag" == "ready" ] && [[ -f "$vDNS_file" ]]; then
	cat "$vDNS_file" >> "$foundDomainFile"

else
	printf "User opted not to use %s, or it was not found \n\n" "$vDNS_file"
fi

## concatenate found domains
sort -u "$foundDomainFile" > tmp && mv tmp "$foundDomainFile"


printf "Found %s domains\n" "$(wc -l "$foundDomainFile" | cut -d ' ' -f 1)"
printf "Note that these domains have not been verified."


unset vDNS_file
unset vDNS_flag
unset foundDomainFile
unset amassDomainLog
unset amassDomainErrorLog
