#!/bin/bash

## All passive, just DNS requests to public servers and HTTP GET requests
## $1 = the "output" name

## This script does not perform verification!


## starter domains - the 'seed' domains with which to start with
starterFile="starter_domains.txt"

foundDomainFile="found_Domains_$1.txt"
amassDomainLog="amass_Domains_$1.csv"
amassDomainErrorLog="amass_Domains_$1.log"
vDNS_file="VDNS_rWhois_$1.txt"

tempfile="$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 12 | head -1)"

## Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "Usage: ./domains_allpassive.sh 'Output Name' \n\
Where 'Output Name' is a suffix you want to apply to generated files\n\
Ensure that a file called '%s' is present\n" "$starterFile"
	exit 1
fi


## Starting from a list of starter domains, use amass to identify other domains
## registered to the same owner

if [ ! -f "$starterFile" ] || [ ! -s "$starterFile" ]
then
    printf "%s domain file not found in current directory, or is empty\n" \
 "$starterFile"
    exit 1
fi


## check to see if amass binary is in path
# this script used with Amass 3.4.4
# https://github.com/OWASP/Amass
gotAmass=$(command -v amass 2>/dev/null)
if [ ! "$gotAmass" ]; then
	printf " [-] Error: amass binary not in PATH\n \
Using the precompiled Amass binary from GitHub has been more \
reliable than installing with 'apt-get' from Kali repos.\n\n"
	exit 1
fi
unset gotAmass



printf " [+] Passively gathering domains with Amass based on %s \
starter domain(s)... \n" "$(wc -l "$starterFile" | cut -d ' ' -f 1)"

## amass intel to find domains
## this happens entirely passively, and no DNS resolution is attempted

amass intel -whois -df "$starterFile" -log "$amassDomainErrorLog" \
-dir "$(pwd)" -src -o "$amassDomainLog"

#create clean output file
tr -s ' ' < "$amassDomainLog" | cut -d ' ' -f 2 >> "$foundDomainFile"

#clean up the amass log and remove duplicates
tr -s ' ' < "$amassDomainLog" | tr -d '[]' | tr ' ' '\t' \
| awk '{print $2","$1}' > "$tempfile"
mv "$tempfile" "$amassDomainLog"


printf "\n [+] Amass identified %s domains \n\n" \
"$(wc -l "$foundDomainFile" | cut -d ' ' -f 1 )"

# Copy and paste results from ViewDNS.info since I am new to webscraping
# and manually fetch viewDNS domains
# one day this will be done in a non-bootleg way. One day...

if [ ! -f "$vDNS_file" ]; then
    printf " [+] Go and fetch results from viewDNS, and save it as %s\n \
Find it at https://viewdns.info/reversewhois/?q=[QUERY]\n\n" 	"$vDNS_file"

		printf " [+] Copy the table from the browser, paste it into a text file\
'a.txt'\nRepeat as needed, including options like registrant emails, etc.\n\
When complete, run 'cut -f 1 < a.txt > %s' \n\n" "$vDNS_file"

#wait for user to copy and paste
skipMessage=" [+] Type 'skip' or 'ready' to continue, CTRL-C to exit: "

		read  -p  "$skipMessage" vDNS_flag

		while [ "$vDNS_flag" != "skip" ] && [ "$vDNS_flag" != "ready" ]
			do
		  	read -p "$skipMessage" vDNS_flag
			done

fi

## if user has entered viewDNS files
if [ "$vDNS_flag" == "ready" ] && [[ -f "$vDNS_file" ]]
then
	cat "$vDNS_file" >> "$foundDomainFile"

else
	printf " [+] User opted not to use %s, or it was not found \n\n" "$vDNS_file"
fi

## concatenate and sort found domains
sort -u "$foundDomainFile" > "$tempfile"
mv "$tempfile" "$foundDomainFile"


printf " [+] Found %s domains\n [+] Note that these domains have not been \
verified. \n\n" "$(wc -l "$foundDomainFile" | cut -d ' ' -f 1)"



unset amassDomainErrorLog amassDomainLog foundDomainFile starterFile vDNS_file
unset vDNS_flag tempfile skipMessage
